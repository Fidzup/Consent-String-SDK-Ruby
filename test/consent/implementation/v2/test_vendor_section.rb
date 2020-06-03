require 'minitest/autorun'
require 'iab_consent_string'

class VendorSectionV2Test < Minitest::Test
  def test_bin_vendor_consented
    v = IABConsentString::Consent::Implementation::V2::VendorSectionBuilder.build(is_ranged_encoding: false)
    v.addVendor(5).addVendor(6)
    assert_equal(true, v.isVendorConsented(6))
    assert_equal("000000000000011000000110", v.to_bit_string)
  end

  def test_ranged_vendor_consented
    v = IABConsentString::Consent::Implementation::V2::VendorSectionBuilder.build(is_ranged_encoding: true)
    v.addVendor(3, 6).addVendor(42)
    assert_equal(true, v.isVendorConsented(6))
    assert_equal("00000000001010101000000000010100000000000000110000000000000110000000000001010100", v.to_bit_string)
  end

end
