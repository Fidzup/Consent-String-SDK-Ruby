require 'set'
require 'date'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/vendor_consent'
require_relative './byte_buffer_backed_core_vendor_consent.rb'
require_relative './byte_buffer_backed_allowed_vendor_consent.rb'
require_relative './byte_buffer_backed_disclosed_vendor_consent.rb'
require_relative './byte_buffer_backed_publisher_purposes_transparency.rb'
require_relative './containers/consent_core.rb'

module IABConsentString 
  module Consent
    module Implementation
      module V2
        class VendorConsentBuilder
          def initialize
            # @type [Container::ConsentCore]
            @consent_core = Container::ConsentCore.new
            @disclosed_vendor = nil
            @allowed_vendor = nil
          end

          # With creation date
          # @param consentRecordCreated [DateTime] Epoch deciseconds when record was created
          # @return [VendorConsentBuilder] self
          def withConsentRecordCreatedOn(consentRecordCreated)
            @consent_core.consent_record_created = consentRecordCreated
            self
          end

          # With update date
          # @param consentRecordLastUpdated [DateTime] Epoch deciseconds when consent string was last updated
          # @return [VendorConsentBuilder] self
          def withConsentRecordLastUpdatedOn(consentRecordLastUpdated)
            @consent_core.consent_record_last_updated = consentRecordLastUpdated
            self
          end

          # With CMP version
          # @param cmpVersion [Integer] Consent Manager Provider version
          # @return [VendorConsentBuilder] self
          def withCmpVersion(cmpVersion)
            @consent_core.cmp_version = cmpVersion
            self
          end

          # With CMP Id
          # @param cmpId [Integer] Consent Manager Provider Id
          # @return [VendorConsentBuilder] self
          def withCmpId(cmpId)
            @consent_core.cmp_id = cmpId
            self
          end

          # With Consent Screen Id
          # @param consentScreenId [Integer] Consent Screen Id
          # @return [VendorConsentBuilder] self
          def withConsentScreenId(consentScreenId)
            @consent_core.consent_screen = consentScreenId
            self
          end

          # With vendor list version
          # @param consentLanguage [Char(2)] Two-letter ISO639-1 language code that CMP asked for consent in
          # @return [VendorConsentBuilder] self
          def withVendorListVersion(vendorListVersion)
            @consent_core.vendor_list_version = vendorListVersion
            self
          end


          # With consent language
          # @param consentLanguage [Char(2)] Two-letter ISO639-1 language code that CMP asked for consent in
          # @return [VendorConsentBuilder] self
          def withConsentLanguage(consentLanguage)
            @consent_core.consent_language = consentLanguage
            self
          end

          # With TCF policy
          # @param [Integer] tcfPolicyVersion  	Version of policy used 
          # @return [VendorConsentBuilder] self
          def withTcfPolicyVersion(tcfPolicyVersion)
            @consent_core.tcf_policy_version = tcfPolicyVersion
            self
          end

          # Whether the signals encoded in this TC String were from 
          # service-specific storage (true) versus ‘global’ consensu.org 
          # shared storage (false). 
          # @param [Boolean] isServiceSpecific true|false
          # @return [VendorConsentBuilder] self
          def withIsServiceSpecific(isServiceSpecific)
            @consent_core.is_service_specific = isServiceSpecific
            self
          end

          # Setting this to true means that a publisher-run CMP, 
          # that is still IAB Europe registered, is using customized 
          # Stack descriptions and not the standard stack descriptions 
          # defined in the Policies (Appendix A section E). A CMP that 
          # services multiple publishers sets this value to false. 
          # @param [useNonStandardStacks] useNonStandardStacks true : CMP used non-IAB standard stacks during consent gathering, false : IAB standard stacks were used 
          # @return [VendorConsentBuilder] self
          def withUseNonStandardStacks(useNonStandardStacks)
            @consent_core.use_non_standard_stacks = useNonStandardStacks
            self
          end

          #
          # The TCF Policies designates certain Features as “special” which means a CMP 
          # must afford the user a means to opt in to their use. These “Special Features”
          # are published and numerically identified in the Global Vendor List separately
          #  from normal Features. 
          #
          # @param [Integer ] id Special Feature id
          # @param [Boolean] val Optin Boolean value
          # @return [VendorConsentBuilder] self
          def withSpecialFeatureOptIn(id, val)
            @consent_core.set_special_feature_opt_in(id, val)
            self
          end

          #
          # Set SpecialFeatureOptIn with an array
          #
          # @param [Array] arr index array
          # @return [VendorConsentBuilder] self
          #
          def withSpecialFeatureOptIns(arr)
            arr.each do |id|
              @consent_core.set_special_feature_opt_in(id, true)
            end
            self
          end

          #
          # The user’s consent value for each Purpose established on the legal basis of consent.
          # The Purposes are numerically identified and published in the Global Vendor List. 
          # From left to right, Purpose 1 maps to the 0th bit, purpose 24 maps to the bit at 
          # index 23. Special Purposes are a different ID space and not included in this field. 
          #
          # @param [Integer] id purpose id
          # @param [Boolean] val Consent Boolean value
          # @return [VendorConsentBuilder] self
          #
          def withPurposeConsent(id, val)
            @consent_core.set_purposes_consented(id, val)
            self
          end

          #
          # Set PurposeConsent wit an array of index
          #
          # @param [Array] arr index array
          # @return [VendorConsentBuilder] self
          #
          def withPurposeConsents(arr)
            arr.each do |id|
              @consent_core.set_purposes_consented(id, true)
            end
            self
          end

          #
          # The Purpose’s transparency requirements are met for each Purpose on the legal 
          # basis of legitimate interest and the user has not exercised their 
          # “Right to Object” to that Purpose.
          # By default or if the user has exercised their “Right to Object” to a Purpose, 
          # the corresponding bit for that Purpose is set to 0. From left to right, 
          # Purpose 1 maps to the 0th bit, purpose 24 maps to the bit at index 23. 
          # Special Purposes are a different ID space and not included in this field. 
          #
          # @param [Integer] id Purpose id
          # @param [Boolean] val true :  legitimate interest established. false : legitimate interest was NOT established or it was established but user exercised their “Right to Object” to the Purpose 
          # @return [VendorConsentBuilder] self
          #
          def withPurposeLITransparency(id, val)
            @consent_core.set_purposes_li_transparency(id, val)
            self
          end

          #
          # Set PurposesLITransparency wit an array of index
          #
          # @param [Array] arr index array
          # @return [VendorConsentBuilder] self
          #
          def withPurposesLITransparency(arr)
            arr.each do |id|
              @consent_core.set_purposes_li_transparency(id, true)
            end
            self
          end

          #
          # CMPs can use the PublisherCC field to indicate the legal jurisdiction the publisher is under to help vendors determine whether the vendor needs consent for Purpose 1.
          # In a globally-scoped TC string, this field must always have a value of 0. When a CMP encounters a globally-scoped TC String with PurposeOneTreatment=1 then it is considered 
          # invalid and the CMP must discard it and re-establish transparency and consent. 
          # @param [Boolean] purposeOneTreatment 1 Purpose 1 was NOT disclosed at all. 0 Purpose 1 was disclosed commonly as consent as expected by the Policies.
          # @return [VendorConsentBuilder] self
          #
          def withPurposeOneTreatment(purposeOneTreatment)
            @consent_core.purpose_one_treatment = purposeOneTreatment
            self
          end

          #
          # The country code of the country that determines legislation of reference. Commonly, this corresponds to the country in which the publisher’s business entity is established.
          # Each letter is encoded as 6 bits, a=0..z=25.
          # @param [String] publisherCC ISO 3166-1 alpha-2 code
          # @return [VendorConsentBuilder] self
          #
          def withPublisherCC(publisherCC)
            @consent_core.publisher_cc = publisherCC
            self
          end

          #
          # Add a Vendor consent section as a bit field
          #
          # @return [VendorConsentBuilder] self
          #
          def withBinaryVendorConsent()
            @consent_core.init_vendor_consent(ranged: false)
            self
          end

          #
          # Add a Vendor consent section as a range
          #
          # @return [VendorConsentBuilder] self
          #
          def withRangedVendorConsent()
            @consent_core.init_vendor_consent(ranged: true)
            self
          end

          #
          # Add a vendor in vendor section segment
          #
          # @param [Integer] vendor_id Vendor Id to add
          # @param [Integer] end_vendor_id end of range vendor id if any
          #
          # @return [VendorConsentBuilder] self
          #
          def addVendorConsent(vendor_id, end_vendor_id = nil)
            raise "Consent is binary set and cannot accept range" if end_vendor_id && @consent_core.vendor_consent.is_a?(VendorSectionBinary)
            if end_vendor_id
              @consent_core.vendor_consent.addVendor(vendor_id, end_vendor_id)
            else
              @consent_core.vendor_consent.addVendor(vendor_id)
            end
            self
          end

          #
          # Add Vendor legitimate interest as a bit field
          #
          # @return [VendorConsentBuilder] self
          #
          def withBinaryVendorLegitimateInterest()
            @consent_core.init_vendor_legitimate_interest(ranged: false)
            self
          end

          #
          # Add Vendor legitimate interest as a range
          #
          # @return [VendorConsentBuilder] self
          #
          def withRangedVendorLegitimateInterest()
            @consent_core.init_vendor_legitimate_interest(ranged: true)
            self
          end

          #
          # Add a vendor as a legitimate interest
          #
          # @param [Integer] vendor_id Vendor Id to add
          # @param [Integer] end_vendor_id end of range vendor id if any
          #
          # @return [VendorConsentBuilder] self
          #
          def addVendorLegitimateInterest(vendor_id, end_vendor_id = nil)
            raise "Consent is binary set and cannot accept range" if end_vendor_id && @consent_core.vendor_legitimate_interest.is_a?(VendorSectionBinary)
            if end_vendor_id
              @consent_core.vendor_legitimate_interest.addVendor(vendor_id, end_vendor_id)
            else
              @consent_core.vendor_legitimate_interest.addVendor(vendor_id)
            end
            self
          end

          #
          # Add a publisher restriction per vendor
          #
          # @param [IABConsentString::Consent::Implementation::V2::VendorSectionRanged] vendor Vendor container
          # @param [Integer] purpose_id Purpose ID
          # @param [Integer] restriction Restriction Values
          #
          # @return [VendorConsentBuilder] self
          #
          def withPublisherRestriction(vendor, purpose_id, restriction)
            @consent_core.publisher_restrictions.addRestriction(purpose_id, restriction, vendor)
            self
          end

          #
          # Add Disclose Vendor segment as a binary field
          #
          # @return [VendorConsentBuilder] self
          #
          def withBinaryDisclosedVendor
            @disclosed_vendor = VendorSectionBuilder.build(is_ranged_encoding: false)
            self
          end

          #
          # Add Disclose Vendor segment as a range
          #
          # @return [VendorConsentBuilder] self
          #
          def withRangedDisclosedVendor
            @disclosed_vendor = VendorSectionBuilder.build(is_ranged_encoding: true)
            self
          end

          #
          # Add a disclosed vendor
          #
          # @param [Integer] vendor_id Vendor Id to add
          # @param [Integer] end_vendor_id end of range vendor id if any
          #
          # @return [VendorConsentBuilder] self
          #
          def addDisclosedVendor(vendor_id, end_vendor_id = nil)
            raise "Consent is binary set and cannot accept range" if end_vendor_id && @disclosed_vendor.is_a?(VendorSectionBinary)
            if end_vendor_id
              @disclosed_vendor.addVendor(vendor_id, end_vendor_id)
            else
              @disclosed_vendor.addVendor(vendor_id)
            end
            self
          end

          #
          # Add Allowed Vendor segment as a binary field
          #
          # @return [VendorConsentBuilder] self
          #
          def withBinaryAllowedVendor
            @allowed_vendor = VendorSectionBuilder.build(is_ranged_encoding: false)
            self
          end

          #
          # Add Allowed Vendor segment as a binary field
          #
          # @return [VendorConsentBuilder] self
          #
          def withRangedAllowedVendor
            @allowed_vendor = VendorSectionBuilder.build(is_ranged_encoding: true)
            self
          end

          #
          # Add an allowed vendor to the allo vendor segment
          #
          # @param [Integer] vendor_id Vendor Id to add
          # @param [Integer] end_vendor_id end of range vendor id if any
          #
          # @return [VendorConsentBuilder] self
          #
          def addAllowedVendor(vendor_id, end_vendor_id = nil)
            raise "Consent is binary set and cannot accept range" if end_vendor_id && @allowed_vendor.is_a?(VendorSectionBinary)
            if end_vendor_id
              @allowed_vendor.addVendor(vendor_id, end_vendor_id)
            else
              @allowed_vendor.addVendor(vendor_id)
            end
            self
          end

          #
          # build a byte buffer
          #
          # @return [IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent] byte buffer object
          #
          def build
            coreBitBufferSizeInBits = IABConsentString::GDPRConstantsV2::Core::VENDOR_START_SECTION_OFFSET
            coreBitBufferSizeInBits += @consent_core.vendor_consent.string_bit_size
            coreBitBufferSizeInBits += @consent_core.vendor_legitimate_interest.string_bit_size
            coreBitBufferSizeInBits += @consent_core.publisher_restrictions.string_bit_size
            bits_core = IABConsentString::Bits.new(Array.new(coreBitBufferSizeInBits.fdiv(8).ceil, 0b0))
            bits_core.setInt(IABConsentString::GDPRConstantsV2::Core::VERSION_BIT_OFFSET, IABConsentString::GDPRConstantsV2::Core::VERSION_BIT_SIZE, 2)
            bits_core.setDateTimeToEpochDeciseconds(IABConsentString::GDPRConstantsV2::Core::CREATED_BIT_OFFSET, IABConsentString::GDPRConstantsV2::Core::CREATED_BIT_SIZE, @consent_core.consent_record_created)
            bits_core.setDateTimeToEpochDeciseconds(IABConsentString::GDPRConstantsV2::Core::UPDATED_BIT_OFFSET, IABConsentString::GDPRConstantsV2::Core::UPDATED_BIT_SIZE, @consent_core.consent_record_last_updated)
            bits_core.setInt(IABConsentString::GDPRConstantsV2::Core::CMP_ID_OFFSET, IABConsentString::GDPRConstantsV2::Core::CMP_ID_SIZE, @consent_core.cmp_id)
            bits_core.setInt(IABConsentString::GDPRConstantsV2::Core::CMP_VERSION_OFFSET, IABConsentString::GDPRConstantsV2::Core::CMP_VERSION_SIZE, @consent_core.cmp_version)
            bits_core.setInt(IABConsentString::GDPRConstantsV2::Core::CONSENT_SCREEN_OFFSET, IABConsentString::GDPRConstantsV2::Core::CONSENT_SCREEN_SIZE, @consent_core.consent_screen)
            bits_core.setSixBitString(IABConsentString::GDPRConstantsV2::Core::CONSENT_LANGUAGE_OFFSET, IABConsentString::GDPRConstantsV2::Core::CONSENT_LANGUAGE_SIZE, @consent_core.consent_language)
            bits_core.setInt(IABConsentString::GDPRConstantsV2::Core::VENDOR_LIST_VERSION_OFFSET, IABConsentString::GDPRConstantsV2::Core::VENDOR_LIST_VERSION_SIZE, @consent_core.vendor_list_version)
            bits_core.setInt(IABConsentString::GDPRConstantsV2::Core::TCF_POLICY_VERSION_OFFSET, IABConsentString::GDPRConstantsV2::Core::TCF_POLICY_VERSION_SIZE, @consent_core.tcf_policy_version)
            bits_core.setBoolean(IABConsentString::GDPRConstantsV2::Core::IS_SERVICE_SPECIFIC_OFFSET, @consent_core.is_service_specific)
            bits_core.setBoolean(IABConsentString::GDPRConstantsV2::Core::USE_NON_STANDARD_STACKS_OFFSET, @consent_core.use_non_standard_stacks)
            @consent_core.special_feature_opt_in.each_with_index do |consent, index|
              bits_core.setBoolean(IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_OFFSET + index, consent)
            end
            @consent_core.purposes_consented.each_with_index do |consent, index|
              bits_core.setBoolean(IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_OFFSET + index, consent)
            end
            @consent_core.purposes_li_transparency.each_with_index do |consent, index|
              bits_core.setBoolean(IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_OFFSET + index, consent)
            end
            bits_core.setBoolean(IABConsentString::GDPRConstantsV2::Core::PURPOSE_ONE_TREATMENT_OFFSET, @consent_core.purpose_one_treatment)
            bits_core.setSixBitString(IABConsentString::GDPRConstantsV2::Core::PUBLISHER_CC_OFFSET, IABConsentString::GDPRConstantsV2::Core::PUBLISHER_CC_SIZE, @consent_core.publisher_cc)
            @consent_core.vendor_consent.write_bits(bits_core, IABConsentString::GDPRConstantsV2::Core::VENDOR_START_SECTION_OFFSET)
            offset = IABConsentString::GDPRConstantsV2::Core::VENDOR_START_SECTION_OFFSET + @consent_core.vendor_consent.string_bit_size
            @consent_core.vendor_legitimate_interest.write_bits(bits_core, offset)
            offset = IABConsentString::GDPRConstantsV2::Core::VENDOR_START_SECTION_OFFSET + @consent_core.vendor_consent.string_bit_size + @consent_core.vendor_legitimate_interest.string_bit_size
            @consent_core.publisher_restrictions.write_bits(bits_core, offset)

            bits = [bits_core]

            if @disclosed_vendor
              disclosedVendorBitBufferSizeInBits = IABConsentString::GDPRConstantsV2::Segment::VENDOR_START_SECTION_OFFSET + @disclosed_vendor.string_bit_size
              bits_disclosed = IABConsentString::Bits.new(Array.new(disclosedVendorBitBufferSizeInBits.fdiv(8).ceil, 0b0))
              bits_disclosed.setInt(IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_OFFSET, IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_SIZE, 1)
              @disclosed_vendor.write_bits(bits_disclosed, IABConsentString::GDPRConstantsV2::Segment::VENDOR_START_SECTION_OFFSET)
              bits << bits_disclosed
            end

            if @allowed_vendor
              allowedVendorBitBufferSizeInBits = IABConsentString::GDPRConstantsV2::Segment::VENDOR_START_SECTION_OFFSET + @allowed_vendor.string_bit_size
              bits_allowed = IABConsentString::Bits.new(Array.new(allowedVendorBitBufferSizeInBits.fdiv(8).ceil, 0b0))
              bits_allowed.setInt(IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_OFFSET, IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_SIZE, 2)
              @allowed_vendor.write_bits(bits_allowed, IABConsentString::GDPRConstantsV2::Segment::VENDOR_START_SECTION_OFFSET)
              bits << bits_allowed
            end

            IABConsentString::Consent::Implementation::V2::ByteBufferBackedVendorConsent.new(*bits)
          end
        end
      end
    end
  end
end
