class InvoicesController < ApplicationController
  include InvoicesParams

  before_action :authenticate_user!
  before_action :find_invoice, only: [:edit, :update]

  def new
    @invoice = Invoice.new(user: current_user)
  end

  def create
    @invoice = Invoice.new(resource_params.merge(user: current_user))
    if @invoice.save && PopulateInvoice.call(@invoice)
      redirect_to edit_invoice_path(@invoice)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @invoice.update(resource_params)
      redirect_to edit_invoice_path(@invoice)
    else
      render :edit
    end
  end

  private

  def find_invoice
    @invoice = Invoice.find(params[:id])
    @invoice_entries_by_date = @invoice.invoice_entries.group_by(&:date)
  end
end

