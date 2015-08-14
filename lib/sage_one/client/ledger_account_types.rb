module SageOne
  class Client
    module LedgerAccountTypes

      # @example Get all ledger account_types
      #   SageOne.ledger_account_types
      def ledger_account_types(options={})
        get("ledger_account_types", options)
      end

    end
  end
end

