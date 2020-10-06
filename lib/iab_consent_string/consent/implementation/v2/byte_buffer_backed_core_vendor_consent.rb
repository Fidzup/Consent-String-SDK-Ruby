require 'set'
require 'date'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/vendor_consent'

module IABConsentString
  module Consent
    module Implementation
      module V2
        module ByteBufferBackedVendorConsentCore
          def getVersion
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::VERSION_BIT_OFFSET,IABConsentString::GDPRConstantsV2::Core::VERSION_BIT_SIZE)
          end

          def getConsentRecordCreated
            @bits_core.getDateTimeFromEpochDeciseconds(IABConsentString::GDPRConstantsV2::Core::CREATED_BIT_OFFSET, IABConsentString::GDPRConstantsV2::Core::CREATED_BIT_SIZE)
          end

          def getConsentRecordLastUpdated
            @bits_core.getDateTimeFromEpochDeciseconds(IABConsentString::GDPRConstantsV2::Core::UPDATED_BIT_OFFSET,IABConsentString::GDPRConstantsV2::Core::UPDATED_BIT_SIZE)
          end

          def getCmpId
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::CMP_ID_OFFSET,IABConsentString::GDPRConstantsV2::Core::CMP_ID_SIZE)
          end

          def getCmpVersion
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::CMP_VERSION_OFFSET,IABConsentString::GDPRConstantsV2::Core::CMP_VERSION_SIZE)
          end

          def getConsentScreen
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::CONSENT_SCREEN_OFFSET,IABConsentString::GDPRConstantsV2::Core::CONSENT_SCREEN_SIZE)
          end

          def getConsentLanguage
            @bits_core.getSixBitString(IABConsentString::GDPRConstantsV2::Core::CONSENT_LANGUAGE_OFFSET,IABConsentString::GDPRConstantsV2::Core::CONSENT_LANGUAGE_SIZE)
          end

          def getVendorListVersion
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::VENDOR_LIST_VERSION_OFFSET,IABConsentString::GDPRConstantsV2::Core::VENDOR_LIST_VERSION_SIZE)
          end

          def getTcfPolicyVersion
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::TCF_POLICY_VERSION_OFFSET,IABConsentString::GDPRConstantsV2::Core::TCF_POLICY_VERSION_SIZE)
          end

          def getIsServiceSpecific
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::IS_SERVICE_SPECIFIC_OFFSET)
          end

          def getUseNonStandardStacks
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::USE_NON_STANDARD_STACKS_OFFSET)
          end

          def isSpecialFeatureOptIn(id)
            if ((id < 1) || (id > IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_SIZE))
              return false
            end
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_OFFSET + id - 1);
          end

          def getSpecialFeatureOptIns
            return (1..IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_SIZE).select { |i| self.isSpecialFeatureOptIn(i) }
          end

          def isPurposesConsented(purpose_id)
            if ((purpose_id < 1) || (purpose_id > IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_SIZE))
              return false
            end
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_OFFSET + purpose_id - 1);
          end

          def getAllowedPurposeIds
            return (1..IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_SIZE).select { |i| self.isPurposesConsented(i) }
          end

          def isPurposeLITransparency(purpose_id)
            if ((purpose_id < 1) || (purpose_id > IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_SIZE))
              return false
            end
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_OFFSET + purpose_id - 1);
          end

          def getPurposesLiTransparency
            return (1..IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_SIZE).select { |i| self.isPurposeLITransparency(i) }
          end

          def getPurposeOneTreatment
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::PURPOSE_ONE_TREATMENT_OFFSET);
          end

          def getPublisherCC
            @bits_core.getSixBitString(IABConsentString::GDPRConstantsV2::Core::PUBLISHER_CC_OFFSET,IABConsentString::GDPRConstantsV2::Core::PUBLISHER_CC_SIZE)
          end

          def getVendorConsent
            parser = IABConsentString::Consent::Implementation::V2::VendorSectionParser.new(@bits_core, IABConsentString::GDPRConstantsV2::Core::VENDOR_START_SECTION_OFFSET)
            vendor_consent = parser.parse
            @end_vendor_consent = parser.current_offset
            vendor_consent
          end

          def isVendorConsented(id)
            self.getVendorConsent.isVendorConsented(id)
          end

          def getMaxVendorId()
            self.getVendorConsent.vendor_size
          end

          #WARNING Refer to consented vendor
          def getAllowedVendorIds()
            (1..self.getMaxVendorId()).select { |i| self.isVendorConsented(i) }
          end

          def getVendorLegitimateInterest
            getVendorConsent unless @end_vendor_consent
            parser = IABConsentString::Consent::Implementation::V2::VendorSectionParser.new(@bits_core, @end_vendor_consent)
            vendor_consent = parser.parse
            @end_vendor_legitimate_interest = parser.current_offset
            vendor_consent
          end

          def isVendorLegitimateInterested(id)
            self.getVendorLegitimateInterest.isVendorConsented(id)
          end

          # get publisher restriction
          # @return [PublisherRestrictionSection] publisher restriction object
          def getPublisherRestrictions
            getVendorLegitimateInterest unless @end_vendor_legitimate_interest
            parser = IABConsentString::Consent::Implementation::V2::PublisherRestrictionParser.new(@bits_core, @end_vendor_legitimate_interest)
            publisher_restriction = parser.parse
            publisher_restriction
          end

          def getPublisherRestriction(purpose_id, vendor_id)
            self.getPublisherRestrictions.getRestriction(purpose_id, vendor_id)
          end
          
        end
      end
    end
  end
end
