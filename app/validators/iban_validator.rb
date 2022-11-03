# frozen_string_literal: true

class IbanValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:bank_number, 'is not a valid IBAN.') unless record.bank_number.blank? || IBANTools::IBAN.valid?(record.bank_number)
  end
end
