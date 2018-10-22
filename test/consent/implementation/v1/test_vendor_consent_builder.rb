require 'minitest/autorun'
require 'iab_consent_string'
require 'date'
require 'set'

class VendorConsentBuilderTest < Minitest::Test
  def test_InvalidPurpose
    # Given: invalid purpose ID in the set
    allowedPurposes = Set[1,2,3,99]
    # When: passing set to the builder
    # Then: exception is thrown
    assert_raises RuntimeError do
      IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new().withAllowedPurposeIds(allowedPurposes)
    end
  end

  def test_InvalidVendorEncodingType
    # Given: invalid vendor encoding type
    vendorEncodingType = 3
    # When: passing vendor type to builder
    # Then: exception is thrown
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

    # Then: exception is thrown
    assert_raises IABConsentString::Error::VendorConsentCreateError do
      vendorConsent.build()
    end
  end
end
