require 'set'
require 'date'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/vendor_consent'

module IABConsentString
  module Consent
    module Implementation
      module V2
        module ByteBufferBackedPublisherPurposesTransparency
          def getPubPurposeConsent(purpose_id)
            @bits_publisher_purpose.getBit(IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_CONSENT_OFFSET + purpose_id - 1)
          end

          def getPubPurposeLITransparency(purpose_id)
            @bits_publisher_purpose.getBit(IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_LI_TRANSPARENCY_OFFSET + purpose_id - 1)
          end

          def getNumCustomPurposes
            @bits_publisher_purpose.getInt(IABConsentString::GDPRConstantsV2::PubPurposesTransparency::NUM_CUSTOM_PURPOSES_OFFSET, IABConsentString::GDPRConstantsV2::PubPurposesTransparency::NUM_CUSTOM_PURPOSES_SIZE)
          end

          def getCustomPurposeConsent(purpose_id)
            num_custom_purposes = getNumCustomPurposes
            return nil unless (purpose_id > 0 && purpose_id <= num_custom_purposes)
            @bits_publisher_purpose.getBit(IABConsentString::GDPRConstantsV2::PubPurposesTransparency::CUSTOM_PURPOSES_OFFSET + purpose_id - 1)
          end

          def getCustomPurposeLITransparency(purpose_id)
            num_custom_purposes = getNumCustomPurposes
            return nil unless (purpose_id > 0 && purpose_id <= num_custom_purposes)
            offset = IABConsentString::GDPRConstantsV2::PubPurposesTransparency::CUSTOM_PURPOSES_OFFSET + num_custom_purposes
            @bits_publisher_purpose.getBit(offset + purpose_id - 1)
          end

        end
      end
    end
  end
end
