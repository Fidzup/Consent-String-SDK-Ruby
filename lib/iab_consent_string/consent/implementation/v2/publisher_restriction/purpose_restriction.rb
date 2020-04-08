require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/implementation/v2/vendor/vendor_section_ranged'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class PurposeRestriction

          NOT_ALLOWED        = 0
          REQUIRE_CONSENT    = 1
          REQUIRE_LEGITIMATE = 2
          UNDEFINED          = 3

          attr_accessor :vendors, :purpose_id, :restriction
          def initialize(purpose_id, restriciton=UNDEFINED, vendor)
            @purpose_id = purpose_id
            @vendors = vendor
            @restriction = restriciton
          end
        end
      end
    end
  end
end