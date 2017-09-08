require 'rspec/expectations'

RSpec::Matchers.define :have_option do |action, target|
  match do |actual|
    expect(actual.options.keys).to include(key(action, target))
  end

  failure_message do |actual|
    "expected #{actual.options.keys} to include #{key(action, target)}"
  end

  def key(action, target)
    key = target.respond_to?(:key) ? target.key : target
    [action, key].compact.join(".").to_sym
  end
end
