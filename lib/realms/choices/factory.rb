module Realms
  module Choices
    class Factory
      def make(options, subject: nil, optionality: false, count: 1)
        opts =  make_options(options, optionality)

        if count > 1
          MultiChoice.new(subject, opts, count: count)
        else
          Choice.new(subject, opts)
        end
      end

      private

      def make_options(options, optionality)
        opts = options.map do |option|
          Option.new(key: option.key, value: option)
        end
        opts << Option.new(key: "none") if optionality
        opts
      end
    end
  end
end
