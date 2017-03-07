# frozen_string_literal: true
require 'minitest/assertions'

module Minitest::Assertions
  def assert_passes_validation(schema_path, xml_to_validate)
    schema = Nokogiri::XML::Schema(File.read(schema_path))
    document = Nokogiri::XML::Document.parse(xml_to_validate)
    schema.validate(document)
  end
end

String.infect_an_assertion(
  :assert_passes_validation,
  :must_pass_validation
)
