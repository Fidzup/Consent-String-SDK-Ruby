require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative '../vendor/vendor_section.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        module Container
          class PublisherTC
            def initialize
              @pub_purpose_consent = Array.new(IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_CONSENT_SIZE, false)
              @pub_purpose_li_transparency = Array.new(IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_LI_TRANSPARENCY_SIZE, false)
              @custom_purpose_consent = {}
              @custom_purpose_li_transparency = {}
            end

            def custom_size
              (@custom_purpose_consent.keys.map(&:to_i) + @custom_purpose_li_transparency.keys.map(&:to_i)).max || 0
            end

            def add_legal_purpose(id, val)
              unless id > 0 and id <= IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_CONSENT_SIZE
                raise "Invalid id number", caller
              end
              @pub_purpose_consent[id - 1] = val
            end

            def is_legal_purpose_consented(id)
              unless id > 0 and id <= IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_CONSENT_SIZE
                raise "Invalid id number", caller
              end
              @pub_purpose_consent[id - 1]
            end


            def add_legal_purpose_transparency(id, val)
              unless id > 0 and id <= IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_LI_TRANSPARENCY_SIZE
                raise "Invalid id number", caller
              end
              @pub_purpose_li_transparency[id - 1] = val
            end

            def is_legal_purpose_transparency_required(id)
              unless id > 0 and id <= IABConsentString::GDPRConstantsV2::PubPurposesTransparency::PUB_PURPOSES_CONSENT_SIZE
                raise "Invalid id number", caller
              end
              @pub_purpose_li_transparency[id - 1]
            end

            def add_custom_purpose_consent(id, val)
              @custom_purpose_consent[id] =val
            end

            def is_custom_purpose_consented(id)
              @custom_purpose_consent[id] || false
            end

            def add_custom_transparency_required(id, val)
              @custom_purpose_li_transparency[id] =val
            end

            def is_custom_transparency_required(id)
              @custom_purpose_li_transparency[id] || false
            end
          end
        end
      end
    end
  end
end