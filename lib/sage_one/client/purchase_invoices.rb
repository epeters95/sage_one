module SageOne
  class Client
    module PurchaseInvoices

      # Create a purchase invoice
      def create_purchase_invoice(options)
        post('purchase_invoices', purchase_invoice: options)
      end

    end
  end
end

