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

RSpec::Matchers.define :have_event do |expected_id, expected_name, expected_payload={}|
  match do |event|
    expect(event.id).to eq(expected_id)
    expect(event.name.to_sym).to eq(expected_name)
    expect(event.payload).to eq(expected_payload)
  end

  failure_message do |event|
    msgs = []
    msgs << "expected event id to be event id to be '#{expected_id}', got '#{event.id}'" unless event.id == expected_id
    msgs << "expected event name to be '#{expected_name}', got '#{event.name}'" unless event.name.to_sym == expected_name
    expected_payload.each do |key, value|
      expected_value = expected_payload[key]
      msgs << "expected event #{key} to equal '#{expected_value}', got '#{value}'" unless value == expected_value
    end
    msgs.join("\n")
  end
end
