require 'minitest/autorun'
require 'iab_consent_string'

class VendorConsentDecoderTest < Minitest::Test

  def test_NilConsentString
    consentString = nil 
    assert_raises RuntimeError do
      IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)
    end
  end

  def test_NilConsentBytes
    consentBytes = nil
    assert_raises RuntimeError do
      IABConsentString::Consent::VendorConsentDecoder.fromByteArray(consentBytes)
    end
  end

  def test_EmptyConsentString
    consentString = ""
    assert_raises RuntimeError do
      IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)
    end
  end

  def test_DecodingBase64ConsentString
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String("BOVeoB_OVeoFxC-AHAFRBtAAAAAhGAEAD4AXAA2YCEQ")
    assert_match(/ByteBufferVendorConsent{Version=1,Created=1539273535900,LastUpdated=1539273560100,CmpId=190,CmpVersion=7,ConsentScreen=0,ConsentLanguage=FR,VendorListVersion=109,PurposesAllowed=#<Set: {}>,MaxVendorId=529,EncodingType=1}/,vendorConsent.toString)
    assert_kind_of IABConsentString::Consent::VendorConsent, vendorConsent
  end

  def test_DecodingBase64ConsentStringV2
    string = "COxI3cWOxI3cWDCAFEENAgC4AH-AAD4AAIAAAFAXAIqAFAH4AgoBEAEUAECABQAIAAqAP4BABAAMACAAJA.IFukWSQgAIQwgI0QEByFAAAAeIAACAIgSAAQAIAgEQACEABAAAgAQFAEAIAAAGBAAgAAAAQAIFAAMCQAAgAAQiRAEQAAAAANAAIAAggAIYQFAAARmggBC3ZCYzU2yIA.QFukWSQgAIQwgI0QEByFAAAAeIAACAIgSAAQAIAgEQACEABAAAgAQFAEAIAAAGBAAgAAAAQAIFAAMCQAAgAAQiRAEQAAAAANAAIAAggAIYQFAAARmggBC3ZCYzU2yIA.argAC0gBhMQAIA"
    #@type[IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent]
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(string)
    assert_equal(2, vendorConsent.getVersion)
    assert_equal(5, vendorConsent.getCmpVersion)
    assert_equal(194, vendorConsent.getCmpId)
    assert_equal(4, vendorConsent.getConsentScreen)
    assert_equal("EN", vendorConsent.getConsentLanguage)
    assert_equal(32, vendorConsent.getVendorListVersion)
    assert_equal(2, vendorConsent.getTcfPolicyVersion)
    assert_equal(10, vendorConsent.getMaxVendorId)
    assert_equal([6, 8, 9, 10], vendorConsent.getAllowedVendorIds)
    assert_equal([2, 3, 4, 5, 6, 7, 8, 9], vendorConsent.getAllowedPurposeIds)
    assert_equal(true, vendorConsent.getIsServiceSpecific)
    assert_equal(true, vendorConsent.getUseNonStandardStacks)
    assert_equal(true, vendorConsent.isSpecialFeatureOptIn(1))
    assert_equal(false, vendorConsent.isPurposesConsented(1))
    assert_equal(true, vendorConsent.isPurposesConsented(2))
    assert_equal(false, vendorConsent.isAllowedVendor(1))
    assert_equal(true, vendorConsent.isAllowedVendor(2))
    assert_equal(false, vendorConsent.isDisclosedVendor(1))
    assert_equal(true, vendorConsent.isDisclosedVendor(2))
  end

end
