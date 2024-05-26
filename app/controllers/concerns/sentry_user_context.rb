# frozen_string_literal: true

module SentryUserContext
  extend ActiveSupport::Concern

  included do
    before_action :set_sentry_context
  end

  private

  def sentry_user_context
    {}.tap do |user|
      next unless current_user

      user[:id] = current_user.id
      user[:email] = current_user.cas_mail
      user[:name] = current_user.username
    end
  end

  def set_sentry_context
    Sentry.set_user(sentry_user_context)
  end
end
