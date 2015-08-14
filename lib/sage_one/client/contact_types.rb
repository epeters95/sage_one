module SageOne
  class Client
    module ContactTypes

      # Get purchase invoice types
      def contact_types(options={})
        get('contact_types', options)
      end

    end
  end
end

