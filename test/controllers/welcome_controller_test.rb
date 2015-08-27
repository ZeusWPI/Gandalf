require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods

  def setup
    stub_request(:get, 'http://fkgent.be/api_isengard_v2.php')
      .with(query: hash_including(u: ''))
      .to_return(body: 'FAIL')
  end

  test 'should get index' do
    get :index
    assert_response :success
  end
end
