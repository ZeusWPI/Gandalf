require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "uploading partially failed registrations" do

    # Must be logged in
    sign_in users(:tom)

    # Quick check for the used fixture
    three = registrations(:three)
    assert_equal 0, three.paid

    # Posting the csv file
    post :upload, {
      event_id: 1,
      separator: ';',
      amount_column: 'Amount',
      csv_file: fixture_file_upload('files/unsuccesful_registration_payments.csv') }

    # Check if the correct rows failed.
    assert_not_nil assigns(:csvfails)
    assigns(:csvfails).each do |csvfail|
      assert_match /FAIL.*/, csvfail.to_s
    end

    # Check if the flash is correct
    assert_equal 'Updated 1 payment successfully.', flash[:success]
    assert_equal 'The rows listed below contained an invalid code, please fix them by hand.', flash[:error]

    # Check if the success registration got changed.
    assert_equal 0.01, three.reload.paid

  end

end
