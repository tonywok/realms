require "pry"

module Realms
  class StackGame
    attr_reader :fib, :flows

    def initialize
      @flows = []
      @fib = Fiber.new do
        run(:test1) until @score == 3
      end
      fib.resume
    end

    def decide(option)
      fib.resume(option)
    end

    def choose(options, &block)
      decision = Fiber.yield(options)
      block.call(decision)
    end

    def run(flow_key, *args)
      flows.push(flow_key)
      instance_exec(*args, &FLOWS.fetch(flow_key))
      flows.pop
    end

    def effect(effect_key, *args)
      @score += 1 if effect_key == :yay
    end

    FLOWS = {
      test1: lambda do
        choose([1, 2, 3]) do |num|
          puts "you chose #{num}"
          run(:test2, num)
        end
      end,
      test2: lambda do |prev|
        choose([3, 4, 5]) do |other_num|
          puts "you chose another #{prev + other_num}"
          if other_num > 4
            effect(:yay)
          else
            effect(:nay)
          end
        end
      end,
      test3: lambda do |prev|
        choose([6, 7, 8]) do |other_num|
          puts "you chose another #{prev + other_num}"
          run(:test1)
        end
      end,
    }.freeze
  end
end
