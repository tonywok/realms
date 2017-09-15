require 'rspec/expectations'

RSpec::Matchers.define :have_option do |action, target|
  match do |game|
    expect(options(game)).to have_key(key(action, target))
  end

  failure_message do |game|
    "expected #{options(game).keys} to include #{key(action, target)}"
  end

  def key(action, target)
    key = target.respond_to?(:key) ? target.key : target
    [action, key].compact.join(".").to_sym
  end

  def options(game)
    game.current_choice.send(:options_hash)
  end
end
