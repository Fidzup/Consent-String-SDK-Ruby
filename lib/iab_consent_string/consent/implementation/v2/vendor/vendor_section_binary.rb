require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class VendorSectionBinary
          def initialize
            @vendor = {}
          end

          def isVendorConsented(id)
            @vendor.dig(id)&.is_consented?(id) || false
          end

          def addVendor(id)
            @vendor[id] = Vendor.new(id)
            self
          end

          def inspect
            @vendor.inspect
          end
        end
      end
    end
  end
end