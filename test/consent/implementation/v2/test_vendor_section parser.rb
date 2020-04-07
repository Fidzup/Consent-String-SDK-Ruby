require 'minitest/autorun'
require 'iab_consent_string'

class VendorSectionParserV2Test < Minitest::Test
  def test_bin_vendor_consented
    binaryString = "000011" + # Padding
      "0000000000000101" + # Max Vendor Id
      "0" + # is ranged encoding
      "00101" +
      "0000"
    v = IABConsentString::Consent::Implementation::V2::VendorSectionParser.new(IABConsentString::Util::Utils.fromBinaryString(binaryString), 6).parse
    assert_equal(false, v.isVendorConsented(1))
    assert_equal(false, v.isVendorConsented(2))
    assert_equal(true, v.isVendorConsented(3))
    assert_equal(false, v.isVendorConsented(4))
    assert_equal(true, v.isVendorConsented(5))
  end

  def test_ranged_vendor_consented
    binaryString = "000011" + # Padding
      "0000000000000000" + # Max Vendor Id
      "1" + # is ranged encoding
      "000000000010" + # num entry
      "1" + # is ranged
      "0000000000000001" + # vendor id
      "0000000000000100" + # end vendor id
      "0" + # is ranged
      "0000000000001001" # vendor id
    v = IABConsentString::Consent::Implementation::V2::VendorSectionParser.new(IABConsentString::Util::Utils.fromBinaryString(binaryString), 6).parse
    assert_equal(true, v.isVendorConsented(1))
    assert_equal(true, v.isVendorConsented(2))
    assert_equal(true, v.isVendorConsented(4))
    assert_equal(false, v.isVendorConsented(8))
    assert_equal(true, v.isVendorConsented(9))
  end
end