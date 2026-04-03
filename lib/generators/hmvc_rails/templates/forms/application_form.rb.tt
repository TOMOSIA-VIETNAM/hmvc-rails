# frozen_string_literal: true

class ApplicationForm
  extend ActiveModel::Translation

  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  def initialize(attributes = {})
    self.class.attribute_names.each do |column|
      self.class.attribute(column.to_sym)
    end

    super attributes
  end

  def valid!
    raise ExceptionError::UnprocessableEntity, error_messages.to_json unless valid?
  end

  private

  def error_messages
    errors.messages.map { |key, value| { key => value.first } }
  end

  def attribute_names
    []
  end
end
