require 'minitest/autorun'
require 'iab_consent_string'
require 'pry'

class PublisherRestrictionParserV2Test < Minitest::Test
  def test_ranged_vendor_consented
    binaryString = "000011" + # Padding
      "000000000010" + # Num Pub Restriction
      "000010" + # purpose_id
      "01" + # Restriction Type
      "000000000010" + # num entry
      "1" + # is ranged
      "0000000000000001" + # vendor id
      "0000000000000100" + # end vendor id
      "0" + # is ranged
      "0000000000001001" + # vendor id
      "000100" + # purpose_id
      "10" + # Restriction Type
      "000000000010" + # num entry
      "1" + # is ranged
      "0000000000000100" + # vendor id
      "0000000000000111" + # end vendor id
      "0" + # is ranged
      "0000000000001101" # vendor id
    parser = IABConsentString::Consent::Implementation::V2::PublisherRestrictionParser.new(IABConsentString::Util::Utils.fromBinaryString(binaryString), 6)
    pr = parser.parse
    assert_equal(1, pr.getRestriction(2,1))
    assert_equal(1, pr.getRestriction(2,3))
    assert_equal(1, pr.getRestriction(2,9))
    assert_equal(3, pr.getRestriction(3,8))
    assert_equal(3, pr.getRestriction(3,10))
    assert_equal(2, pr.getRestriction(4,5))
    assert_equal(3, pr.getRestriction(4,3))
    assert_equal(2, pr.getRestriction(4,13))
    assert_equal(3, pr.getRestriction(4,14))
    assert_equal(158, parser.current_offset)
    assert_equal(binaryString[6..], pr.to_bit_string)
  end
end