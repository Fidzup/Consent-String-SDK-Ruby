require 'minitest/autorun'
require 'iab_consent_string'

class VendorV2Test < Minitest::Test
  def test_is_consented_not_ranged
    v = IABConsentString::Consent::Implementation::V2::Vendor.new(3)
    assert_equal(true, v.is_consented?(3))
  end

  def test_is_consented_ranged
    v = IABConsentString::Consent::Implementation::V2::Vendor.new(3, true, 5)
    assert_equal(true, v.is_consented?(5))
    assert_equal(false, v.is_consented?(6))
    assert_equal(false, v.is_consented?(2))
  end

end
