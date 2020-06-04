require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class VendorSectionBase
          def string_bit_size
            size = IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET
            size
          end
        end
      end
    end
  end
end