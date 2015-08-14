module SageOne
  class Client
    module LedgerAccounts

      # @example Get all ledger accounts
      #   SageOne.ledger_accounts
      def ledger_accounts(options={})
        get("ledger_accounts", options)
      end

    end
  end
end

