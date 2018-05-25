module Realms
  module Effects
    class Event < ActiveSupport::Notifications::Event
      attr_reader :id, :key

      def initialize(key, start, ending, transaction_id, id:, **payload)
        @id = id
        @key = key
        super(key.split(".").last, start, ending, transaction_id, payload)
      end
    end
  end
end
