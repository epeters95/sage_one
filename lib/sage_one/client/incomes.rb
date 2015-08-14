module SageOne
  class Client
    module Incomes

      # @example Get all incomes
      #   SageOne.incomes
      def incomes(options={})
        get("incomes", options)
      end

      def create_income(options)
        post('incomes', income: options)
      end

    end
  end
end

