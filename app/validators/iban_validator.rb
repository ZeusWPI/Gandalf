# frozen_string_literal: true

class IbanValidator < ActiveModel::Validator
  def validate(record)
    unless record.bank_number.blank? or IBANTools::IBAN.valid? record.bank_number
      record.errors[:bank_number] << 'is not a valid IBAN.'
    end
  end
end

