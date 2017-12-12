module InvoicesParams
  def resource_params
    params.require(:invoice).permit(
      :period_starts_on,
      :period_ends_on,
      invoice_entries_attributes: [
        :id,
        :date,
        :description,
        :hours
      ]
    )
  end
end
