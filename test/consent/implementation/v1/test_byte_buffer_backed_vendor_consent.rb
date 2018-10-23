require 'minitest/autorun'
require 'iab_consent_string'
require 'date'
require 'set'

class ByteBufferBackedVendorConsentTest < Minitest::Test

  def test_Version
    # Given: version field set to 3
    binaryString = "000011" + "000000000000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct version is returned
    assert_equal(3,vendorConsent.getVersion())
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

  def test_getAllowedPurposes
    # Given: allowed purposes of 1,2,3,4,5,15,24
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # Vendor list version
      "111110000000001000000001"             + # Allowed purposes bitmap
      "0000"

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct allowed versions are returned
    assert_equal(Set[1,2,3,4,5,15,24],vendorConsent.getAllowedPurposeIds())
    expectedAllowedPurposes = [
                   IABConsentString::Purpose.new(IABConsentString::Purpose::STORAGE_AND_ACCESS),
                   IABConsentString::Purpose.new(IABConsentString::Purpose::PERSONALIZATION),
                   IABConsentString::Purpose.new(IABConsentString::Purpose::AD_SELECTION),
                   IABConsentString::Purpose.new(IABConsentString::Purpose::CONTENT_DELIVERY),
                   IABConsentString::Purpose.new(IABConsentString::Purpose::MEASUREMENT),
                   IABConsentString::Purpose.new(IABConsentString::Purpose::UNDEFINED)
                 ] 
    assert_equal(expectedAllowedPurposes, vendorConsent.getAllowedPurposes().to_a)
    assert_equal(16253441,vendorConsent.getAllowedPurposesBits())
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(1))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(IABConsentString::Purpose::STORAGE_AND_ACCESS))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(2))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(IABConsentString::Purpose::PERSONALIZATION))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(3))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(IABConsentString::Purpose::AD_SELECTION))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(4))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(IABConsentString::Purpose::CONTENT_DELIVERY))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(5))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(IABConsentString::Purpose::MEASUREMENT))==true)
    assert(vendorConsent.isPurposeIdAllowed(15)==true)
    assert(vendorConsent.isPurposeIdAllowed(24)==true)
  end

  def test_getMaxVendorId
      # Given: max vendor ID of 382
      binaryString = "000011" + # Version
        "001110001110110011010000101000000000" + # Created
        "001110001110110011010000101000000000" + # Updated
        "000000001111"                         + # CMP ID
        "000000000101"                         + # CMP version
        "010010"                               + # Content screen ID
        "000100001101"                         + # Language code
        "000010010110"                         + # Vendor list version
        "111110000000001000000001"             + # Allowed purposes bitmap
        "0000000101111110"                     + # Max vendor ID
        "0000"

      # When: object is constructed
      vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

      #// Then: correct max vendor ID is returned
      assert_equal(382,vendorConsent.getMaxVendorId())
  end

  def test_BitFieldEncoding
    # Given: vendors 1,25 and 30 in bit field, with max vendor of of 32
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # Vendor list version
      "111110000000001000000001"             + # Allowed purposes bitmap
      "0000000000100000"                     + # Max vendor ID
      "0"                                    + # Bit field encoding
      "10000000000000000000000010000100"       # Vendor bits in bit field

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct vendor IDs are allowed
    assert(vendorConsent.isVendorAllowed(1)==true)
    assert(vendorConsent.isVendorAllowed(25)==true)
    assert(vendorConsent.isVendorAllowed(30)==true)

    assert(vendorConsent.isVendorAllowed(2)==false)
    assert(vendorConsent.isVendorAllowed(3)==false)
    assert(vendorConsent.isVendorAllowed(31)==false)
    assert(vendorConsent.isVendorAllowed(32)==false)

    #// Vendors outside range [1, MaxVendorId] are not allowed
    assert(vendorConsent.isVendorAllowed(-99)==false)
    assert(vendorConsent.isVendorAllowed(-1)==false)
    assert(vendorConsent.isVendorAllowed(0)==false)
    assert(vendorConsent.isVendorAllowed(33)==false)
    assert(vendorConsent.isVendorAllowed(34)==false)
    assert(vendorConsent.isVendorAllowed(99)==false)
  end

  def test_RangeEncodingDefaultFalse
    # Given: vendors 1-25 and 30 with consent, with max vendor IF of 32
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # Vendor list version
      "111110000000001000000001"             + # Allowed purposes bitmap
      "0000000000100000"                     + # Max vendor ID
      "1"                                    + # Range encoding
      "0"                                    + # Default 0=No Consent
      "000000000010"                         + # Number of entries = 2
      "1"                                    + # First entry range = 1
      "0000000000000001"                     + # First entry from = 1
      "0000000000011001"                     + # First entry to = 25
      "0"                                    + # Second entry single = 0
      "0000000000011110"                       # Second entry value = 30

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct vendor IDs are allowed
    assert(vendorConsent.isVendorAllowed(1)==true)
    assert(vendorConsent.isVendorAllowed(10)==true)
    assert(vendorConsent.isVendorAllowed(25)==true)
    assert(vendorConsent.isVendorAllowed(30)==true)

    assert(vendorConsent.isVendorAllowed(26)==false)
    assert(vendorConsent.isVendorAllowed(28)==false)
    assert(vendorConsent.isVendorAllowed(31)==false)
    assert(vendorConsent.isVendorAllowed(32)==false)

    # Vendors outside range [1, MaxVendorId] are not allowed
    assert(vendorConsent.isVendorAllowed(-99)==false)
    assert(vendorConsent.isVendorAllowed(-1)==false)
    assert(vendorConsent.isVendorAllowed(0)==false)
    assert(vendorConsent.isVendorAllowed(33)==false)
    assert(vendorConsent.isVendorAllowed(34)==false)
    assert(vendorConsent.isVendorAllowed(99)==false)
  end

  def test_RangeEncodingDefaultTrue
    # Given: vendors 1 and 25-30 without consent, with max vendor IF of 32
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # Vendor list version
      "111110000000001000000001"             + # Allowed purposes bitmap
      "0000000000100000"                     + # Max vendor ID
      "1"                                    + # Range encoding
      "1"                                    + # Default 1=Consent
      "000000000010"                         + # Number of entries = 2
      "0"                                    + # First entry single = 0
      "0000000000000001"                     + # First entry value = 1
      "1"                                    + # Second entry range = 1
      "0000000000011001"                     + # Second entry from = 25
      "0000000000011110"                       # Second entry to = 30

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # Then: correct vendor IDs are allowed
    assert(vendorConsent.isVendorAllowed(1)==false)
    assert(vendorConsent.isVendorAllowed(25)==false)
    assert(vendorConsent.isVendorAllowed(27)==false)
    assert(vendorConsent.isVendorAllowed(30)==false)

    assert(vendorConsent.isVendorAllowed(2)==true)
    assert(vendorConsent.isVendorAllowed(15)==true)
    assert(vendorConsent.isVendorAllowed(31)==true)
    assert(vendorConsent.isVendorAllowed(32)==true)

    # Vendors outside range [1, MaxVendorId] are not allowed
    assert(vendorConsent.isVendorAllowed(-99)==false)
    assert(vendorConsent.isVendorAllowed(-1)==false)
    assert(vendorConsent.isVendorAllowed(0)==false)
    assert(vendorConsent.isVendorAllowed(33)==false)
    assert(vendorConsent.isVendorAllowed(34)==false)
    assert(vendorConsent.isVendorAllowed(99)==false)
  end

  def test_InvalidVendorId1
    # Given: invalid vendor ID in range
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # Vendor list version
      "111110000000001000000001"             + # Allowed purposes bitmap
      "0000000000100000"                     + # Max vendor ID
      "1"                                    + # Range encoding
      "1"                                    + # Default 1=Consent
      "000000000010"                         + # Number of entries = 2
      "0"                                    + # First entry single = 0
      "0000000000000001"                     + # First entry value = 1
      "1"                                    + # Second entry range = 1
      "0000000000101000"                     + # Second entry from = 40 - INVALID
      "0000000000011110"                       # Second entry to = 30

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # And: vendor check is performed
    # Then: exception is raised
    assert_raises IABConsentString::Error::VendorConsentParseError do
      assert(vendorConsent.isVendorAllowed(32)==true)
    end
  end

  def test_InvalidVendorId2
    # Given: invalid vendor ID in range
    binaryString = "000011" + # Version
      "001110001110110011010000101000000000" + # Created
      "001110001110110011010000101000000000" + # Updated
      "000000001111"                         + # CMP ID
      "000000000101"                         + # CMP version
      "010010"                               + # Content screen ID
      "000100001101"                         + # Language code
      "000010010110"                         + # Vendor list version
      "111110000000001000000001"             + # Allowed purposes bitmap
      "0000000000100000"                     + # Max vendor ID
      "1"                                    + # Range encoding
      "1"                                    + # Default 1=Consent
      "000000000010"                         + # Number of entries = 2
      "0"                                    + # First entry single = 0
      "0000000000101000"                     + # First entry value = 40 - INVALID
      "1"                                    + # Second entry range = 1
      "0000000000011001"                     + # Second entry from = 25
      "0000000000011110"                       # Second entry to = 30

    # When: object is constructed
    vendorConsent = IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(IABConsentString::Util::Utils.fromBinaryString(binaryString))

    # And: vendor check is performed
    # Then: exception is raised
    assert_raises IABConsentString::Error::VendorConsentParseError do
      assert(vendorConsent.isVendorAllowed(32)==true)
    end
  end

  def test_RealString1
    # Given: known vendor consent string
    consentString = "BOOlLqOOOlLqTABABAENAk-AAAAXx7_______9______9uz_Gv_r_f__3nW8_39P3g_7_O3_7m_-zzV48_lrQV1yPAUCgA"

    # When: vendor consent is constructed
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)

    # Then: values match expectation
    assert_equal(380, vendorConsent.getMaxVendorId())
    assert(vendorConsent.isVendorAllowed(380)==true)
    assert(vendorConsent.isVendorAllowed(379)==false)
  end

  def test_RealString2
    # Given: known vendor consent string
    consentString = "BN5lERiOMYEdiAOAWeFRAAYAAaAAptQ"

    # When: vendor consent is constructed
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)

    # Then: values match expectation
    assert_equal(14,vendorConsent.getCmpId())
    assert_equal(22,vendorConsent.getCmpVersion())
    assert_equal("FR",vendorConsent.getConsentLanguage())
    assert_equal(1492466185800,vendorConsent.getConsentRecordCreated())
    assert_equal(1524002185800,vendorConsent.getConsentRecordLastUpdated())
    assert_equal(5,vendorConsent.getAllowedPurposeIds().size())
    assert_equal(6291482,vendorConsent.getAllowedPurposesBits())

    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(2))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(1))==false)
    assert(vendorConsent.isPurposeIdAllowed(21)==true)
    assert(vendorConsent.isVendorAllowed(1)==true)
    assert(vendorConsent.isVendorAllowed(5)==true)
    assert(vendorConsent.isVendorAllowed(7)==true)
    assert(vendorConsent.isVendorAllowed(9)==true)
    assert(vendorConsent.isVendorAllowed(0)==false)
    assert(vendorConsent.isVendorAllowed(10)==false)
  end

  def testRealString3
    # Given: known vendor consent string
    consentString = "BN5lERiOMYEdiAKAWXEND1HoSBE6CAFAApAMgBkIDIgM0AgOJxAnQA"

    # When: vendor consent is constructed
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)

    # Then: values match expectation
    assert_equal(10,vendorConsent.getCmpId())
    assert_equal(22,vendorConsent.getCmpVersion())
    assert_equal(vendorConsent.getConsentLanguage(), is("EN"));
    assert_equal(1492466185800,vendorConsent.getConsentRecordCreated())
    assert_equal(1524002185800,vendorConsent.getConsentRecordLastUpdated())
    assert_equal(8,vendorConsent.getAllowedPurposeIds().size())
    assert_equal(2000001,vendorConsent.getAllowedPurposesBits())

    assert(vendorConsent.isPurposeAllowed(4)==true)
    assert(vendorConsent.isPurposeAllowed(1)==false)
    assert(vendorConsent.isPurposeAllowed(24)==true)
    assert(vendorConsent.isPurposeAllowed(25)==false)
    assert(vendorConsent.isPurposeAllowed(0)==false)
    assert(vendorConsent.isVendorAllowed(1)==false)
    assert(vendorConsent.isVendorAllowed(3)==false)
    assert(vendorConsent.isVendorAllowed(225)==true)
    assert(vendorConsent.isVendorAllowed(5000)==true)
    assert(vendorConsent.isVendorAllowed(515)==true)
    assert(vendorConsent.isVendorAllowed(0)==false)
    assert(vendorConsent.isVendorAllowed(411)==false)
    assert(vendorConsent.isVendorAllowed(3244)==false)
  end

  def test_RealString4
    # Given: known vendor consent string
    consentString = "BOOMzbgOOQww_AtABAFRAb-AAAsvOA3gACAAkABgArgBaAF0AMAA1gBuAH8AQQBSgCoAL8AYQBigDIAM0AaABpgDYAOYAdgA8AB6gD4AQoAiABFQCMAI6ASABIgCTAEqAJeATIBQQCiAKSAU4BVQCtAK-AWYBaQC2ALcAXMAvAC-gGAAYcAxQDGAGQAMsAZsA0ADTAGqANcAbMA4ADjAHKAOiAdQB1gDtgHgAeMA9AD2AHzAP4BAACBAEEAIbAREBEgCKQEXARhZeYA"

    # When: vendor consent is constructed
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)

    # Then: values match expectation
    assert_equal(45,vendorConsent.getCmpId())
    assert_equal(1,vendorConsent.getCmpVersion())
    assert_equal("FR",vendorConsent.getConsentLanguage())
    assert_equal(1527062294400,vendorConsent.getConsentRecordCreated())
    assert_equal(5,vendorConsent.getAllowedPurposeIds().size())

    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(1))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(2))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(3))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(4))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(5))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(6))==false)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(25))==false)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(0))==false)
    assert(vendorConsent.isVendorAllowed(1)==true)
    assert(vendorConsent.isVendorAllowed(5)==false)
    assert(vendorConsent.isVendorAllowed(45)==true)
    assert(vendorConsent.isVendorAllowed(47)==false)
    assert(vendorConsent.isVendorAllowed(146)==false)
    assert(vendorConsent.isVendorAllowed(147)==true)
  end

  def test_RealString5
    # Given: known vendor consent string
    consentString = "BONZt-1ONZt-1AHABBENAO-AAAAHCAEAASABmADYAOAAeA"

    # When: vendor vendorConsent is constructed
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)

    # Then: values match expectation
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(1))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(3))==true)
    assert(vendorConsent.isVendorAllowed(28)==true)
    assert(vendorConsent.isVendorAllowed(1)==false)
    assert(vendorConsent.isVendorAllowed(3)==false)
    assert(vendorConsent.isVendorAllowed(27)==true)
  end

  def test_RealString6
    # Given: known vendor consent string
    consentString = "BOOj_adOOj_adABABADEAb-AAAA-iATAAUAA2ADAAMgAgABIAC0AGQANAAcAA-ACKAEwAKIAaABFACQAHIAP0B9A"

    # When: vendor vendorConsent is constructed
    vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString)

    # Then: values match expectation
    assert_equal(1,vendorConsent.getVersion())
    parseDatePattern = "%Y-%m-%d %H:%M:%S.%L"
    assert_equal((DateTime.strptime("2018-05-30 08:48:54.100",parseDatePattern).to_time.to_f*1000).to_i, vendorConsent.getConsentRecordCreated())
    assert_equal((DateTime.strptime("2018-05-30 08:48:54.100",parseDatePattern).to_time.to_f*1000).to_i, vendorConsent.getConsentRecordLastUpdated())
    assert_equal(1,vendorConsent.getCmpId())
    assert_equal(1,vendorConsent.getCmpVersion())
    assert_equal(0,vendorConsent.getConsentScreen())
    assert_equal("DE",vendorConsent.getConsentLanguage())
    assert_equal(1000,vendorConsent.getMaxVendorId())
    assert(vendorConsent.isVendorAllowed(10)==true)
    assert(vendorConsent.isVendorAllowed(13)==true)
    assert(vendorConsent.isVendorAllowed(25)==true)
    assert(vendorConsent.isVendorAllowed(32)==true)
    assert(vendorConsent.isVendorAllowed(36)==true)
    assert(vendorConsent.isVendorAllowed(45)==true)
    assert(vendorConsent.isVendorAllowed(50)==true)
    assert(vendorConsent.isVendorAllowed(52)==true)
    assert(vendorConsent.isVendorAllowed(56)==true)
    assert(vendorConsent.isVendorAllowed(62)==true)
    assert(vendorConsent.isVendorAllowed(69)==true)
    assert(vendorConsent.isVendorAllowed(76)==true)
    assert(vendorConsent.isVendorAllowed(81)==true)
    assert(vendorConsent.isVendorAllowed(104)==true)
    assert(vendorConsent.isVendorAllowed(138)==true)
    assert(vendorConsent.isVendorAllowed(144)==true)
    assert(vendorConsent.isVendorAllowed(228)==true)
    assert(vendorConsent.isVendorAllowed(253)==true)
    assert(vendorConsent.isVendorAllowed(1000)==true)
    assert_equal(Set[1,2,3,4,5],vendorConsent.getAllowedPurposeIds())
  end
end
