class IBANValidator < ActiveModel::Validator
  def validate(record)
    unless record.bank_number.blank? || IBANTools::IBAN.valid?(record.bank_number)
      record.errors[:bank_number] << 'is not a valid IBAN.'
    end
  end
end
