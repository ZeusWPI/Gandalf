require 'test_helper'

class PaymentWebhookControllerTest < ActionController::TestCase
  test "should get mollie" do
    get :mollie
    assert_response :success
  end

end
