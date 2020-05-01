module Realms
  module Effects
    class Event
      attr_reader :id, :name, :payload

      def initialize(event)
        @id = event.payload.fetch(:id)
        @name = event.name.split(".").last
        @payload = event.payload.except(:id)
      end
    end
  end
end
