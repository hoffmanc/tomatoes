class PopulateInvoice
  def self.call(*args)
    new.call(*args)
  end

  def call(invoice)
    tomatoes = invoice.user.tomatoes.where(created_at: invoice.period_starts_on..invoice.period_ends_on)
    tomatoes.each do |tomato|
      entry = invoice.invoice_entries.
        find_or_initialize_by(
          date: tomato.created_at.to_date,
          tags: tomato.tags
        )
      entry.hours ||= 0
      entry.hours += 0.5
      entry.save!
    end
    true
  end
end
