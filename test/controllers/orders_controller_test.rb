require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods

  def setup
    stub_request(:get, 'http://fkgent.be/api_isengard_v2.php').with(query: hash_including(u: /.*/)).to_return(body: 'FAIL')
    stub_request(:get, 'http://registratie.fkgent.be/api/v2/members/clubs_for_ugent_nr.json').with(query: hash_including(key: /.*/)).to_return(body: '{}')

    sign_in create(:user, admin: true)
  end

  test 'uploading partially failed orders' do
    # Quick check for the used fixture
    three = orders(:three)
    assert_equal 0, three.paid

    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      # Posting the csv file
      post :upload,         event_id: events(:codenight),
                            separator: ';',
                            amount_column: 'Amount',
                            csv_file: fixture_file_upload('files/unsuccesful_registration_payments.csv')
    end

    # Check if the correct rows failed.
    assert_not_nil assigns(:csvfails)
    assigns(:csvfails).each do |csvfail|
      assert_match(/FAIL.*/, csvfail.to_s)
    end

    # Check if the flash is correct
    assert_equal 'Updated 1 payment successfully.', flash[:success]
    assert_equal 'The rows listed below contained an invalid code, please fix them by hand.', flash[:error]

    # Check if the success registration got changed.
    assert_equal 0.01, three.reload.paid
  end

  test 'resend actually sends an email' do
    order = create(:free_order)

    assert_difference 'ActionMailer::Base.deliveries.size', order.tickets.count do
      xhr :get, :resend, event_id: order.event, id: order
    end
  end

  test 'resend sends order email when !is_paid' do
    order = create(:unpaid_order)
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      xhr :get, :resend, event_id: order.event, id: order
    end

    email = ActionMailer::Base.deliveries.last
    assert_match(/Order for/, email.subject)
  end

  test 'resend sends ticket emails when is_paid' do
    order = create(:free_order)

    assert_difference 'ActionMailer::Base.deliveries.size', order.tickets.count do
      xhr :get, :resend, event_id: order.event, id: order
    end

    email = ActionMailer::Base.deliveries.last
    assert_match(/Ticket for/, email.subject)
  end

  test 'manual full paying works for unpaid tickets' do
      order = create(:unpaid_order)

      assert_difference 'ActionMailer::Base.deliveries.size', order.tickets.count do
        update_order(order, 0)
      end

      assert_equal order.price, order.reload.paid

      ActionMailer::Base.deliveries.last(order.tickets.count) do |email|
        assert_match(/Ticket for/, email.subject)
      end
  end

  test 'manual full paying works partially paid tickets' do
      order = create(:partially_paid_order)

      assert_difference 'ActionMailer::Base.deliveries.size', order.tickets.count do
        update_order(order, 0)
      end

      assert_equal order.price, order.reload.paid

      ActionMailer::Base.deliveries.last(order.tickets.count) do |email|
        assert_match(/Ticket for/, email.subject)
      end
  end

  test 'manual full paying works doesnt mails for fully paid tickets' do
      order = create(:fully_paid_order)

      assert_difference 'ActionMailer::Base.deliveries.size', 0 do
        update_order(order, 0)
      end

      assert_equal order.price, order.reload.paid
  end

  test 'manual partial paying works' do
    orders = [
      create(:unpaid_order),
      create(:partially_paid_order),
      create(:fully_paid_order)
    ]

    to_pay = 0.01

    orders.each do |order|
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        update_order(order, to_pay)
      end
      assert order.price > order.reload.paid
      email = ActionMailer::Base.deliveries.last
      assert_match(/Order for/, email.subject)
    end
  end

  test 'manual overpaying works' do
    orders = [
      create(:unpaid_order),
      create(:partially_paid_order),
      create(:fully_paid_order)
    ]

    to_pay = -5

    orders.each do |order|
      # +1 here for the overpayment email
      assert_difference 'ActionMailer::Base.deliveries.size', order.tickets.count + 1 do
        update_order(order, to_pay)
      end
      assert order.price < order.reload.paid

      ActionMailer::Base.deliveries.last(4).first(3) do |email|
        assert_match(/Ticket for/, email.subject)
      end

      email = ActionMailer::Base.deliveries.last
      assert_match(/Overpayment for/, email.subject)
    end
  end

  test 'manual not changing mails nor changes the code' do
    three = orders(:three)
    four = orders(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    [three, four].each do |order|
      paid = order.paid
      code = order.payment_code
      assert_no_difference 'ActionMailer::Base.deliveries.size' do
        xhr :put, :update, {
          event_id: order.event.id,
          id: order.id,
          order: { to_pay: order.to_pay }
        }, remote: true
      end
      assert_equal paid, order.reload.paid
      assert_equal code, order.reload.payment_code
    end
  end

  test 'admins can manage orders from other events' do
    user = create(:user, admin: true)

    ability = Ability.new(user)

    r = orders(:two)
    assert ability.can?(:manage, r)
  end

  private

  def update_order(order, to_pay)
    xhr :put, :update, {
      event_id: order.event,
      id: order,
      order: { to_pay: to_pay }
    }, remote: true
  end
end
