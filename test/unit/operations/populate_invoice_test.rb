require 'test_helper'

class PopulateInvoiceTest < ActiveSupport::TestCase
  def add_tomato(tag, time = time = Date.new(2000,1,2))
    @user.tomatoes.create! created_at: time, tags: [tag]
  end

  setup do
    @user = User.create!
    @invoice = Invoice.create!(
      user: @user,
      period_starts_on: Date.new(2000,1,1),
      period_ends_on: Date.new(2000,1,14)
    )
  end

  test 'creates invoice entry combining tomatoes with same tag and same day' do
    add_tomato "foo"
    add_tomato "foo"

    PopulateInvoice.call(@invoice)
    assert_equal 1, @invoice.invoice_entries.count
    entry = @invoice.invoice_entries.first
    assert_equal 1, entry.hours
    assert_equal ["foo"], entry.tags
  end

  test 'separate entries for separate days' do
    add_tomato "foo"
    add_tomato "foo", Date.new(2000,1,3)

    PopulateInvoice.call(@invoice)
    assert_equal 2, @invoice.invoice_entries.count
  end

  test 'separate entries for separate tags' do
    add_tomato "foo"
    add_tomato "bar"

    PopulateInvoice.call(@invoice)
    assert_equal 2, @invoice.invoice_entries.count
  end
end
