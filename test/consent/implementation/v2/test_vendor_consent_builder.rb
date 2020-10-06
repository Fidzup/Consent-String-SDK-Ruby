require 'minitest/autorun'
require 'iab_consent_string'
require 'date'

class VendorConsentV2BuilderTest < Minitest::Test

  def setup
    @consent_builder = IABConsentString::Consent::Implementation::V2::VendorConsentBuilder.new()
    @consent_builder.withBinaryVendorConsent().withBinaryVendorLegitimateInterest()
  end

  def test_withConsentRecordCreatedOn
    now = (DateTime.now.to_time.to_f * 10).to_i * 100
    consent = @consent_builder.withConsentRecordCreatedOn(now).build
    assert_equal(2,consent.getVersion())
    assert_equal(now,consent.getConsentRecordCreated())
  end

  def test_withConsentRecordLastUpdatedOn
    now = (DateTime.now.to_time.to_f * 10).to_i * 100
    consent = @consent_builder.withConsentRecordLastUpdatedOn(now).build
    assert_equal(2,consent.getVersion())
    assert_equal(now,consent.getConsentRecordLastUpdated())
  end

  def test_withCmpVersion
    cmp_version = rand(100)
    consent = @consent_builder.withCmpVersion(cmp_version).build
    assert_equal(cmp_version,consent.getCmpVersion())
  end

  def test_withCmpId
    cmp_id = rand(1000)
    consent = @consent_builder.withCmpId(cmp_id).build
    assert_equal(cmp_id,consent.getCmpId())
  end

  def test_withConsentScreenId
    consent_screen_id = rand(10)
    consent = @consent_builder.withConsentScreenId(consent_screen_id).build
    assert_equal(consent_screen_id,consent.getConsentScreen())
  end

  def test_withVendorListVersion
    vendor_list_version = rand(100)
    consent = @consent_builder.withVendorListVersion(vendor_list_version).build
    assert_equal(vendor_list_version,consent.getVendorListVersion())
  end

  def test_withConsentLanguage
    consent_laguage = ['EN', 'FR', 'DE'].sample
    consent = @consent_builder.withConsentLanguage(consent_laguage).build
    assert_equal(consent_laguage,consent.getConsentLanguage())
  end

  def test_withTcfPolicyVersion
    tcf_policy_version = rand(10)
    consent = @consent_builder.withTcfPolicyVersion(tcf_policy_version).build
    assert_equal(tcf_policy_version,consent.getTcfPolicyVersion())
  end

  def test_withIsServiceSpecific
    is_service_speicif = [true, false].sample
    consent = @consent_builder.withIsServiceSpecific(is_service_speicif).build
    assert_equal(is_service_speicif,consent.getIsServiceSpecific())
  end

  def test_withUseNonStandardStacks
    use_non_standard_stack = [true, false].sample
    consent = @consent_builder.withUseNonStandardStacks(use_non_standard_stack).build
    assert_equal(use_non_standard_stack,consent.getUseNonStandardStacks())
  end

  def test_withPurposeOneTreatment
    purpose_one_treatment = [true, false].sample
    consent = @consent_builder.withPurposeOneTreatment(purpose_one_treatment).build
    assert_equal(purpose_one_treatment,consent.getPurposeOneTreatment())
  end

  def test_withwithPublisherCC
    publisher_cc = ['FR', 'DE', 'GG', 'GB'].sample
    consent = @consent_builder.withPublisherCC(publisher_cc).build
    assert_equal(publisher_cc,consent.getPublisherCC())
  end

  def test_withSpecialFeatureOptIn
    ids = (1..12).to_a.sample(4)
    vals = Array.new(4) { [true, false].sample }
    4.times do |i|
      @consent_builder.withSpecialFeatureOptIn(ids[i], vals[i])
    end
    consent = @consent_builder.build
    4.times do |i|
      assert_equal(vals[i],consent.isSpecialFeatureOptIn(ids[i]))
    end
  end


  def test_withSpecialFeatureOptIns
    ids = Array.new(5) { |i| rand(1..12)}.uniq.sort
    consent = @consent_builder.withSpecialFeatureOptIns(ids).build
    assert_equal(ids,consent.getSpecialFeatureOptIns)
  end


  def test_withPurposeConsent
    ids = (1..24).to_a.sample(4)
    vals = Array.new(4) { [true, false].sample }
    4.times do |i|
      @consent_builder.withPurposeConsent(ids[i], vals[i])
    end
    consent = @consent_builder.build
    4.times do |i|
      assert_equal(vals[i],consent.isPurposesConsented(ids[i]))
    end
  end

  def test_withPurposeConsents
    ids = Array.new(5) { |i| rand(1..24)}.uniq.sort
    consent = @consent_builder.withPurposeConsents(ids).build
    assert_equal(ids,consent.getAllowedPurposeIds)
  end

  def test_withPurposeLITransparency
    ids = (1..24).to_a.sample(4)
    vals = Array.new(4) { [true, false].sample }
    4.times do |i|
      @consent_builder.withPurposeLITransparency(ids[i], vals[i])
    end
    consent = @consent_builder.build
    4.times do |i|
      assert_equal(vals[i],consent.isPurposeLITransparency(ids[i]))
    end
  end

  def test_withPurposesLITransparency
    ids = Array.new(5) { |i| rand(1..24)}.uniq.sort
    consent = @consent_builder.withPurposesLITransparency(ids).build
    assert_equal(ids,consent.getPurposesLiTransparency)
  end

  def test_withBinaryVendorConsent
    @consent_builder.withBinaryVendorConsent
    ids = (1..24).to_a.sample(4)
    ids.each do |id|
      @consent_builder.addVendorConsent(id)
    end
    consent = @consent_builder.build
    ids.each do |id|
      assert_equal(true,consent.isVendorConsented(id))
    end
  end

  def test_withRangedVendorConsent
    @consent_builder.withRangedVendorConsent
    @consent_builder.addVendorConsent(3)
    @consent_builder.addVendorConsent(5,9)
    consent = @consent_builder.build
    assert_equal(true,consent.isVendorConsented(3))
    assert_equal(true,consent.isVendorConsented(6))
  end

  def test_withBinaryVendorLegitimateInterest
    @consent_builder.withBinaryVendorLegitimateInterest
    ids = (1..24).to_a.sample(4)
    ids.each do |id|
      @consent_builder.addVendorLegitimateInterest(id)
    end
    consent = @consent_builder.build
    ids.each do |id|
      assert_equal(true,consent.isVendorLegitimateInterested(id))
    end
  end

  def test_withRangedVendorLegitimateInterest
    @consent_builder.withRangedVendorLegitimateInterest
    @consent_builder.addVendorLegitimateInterest(3)
    @consent_builder.addVendorLegitimateInterest(5,9)
    consent = @consent_builder.build
    assert_equal(true,consent.isVendorLegitimateInterested(3))
    assert_equal(true,consent.isVendorLegitimateInterested(6))
  end
  
  def test_withPublisherRestriction
    vendor_id = (1..24).to_a.sample
    purpose_id = (1..12).to_a.sample
    restriction = (0..3).to_a.sample
    vendor = IABConsentString::Consent::Implementation::V2::VendorSectionRanged.new
    vendor.addVendor(vendor_id)
    @consent_builder.withPublisherRestriction(vendor, purpose_id, restriction)
    consent = @consent_builder.build
    assert_equal(restriction,consent.getPublisherRestriction(purpose_id, vendor_id))
  end

  def test_withBinaryDisclosedVendor
    @consent_builder.withBinaryDisclosedVendor
    ids = (1..24).to_a.sample(4)
    ids.each do |id|
      @consent_builder.addDisclosedVendor(id)
    end
    consent = @consent_builder.build
    ids.each do |id|
      assert_equal(true,consent.isDisclosedVendor(id))
    end
  end

  def test_withRangedDisclosedVendor
    @consent_builder.withRangedDisclosedVendor
    @consent_builder.addDisclosedVendor(3)
    @consent_builder.addDisclosedVendor(5,9)
    consent = @consent_builder.build
    assert_equal(true,consent.isDisclosedVendor(3))
    assert_equal(true,consent.isDisclosedVendor(6))
  end

  def test_withBinaryAllowedVendor
    @consent_builder.withBinaryAllowedVendor
    ids = (1..24).to_a.sample(4)
    ids.each do |id|
      @consent_builder.addAllowedVendor(id)
    end
    consent = @consent_builder.build
    ids.each do |id|
      assert_equal(true,consent.isAllowedVendor(id))
    end
  end

  def test_withRangedAllowedVendor
    @consent_builder.withRangedAllowedVendor
    @consent_builder.addAllowedVendor(3)
    @consent_builder.addAllowedVendor(5,9)
    consent = @consent_builder.build
    assert_equal(true,consent.isAllowedVendor(3))
    assert_equal(true,consent.isAllowedVendor(6))
  end


end
