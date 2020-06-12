require 'minitest/autorun'
require 'iab_consent_string'

class VendorConsentEncoderTest < Minitest::Test

  def test_Encode
    # Given: vendor consent binary string
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" +  # Created
      "001110001110110011010000101000000000" +  # Updated
      "000000001111"                         +  # CMP ID
      "000000000101"                         +  # CMP version
      "010010"                               +  # Content screen ID
      "000100001101"                         +  # Language code
      "000010010110"                         +  # Vendor list version
      "111110000000001000000001"             +  # Allowed purposes bitmap
      "0000000000100000"                     +  # Max vendor ID
      "0"                                    +  # Bit field encoding
      "10000000000000000000000010000100"        # Vendor bits in bit field

    # And: ByteBufferBackedVendorConsent constructed from binary string
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # When: encode is called
    base64String = IABConsentString::Consent::VendorConsentEncoder.toBase64String(vendorConsent)

    # Then: encoded string is returned
    assert_equal("DOOzQoAOOzQoAAPAFSENCW-AIBACBAAABCA",base64String)

    # Verify the vendorConsent object is valid
    allowedPurposesBits = vendorConsent.getAllowedPurposesBits()
    assert !allowedPurposesBits.nil?
  end

  def test_EncodeV2
    @consent_builder = IABConsentString::Consent::Implementation::V2::VendorConsentBuilder.new()
    @consent_builder.withBinaryVendorConsent().withBinaryVendorLegitimateInterest()
    @consent_builder.withBinaryDisclosedVendor
    @consent_builder.withBinaryAllowedVendor
    @consent_builder.withCmpId(2)
    @consent_builder.withConsentRecordCreatedOn((DateTime.new(2020,6,1,1,1,1).to_time.to_f * 1000).to_i)
    @consent_builder.withConsentRecordLastUpdatedOn((DateTime.new(2020,6,1,1,1,1).to_time.to_f * 1000).to_i)
    consent = @consent_builder.build
    base64String = IABConsentString::Consent::VendorConsentEncoder.toBase64String(consent)
    assert_equal("CO0S0ECO0S0ECACAAAktAAAAAAAAAAAAAEloAAAAAAAA.IAAA.QAAA",base64String)
  end
end
