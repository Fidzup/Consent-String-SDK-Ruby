require 'minitest/autorun'
require 'iab_consent_string'
require 'date'
require 'set'

class VendorConsentBuilderTest < Minitest::Test
  def test_InvalidPurpose
    # Given: invalid purpose ID in the set
    allowedPurposes = Set[1,2,3,99]
    # When: passing set to the builder
    # Then: error is raising
    assert_raises RuntimeError do
      IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new().withAllowedPurposeIds(allowedPurposes)
    end
  end

  def test_InvalidVendorEncodingType
    # Given: invalid vendor encoding type
    vendorEncodingType = 3
    # When: passing vendor type to builder
    # Then: error is raising
    assert_raises RuntimeError do
      IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new().withVendorEncodingType(vendorEncodingType)
    end
  end

  def test_InvalidVendorListVersion
    # Given: invalid vendor list version - 50
    vendorListVersion = -50
    # When: trying to build using invalid value
    now = (DateTime.now.to_time.to_f * 1000).to_i
    vendorConsent = IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new()
                      .withConsentRecordCreatedOn(now)
                      .withConsentRecordLastUpdatedOn(now)
                      .withConsentLanguage("EN")
                      .withVendorListVersion(vendorListVersion)

    # Then: error is raising
    assert_raises IABConsentString::Error::VendorConsentCreateError do
      vendorConsent.build()
    end
  end

  def test_InvalidMaxVendorId
    # Given: invalid max vendor ID = -1
    maxVendorId = -1

    # When: trying to build using invalid value
    now = (DateTime.now.to_time.to_f * 1000).to_i
    vendorConsent = IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new()
                      .withConsentRecordCreatedOn(now)
                      .withConsentRecordLastUpdatedOn(now)
                      .withConsentLanguage("EN")
                      .withVendorListVersion(10)
                      .withMaxVendorId(maxVendorId)

    # Then: error is raising
    assert_raises IABConsentString::Error::VendorConsentCreateError do
      vendorConsent.build()
    end
  end

  def test_InvalidRangeEntry
    # Given: set of consent string parameters
    allowedPurposes = Set[1, 2, 3, 24]
    cmpId = 1
    cmpVersion = 1
    consentScreenID = 1
    consentLanguage = "EN"
    vendorListVersion = 10
    maxVendorId = 180
    vendorEncodingType = 0; # Bit field
    allowedVendors = Set[1, 10, 180]

    # When: vendor consent is build
    now = (DateTime.now.to_time.to_f * 10).to_i * 100
    vendorConsent = IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new()
                .withConsentRecordCreatedOn(now)
                .withConsentRecordLastUpdatedOn(now)
                .withCmpId(cmpId)
                .withCmpVersion(cmpVersion)
                .withConsentScreenId(consentScreenID)
                .withConsentLanguage(consentLanguage)
                .withVendorListVersion(vendorListVersion)
                .withAllowedPurposeIds(allowedPurposes)
                .withMaxVendorId(maxVendorId)
                .withVendorEncodingType(vendorEncodingType)
                .withBitField(allowedVendors)
                .build()

    # Then: values in vendor consent match parameters
    assert_equal(1,vendorConsent.getVersion())
    assert_equal(now,vendorConsent.getConsentRecordCreated())
    assert_equal(now,vendorConsent.getConsentRecordLastUpdated())
    assert_equal(cmpId,vendorConsent.getCmpId())
    assert_equal(cmpVersion,vendorConsent.getCmpVersion())
    assert_equal(consentScreenID,vendorConsent.getConsentScreen())
    assert_equal(vendorListVersion, vendorConsent.getVendorListVersion())
    assert_equal(allowedPurposes, vendorConsent.getAllowedPurposeIds())
    assert_equal(maxVendorId,vendorConsent.getMaxVendorId())

    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(1))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(2))==true)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(3))==true)
    assert(vendorConsent.isPurposeIdAllowed(24)==true)

    assert(vendorConsent.isVendorAllowed(1)==true)
    assert(vendorConsent.isVendorAllowed(10)==true)
    assert(vendorConsent.isVendorAllowed(180)==true)

    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(4))==false)
    assert(vendorConsent.isPurposeAllowed(IABConsentString::Purpose.new(5))==false)

    assert(vendorConsent.isVendorAllowed(5)==false)
    assert(vendorConsent.isVendorAllowed(11)==false)
    assert(vendorConsent.isVendorAllowed(179)==false)
  end

  def test_ValidRangedEncoding
    # Given: set of consent string parameters
    allowedPurposes = Set[
                        IABConsentString::Purpose::STORAGE_AND_ACCESS,
                        IABConsentString::Purpose::PERSONALIZATION,
                        IABConsentString::Purpose::AD_SELECTION,
                        IABConsentString::Purpose::CONTENT_DELIVERY,
                        IABConsentString::Purpose::MEASUREMENT,
                        IABConsentString::Purpose::GEOLOCALIZED_ADS
                      ]
    cmpId = 10
    cmpVersion = 3
    consentScreenId = 4
    consentLanguage = "FR"
    vendorListVersion = 231
    maxVendorId = 400
    vendorEncodingType = 1
    rangeEntries = [
                     IABConsentString::Consent::Range::SingleRangeEntry.new(10),
                     IABConsentString::Consent::Range::StartEndRangeEntry.new(100,200),
                     IABConsentString::Consent::Range::SingleRangeEntry.new(350)
                   ]

    # When: vendor consent is build
    now = (DateTime.now.to_time.to_f * 10).to_i * 100
    vendorConsent = IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new()
                      .withConsentRecordCreatedOn(now)
                      .withConsentRecordLastUpdatedOn(now)
                      .withCmpId(cmpId)
                      .withCmpVersion(cmpVersion)
                      .withConsentScreenId(consentScreenId)
                      .withConsentLanguage(consentLanguage)
                      .withVendorListVersion(vendorListVersion)
                      .withAllowedPurposeIds(allowedPurposes)
                      .withMaxVendorId(maxVendorId)
                      .withVendorEncodingType(vendorEncodingType)
                      .withDefaultConsent(false)
                      .withRangeEntries(rangeEntries)
                      .build()

    # Then: values in vendor consent match parameters
    assert_equal(1,vendorConsent.getVersion())
    assert_equal(now,vendorConsent.getConsentRecordCreated())
    assert_equal(now,vendorConsent.getConsentRecordLastUpdated())
    assert_equal(cmpId,vendorConsent.getCmpId())
    assert_equal(cmpVersion,vendorConsent.getCmpVersion())
    assert_equal(consentScreenId,vendorConsent.getConsentScreen())
    assert_equal(vendorListVersion,vendorConsent.getVendorListVersion())
    assert_equal(allowedPurposes,vendorConsent.getAllowedPurposeIds())
    assert_equal(maxVendorId,vendorConsent.getMaxVendorId())

    assert(vendorConsent.isPurposeIdAllowed(IABConsentString::Purpose::STORAGE_AND_ACCESS)==true)
    assert(vendorConsent.isPurposeIdAllowed(IABConsentString::Purpose::PERSONALIZATION)==true)
    assert(vendorConsent.isPurposeIdAllowed(IABConsentString::Purpose::AD_SELECTION)==true)
    assert(vendorConsent.isPurposeIdAllowed(IABConsentString::Purpose::CONTENT_DELIVERY)==true)
    assert(vendorConsent.isPurposeIdAllowed(IABConsentString::Purpose::MEASUREMENT)==true)
    assert(vendorConsent.isPurposeIdAllowed(IABConsentString::Purpose::GEOLOCALIZED_ADS)==true)

    assert(vendorConsent.isVendorAllowed(10)==true)
    assert(vendorConsent.isVendorAllowed(150)==true)
    assert(vendorConsent.isVendorAllowed(350)==true)

    assert(vendorConsent.isVendorAllowed(50)==false)
    assert(vendorConsent.isVendorAllowed(240)==false)
  end
end
