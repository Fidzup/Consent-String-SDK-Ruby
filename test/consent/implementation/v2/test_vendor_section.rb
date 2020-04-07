require 'minitest/autorun'
require 'iab_consent_string'

class VendorSectionV2Test < Minitest::Test
  def test_bin_vendor_consented
    v = IABConsentString::Consent::Implementation::V2::VendorSectionBuilder.build(is_ranged_encoding: false)
    v.addVendor(5).addVendor(6)
    assert_equal(true, v.isVendorConsented(6))
  end

  def test_ranged_vendor_consented
    v = IABConsentString::Consent::Implementation::V2::VendorSectionBuilder.build(is_ranged_encoding: true)
    v.addVendor(3, 6).addVendor(42)
    assert_equal(true, v.isVendorConsented(6))
  end

end
