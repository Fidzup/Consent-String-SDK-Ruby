require 'minitest/autorun'
require 'iab_consent_string'

class VendorSectionV2Test < Minitest::Test
  def test_bin_vendor_consented
    v = IABConsentString::Consent::Implementation::V2::VendorSectionBuilder.build(is_ranged_encoding: false)
    v.addVendor(5).addVendor(6)
    assert_equal(true, v.isVendorConsented(6))
    assert_equal("00000000000001100000011", v.to_bit_string)
  end

  def test_ranged_vendor_consented
    v = IABConsentString::Consent::Implementation::V2::VendorSectionBuilder.build(is_ranged_encoding: true)
    v.addVendor(3, 6).addVendor(42)
    assert_equal(true, v.isVendorConsented(6))
    assert_equal("0000000000101010100000000001010000000000000011000000000000011000000000000101010", v.to_bit_string)
  end

end
