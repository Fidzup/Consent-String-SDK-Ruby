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
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

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
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

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
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

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
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

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
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

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
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

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
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

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

  def test_isSpecialFeatureOptIns
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
      "011001100110011001100110"             + # purpose consented
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal(true,vendorConsent.isPurposesConsented(2))
   assert_equal(true,vendorConsent.isPurposesConsented(3))
   assert_equal(true,vendorConsent.isPurposesConsented(6))
   assert_equal(true,vendorConsent.isPurposesConsented(7))
   assert_equal(true,vendorConsent.isPurposesConsented(10))
   assert_equal(true,vendorConsent.isPurposesConsented(11))
   assert_equal(true,vendorConsent.isPurposesConsented(14))
   assert_equal(true,vendorConsent.isPurposesConsented(15))
   assert_equal(true,vendorConsent.isPurposesConsented(18))
   assert_equal(true,vendorConsent.isPurposesConsented(19))
   assert_equal(true,vendorConsent.isPurposesConsented(22))
   assert_equal(true,vendorConsent.isPurposesConsented(23))

   assert_equal(false,vendorConsent.isPurposesConsented(1))
   assert_equal(false,vendorConsent.isPurposesConsented(4))
   assert_equal(false,vendorConsent.isPurposesConsented(5))
   assert_equal(false,vendorConsent.isPurposesConsented(8))
   assert_equal(false,vendorConsent.isPurposesConsented(9))
   assert_equal(false,vendorConsent.isPurposesConsented(12))
   assert_equal(false,vendorConsent.isPurposesConsented(13))
   assert_equal(false,vendorConsent.isPurposesConsented(16))
   assert_equal(false,vendorConsent.isPurposesConsented(17))
   assert_equal(false,vendorConsent.isPurposesConsented(20))
   assert_equal(false,vendorConsent.isPurposesConsented(21))
   assert_equal(false,vendorConsent.isPurposesConsented(24))
  end

  def test_isPurposeLITransparency
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
      "011001100110011001100110"             + # purpose consented
      "011001100110011001100110"             + # purpose li transparency
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal(true,vendorConsent.isPurposeLITransparency(2))
   assert_equal(true,vendorConsent.isPurposeLITransparency(3))
   assert_equal(true,vendorConsent.isPurposeLITransparency(6))
   assert_equal(true,vendorConsent.isPurposeLITransparency(7))
   assert_equal(true,vendorConsent.isPurposeLITransparency(10))
   assert_equal(true,vendorConsent.isPurposeLITransparency(11))
   assert_equal(true,vendorConsent.isPurposeLITransparency(14))
   assert_equal(true,vendorConsent.isPurposeLITransparency(15))
   assert_equal(true,vendorConsent.isPurposeLITransparency(18))
   assert_equal(true,vendorConsent.isPurposeLITransparency(19))
   assert_equal(true,vendorConsent.isPurposeLITransparency(22))
   assert_equal(true,vendorConsent.isPurposeLITransparency(23))
   assert_equal([2,3,6,7,10,11,14,15,18,19,22,23],vendorConsent.getPurposesLiTransparency)

   assert_equal(false,vendorConsent.isPurposeLITransparency(1))
   assert_equal(false,vendorConsent.isPurposeLITransparency(4))
   assert_equal(false,vendorConsent.isPurposeLITransparency(5))
   assert_equal(false,vendorConsent.isPurposeLITransparency(8))
   assert_equal(false,vendorConsent.isPurposeLITransparency(9))
   assert_equal(false,vendorConsent.isPurposeLITransparency(12))
   assert_equal(false,vendorConsent.isPurposeLITransparency(13))
   assert_equal(false,vendorConsent.isPurposeLITransparency(16))
   assert_equal(false,vendorConsent.isPurposeLITransparency(17))
   assert_equal(false,vendorConsent.isPurposeLITransparency(20))
   assert_equal(false,vendorConsent.isPurposeLITransparency(21))
   assert_equal(false,vendorConsent.isPurposeLITransparency(24))
  end

  def test_getPurposeOneTreatment
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
      "011001100110011001100110"             + # purpose consented
      "011001100110011001100110"             + # purpose li transparency
      "1"                                    + # purpose one treatement
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal(true,vendorConsent.getPurposeOneTreatment)
  end

  def test_getPublisherCC
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
      "011001100110011001100110"             + # purpose consented
      "011001100110011001100110"             + # purpose li transparency
      "1"                                    + # purpose one treatement
      "000101010001"                         + # publisher CC
      "0000"

   # When: object is constructed
   vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

   # Then: correct vendor list version is returned
   assert_equal('FR',vendorConsent.getPublisherCC)
  end

  def test_disclosed_vendor
    binarySegmentString = "" +
      "001" + #Disclose Vendor
      "0000000000000000" +
      "1" +
      "000000000010" + # num entry
      "1" + # is ranged
      "0000000000000001" + # vendor id
      "0000000000000100" + # end vendor id
      "0" + # is ranged
      "0000000000001001" # vendor id


    core_string  = IABConsentString::Util::Utils.fromBinaryString("")
    segment_string = IABConsentString::Util::Utils.fromBinaryString(binarySegmentString)
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(core_string, segment_string)

    v = vendorConsent.getDisclosedVendor
    assert_equal(true, v.isVendorConsented(1))
    assert_equal(true, v.isVendorConsented(2))
    assert_equal(true, v.isVendorConsented(4))
    assert_equal(false, v.isVendorConsented(8))
    assert_equal(true, v.isVendorConsented(9))
  end


  def test_allowed_vendor
    binarySegmentString = "" +
      "010" + #Allowed Vendor
      "0000000000000000" +
      "1" +
      "000000000010" + # num entry
      "1" + # is ranged
      "0000000000000001" + # vendor id
      "0000000000000100" + # end vendor id
      "0" + # is ranged
      "0000000000001001" # vendor id


    null_string  = IABConsentString::Util::Utils.fromBinaryString("")
    segment_string = IABConsentString::Util::Utils.fromBinaryString(binarySegmentString)
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(null_string, null_string, segment_string)

    v = vendorConsent.getAllowedVendor
    assert_equal(true, v.isVendorConsented(1))
    assert_equal(true, v.isVendorConsented(2))
    assert_equal(true, v.isVendorConsented(4))
    assert_equal(false, v.isVendorConsented(8))
    assert_equal(true, v.isVendorConsented(9))
  end


  def test_publisher_purpose_transparancy
    binarySegmentString = "" +
    "011" + #PublisherTC
    "001000000000000000000000" + # Pub Purpose Consent
    "000100000000000000000000" + # PubPurposesLITransparency
    "000010" + # num custom purpose
    "01" + # vendor id
    "10" # end vendor id

    null_string  = IABConsentString::Util::Utils.fromBinaryString("")
    segment_string = IABConsentString::Util::Utils.fromBinaryString(binarySegmentString)
    vendorConsent = IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(null_string, null_string, segment_string)
    vendorConsent.getPubPurposeConsent(3)
    assert_equal(true, vendorConsent.getPubPurposeConsent(3))
    assert_equal(false, vendorConsent.getPubPurposeConsent(4))
    assert_equal(false, vendorConsent.getPubPurposeLITransparency(3))
    assert_equal(true, vendorConsent.getCustomPurposeConsent(2))
    assert_equal(false, vendorConsent.getCustomPurposeConsent(1))
    assert_nil(vendorConsent.getCustomPurposeConsent(3))
    assert_equal(true, vendorConsent.getCustomPurposeLITransparency(1))
    assert_equal(false, vendorConsent.getCustomPurposeLITransparency(2))
    assert_nil(vendorConsent.getCustomPurposeLITransparency(3))
  end
end