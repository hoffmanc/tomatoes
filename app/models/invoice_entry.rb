require 'mongoid_tags'

class InvoiceEntry
  include Mongoid::Document
  include Mongoid::Document::Taggable

  embedded_in :invoice

  field :dt, as: :date, type: Date
  field :desc, as: :description, type: String
  field :hrs, as: :hours, type: Float
end
