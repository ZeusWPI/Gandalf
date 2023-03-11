# frozen_string_literal: true

require "test_helper"

class FetchClubJobTest < ActiveJob::TestCase
  test "it calls the User::FetchClub action" do
    tom = users(:tom)

    mock = Minitest::Mock.new
    mock.expect :call, nil

    User::FetchClub.stub :new, ->(_) { mock } do
      User::FetchClubJob.perform_now(tom.id)
    end

    assert_mock(mock)
  end
end
