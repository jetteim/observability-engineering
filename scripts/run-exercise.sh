#!/usr/bin/env bash
set -euo pipefail

ruby - <<'RUBY'
require "yaml"

def load_yaml(path)
  YAML.safe_load(File.read(path))
end

def assert_subset(expected, actual, path)
  case expected
  when Hash
    raise "expected #{path.join(".")} to be a map" unless actual.is_a?(Hash)
    expected.each do |key, value|
      raise "missing #{(path + [key]).join(".")}" unless actual.key?(key)
      assert_subset(value, actual[key], path + [key])
    end
  when Array
    raise "expected #{path.join(".")} to be a list" unless actual.is_a?(Array)
    expected.each do |value|
      raise "missing #{value.inspect} in #{path.join(".")}" unless actual.include?(value)
    end
  else
    raise "expected #{path.join(".")} == #{expected.inspect}, got #{actual.inspect}" unless actual == expected
  end
end

scenario_count = 0

Dir["tests/scenarios/*.expected.yaml"].sort.each do |expected_path|
  base_path = expected_path.sub(/\.expected\.yaml\z/, "")
  prompt_path = "#{base_path}.prompt.md"
  actual_path = "#{base_path}.actual.yaml"

  prompt = File.read(prompt_path)
  raise "prompt does not invoke skill: #{prompt_path}" unless prompt.include?("$observability-engineering")
  if prompt_path.end_with?("checkout-observability.prompt.md")
    raise "prompt does not hand off pipeline work" unless prompt.include?("$creating-observability-pipelines")
    raise "prompt does not keep backend resources generated" unless prompt.include?("generated outputs")
  end

  expected = load_yaml(expected_path)
  actual = load_yaml(actual_path).fetch("artifacts")

  expected.fetch("expected_artifacts").each do |artifact|
    raise "missing artifact #{artifact}" unless actual.key?(artifact)
  end

  assert_subset(expected.fetch("required_contents"), actual, ["artifacts"])

  puts "exercise prompt: #{prompt_path}"
  puts "expected artifacts: #{expected_path}"
  puts "actual artifacts: #{actual_path}"
  puts "expected contents satisfied"
  scenario_count += 1
end

raise "no scenarios found" if scenario_count.zero?
puts "scenarios validated: #{scenario_count}"
puts "exercise validation ok"
RUBY
