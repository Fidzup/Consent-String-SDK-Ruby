require 'minitest/autorun'
require 'iab_consent_string'

class VendorConsentDecoderTest < Minitest::Test
  def test_decoding_base64_consent_string
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String("BOVeoB_OVeoFxC-AHAFRBtAAAAAhGAEAD4AXAA2YCEQ")
    assert_match(/ByteBufferVendorConsent{Version=1,Created=1539273535900,LastUpdated=1539273560100,CmpId=190,CmpVersion=7,ConsentScreen=0,ConsentLanguage=FR,VendorListVersion=109,PurposesAllowed=#<Set:0x[[:xdigit:]]+>,MaxVendorId=529,EncodingType=1}/,vendorConsent.toString)
  end
end
