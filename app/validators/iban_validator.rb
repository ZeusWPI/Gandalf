# frozen_string_literal: true

class IbanValidator < ActiveModel::Validator
  def validate(record)
    unless record.bank_number.blank? || IBANTools::IBAN.valid?(record.bank_number)
      record.errors.add(:bank_number, 'is not a valid IBAN.')
    end
  end
end
