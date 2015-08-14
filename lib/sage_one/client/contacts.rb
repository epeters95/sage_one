module SageOne
  class Client
    module Contacts
      # Get a contact record by ID
      # @param [Integer] id Contact ID
      # @return [Hashie::Mash] Contact record
      # @example Get a contact:
      #   SageOne.contact(12345)
      def contact(id)
        get("contacts/#{id}")
      end

      # List all contacts
      def contacts(options={})
        get("contacts", options)
      end

      # Create contact
      def create_contact(options)
        post('contacts', contact: options)
      end

      # Update contact
      def update_contact(id, options)
        put("contacts/#{id}", contact: options)
      end

    end
  end
end