require 'set'
require 'date'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/vendor_consent'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class ByteBufferBackedVendorConsent < IABConsentString::Consent::VendorConsent
          def initialize(*bits)
            @bits_core = bits[0]
          end

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
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::CONSENT_SCREEN_SIZE_OFFSET,IABConsentString::GDPRConstantsV2::Core::CONSENT_SCREEN_SIZE)
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

          def getUseNonNtandardStacks
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::USE_NON_STANDARD_STACKS_OFFSET)
          end

          def isSpecialFeatureOptIn(id)
            if ((id < 1) || (id > IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_SIZE))
              return false
            end
            @bits_core.getBit(IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_OFFSET + id - 1);
          end

          def getPurposesConsent
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_OFFSET,IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_SIZE)
          end
          
          def getPurposesLiTransparency
            @bits_core.getInt(IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_OFFSET,IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_SIZE)
          end
        end
      end
    end
  end
end
