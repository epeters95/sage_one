module SageOne
  class Client
    module TaxRates

      # @example Get all tax_rates
      #   SageOne.tax_rates
      def tax_rates(options={})
        get("tax_rates", options)
      end

    end
  end
end

