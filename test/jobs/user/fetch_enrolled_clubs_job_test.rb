# frozen_string_literal: true

require "test_helper"

class FetchEnrolledClubsJobTest < ActiveJob::TestCase
  test "it calls the User::FetchEnrolledClubs action" do
    tom = users(:tom)

    mock = Minitest::Mock.new
    mock.expect :call, nil

    User::FetchEnrolledClubs.stub :new, ->(_) { mock } do
      User::FetchEnrolledClubsJob.perform_now(tom.id)
    end

    assert_mock(mock)
  end
end
