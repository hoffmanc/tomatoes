class Invoice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :pso, as: :period_starts_on, type: Date
  field :peo, as: :period_ends_on, type: Date

  belongs_to :user
  embeds_many :invoice_entries
  accepts_nested_attributes_for :invoice_entries

  validates :period_starts_on, presence: true
  validates :period_ends_on, presence: true

  def period_range
    period_starts_on..period_ends_on
  end
end
