require 'minitest/autorun'
require 'iab_consent_string'
require 'date'
require 'set'

class ByteBufferBackedVendorConsentV2Test < Minitest::Test

  def test_Version
    # Given: version field set to 3
    binaryString = "000010000000000000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct version is returned
    assert_equal(2,vendorConsent.getVersion())
  end

  def test_getConsentRecordCreated
    # Given: created date of Monday, June 4, 2018 12:00:00 AM, epoch = 1528070400
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "0000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct created timestamp is returned
    assert_equal(DateTime.new(2018,6,4,0,0,0).to_time.to_i * 1000, vendorConsent.getConsentRecordCreated())
  end

  def test_getConsentRecordLastUpdated
    # Given: updated date of Monday, June 4, 2018 12:00:00 AM, epoch = 1528070400
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "0000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct updated timestamp is returned
    assert_equal(DateTime.new(2018,6,4,0,0,0).to_time.to_i * 1000, vendorConsent.getConsentRecordLastUpdated())
  end

  def test_getCmpId
    # Given: CMP ID of 15
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" +  # Created
      "001110001110110011010000101000000000" +  # Updated
      "000000001111"                         +  # CMP ID
      "0000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct cmp ID is returned
    assert_equal(15,vendorConsent.getCmpId())
  end

  def test_getCmpVersion
    # Given: CMP version of 5
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "0000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct cmp version is returned
    assert_equal(5,vendorConsent.getCmpVersion());
  end

  def test_getConsentScreen
    # Given: content screen ID of 18
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "0000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct content screen ID is returned
    assert_equal(18,vendorConsent.getConsentScreen());
  end

  def test_getConsentLanguage
    # Given: language code of EN
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "0000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct language code is returned
    assert_equal("EN",vendorConsent.getConsentLanguage())
  end 

  def test_getVendorListVersion
    # Given: vendor list version of 150
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # vendor list version
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal(150,vendorConsent.getVendorListVersion())
  end

  def test_getTcfPolicyVersion
    # Given: vendor list version of 150
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # vendor list version
      "000010"                               + # policy version
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal(2,vendorConsent.getTcfPolicyVersion())
  end

  def test_getIsServiceSpecific
    # Given: vendor list version of 150
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # vendor list version
      "000010"                               + # policy version
      "1"                                    + # is service specific
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal(true,vendorConsent.getIsServiceSpecific())
  end

  def test_isPurposesConsented
    # Given: vendor list version of 150
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # vendor list version
      "000010"                               + # policy version
      "1"                                    + # is service specific
      "1"                                    + # non iab standar stack
      "011001100110"                         + # special feature
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal(true,vendorConsent.isSpecialFeatureOptIn(2))
   assert_equal(true,vendorConsent.isSpecialFeatureOptIn(3))
   assert_equal(true,vendorConsent.isSpecialFeatureOptIn(6))
   assert_equal(true,vendorConsent.isSpecialFeatureOptIn(7))
   assert_equal(true,vendorConsent.isSpecialFeatureOptIn(10))
   assert_equal(true,vendorConsent.isSpecialFeatureOptIn(11))

   assert_equal(false,vendorConsent.isSpecialFeatureOptIn(1))
   assert_equal(false,vendorConsent.isSpecialFeatureOptIn(4))
   assert_equal(false,vendorConsent.isSpecialFeatureOptIn(5))
   assert_equal(false,vendorConsent.isSpecialFeatureOptIn(8))
   assert_equal(false,vendorConsent.isSpecialFeatureOptIn(9))
   assert_equal(false,vendorConsent.isSpecialFeatureOptIn(12))
  end

end
