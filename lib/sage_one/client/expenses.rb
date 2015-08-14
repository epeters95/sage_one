module SageOne
  class Client
    module Expenses

      # @example Get all expenses
      #   SageOne.expenses
      def expenses(options={})
        get("expenses", options)
      end

      def create_expense(options)
        post('expenses', expense: options)
      end

    end
  end
end

