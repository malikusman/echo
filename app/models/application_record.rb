# frozen_string_literal: true

# Base abstract ORM class.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
