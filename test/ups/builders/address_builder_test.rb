# frozen_string_literal: true
require 'test_helper'

# rubocop:disable Metrics/ClassLength
class UpsBuildersAddressBuilderTest < Minitest::Test
  # US addresses
  #
  def test_that_it_changes_the_state_to_be_the_abbreviated_state_name
    subject = UPS::Builders::AddressBuilder.new us_address_hash
    assert_equal 'CA', subject.opts[:state]
  end

  def test_that_it_abbreviates_the_state_with_mixed_casing
    subject = UPS::Builders::AddressBuilder.new(
      us_address_hash.merge(state: 'CaLiFoRnIa')
    )
    assert_equal 'CA', subject.opts[:state]
  end

  def test_it_recognized_lower_cased_state_abbreviations
    subject = UPS::Builders::AddressBuilder.new(
      us_address_hash.merge(state: 'ca')
    )
    assert_equal 'CA', subject.opts[:state]
  end

  def test_us_address_xml_dump_is_as_accepted
    subject = UPS::Builders::AddressBuilder.new us_address_hash
    ox_element = subject.to_xml
    assert_equal(
      expected_us_address_xml_dump,
      Ox.dump(ox_element)
    )
  end

  # Canadian addresses
  #
  def test_abbreviates_canadian_state
    subject = UPS::Builders::AddressBuilder.new canadian_address_hash
    assert_equal 'QC', subject.opts[:state]
  end

  def test_abbreviates_mixed_case_canadian_state
    subject = UPS::Builders::AddressBuilder.new(
      canadian_address_hash.merge(state: 'QuEbEc')
    )
    assert_equal 'QC', subject.opts[:state]
  end

  def test_handles_lower_cased_canadian_states
    subject = UPS::Builders::AddressBuilder.new(
      canadian_address_hash.merge(state: 'qc')
    )
    assert_equal 'QC', subject.opts[:state]
  end

  def test_canadian_address_xml_dump_is_as_accepted
    subject = UPS::Builders::AddressBuilder.new canadian_address_hash
    ox_element = subject.to_xml
    assert_equal(
      expected_canadian_address_xml_dump,
      Ox.dump(ox_element)
    )
  end

  # Irish addresses
  #
  def test_normalizes_irish_state
    subject = UPS::Builders::AddressBuilder.new irish_address_hash
    assert_equal 'Dublin', subject.opts[:state]
  end

  def test_raises_when_no_state_is_given
    assert_raises UPS::Exceptions::InvalidAttributeError do
      UPS::Builders::AddressBuilder.new(
        irish_address_hash.merge(
          state: ''
        )
      )
    end
  end

  def test_irish_address_xml_dump_is_as_accepted
    subject = UPS::Builders::AddressBuilder.new irish_address_hash
    ox_element = subject.to_xml
    assert_equal(
      expected_irish_address_xml_dump,
      Ox.dump(ox_element)
    )
  end

  # Document behavior on addresses with special characters
  #
  def test_french_address_xml_dump_is_as_accepted
    subject = UPS::Builders::AddressBuilder.new french_address_hash
    ox_element = subject.to_xml
    assert_equal(
      expected_french_address_xml_dump,
      Ox.dump(ox_element)
    )
  end

  private

  def us_address_hash
    {
      address_line_1: 'Googleplex',
      address_line_2: '1600 Amphitheatre Parkway',
      city: 'Mountain View',
      state: 'California',
      postal_code: '94043',
      country: 'US',
      email_address: 'nobody@example.org'
    }
  end

  def expected_us_address_xml_dump
    @us_xml_dump ||= File.open(
      'test/xml_expectations/expected_us_address.xml',
      'rb',
      &:read
    )
  end

  def canadian_address_hash
    {
      address_line_1: '1253 McGill College',
      city: 'Montreal',
      state: 'Quebec',
      postal_code: 'H3B 2Y5',
      country: 'CA'
    }
  end

  def expected_canadian_address_xml_dump
    @canadian_xml_dump ||= File.open(
      'test/xml_expectations/expected_canadian_address.xml',
      'rb',
      &:read
    )
  end

  def irish_address_hash
    {
      address_line_1: 'Barrow Street',
      city: 'Dublin 4',
      state: 'County Dublin',
      postal_code: '',
      country: 'IE'
    }
  end

  def expected_irish_address_xml_dump
    @irish_xml_dump ||= File.open(
      'test/xml_expectations/expected_irish_address.xml',
      'rb',
      &:read
    )
  end

  def french_address_hash
    {
      address_line_1: '10 rue du Québec',
      address_line_2: 'Derrière le Casino, à gauche du parking',
      city: 'Labège',
      postal_code: '31670',
      country: 'FR',
      email_address: 'nobody@example.org'
    }
  end

  def expected_french_address_xml_dump
    @french_xml_dump ||= File.open(
      'test/xml_expectations/expected_french_address.xml',
      'rb',
      &:read
    )
  end
end
# rubocop:enable Metrics/ClassLength
