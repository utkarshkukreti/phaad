require 'bundler/setup'
require 'phaad'

RSpec.configure do |c|
  def compile(string)
    Phaad::Generator.new(string).emitted
  end

  RSpec::Matchers.define :start_with do |substring|
    match do |string|
      string.start_with?(substring)
    end
  end
end
