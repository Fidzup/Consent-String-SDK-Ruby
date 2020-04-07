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
        end

        class VendorSectionRanged
          def initialize
            @vendor = []
          end

          def isVendorConsented(id)
            @vendor.any? { |v| v.is_consented?(id) }
          end

          def addVendor(id, end_id=nil)
            if end_id
              @vendor << Vendor.new(id, true, end_id)
            else
              @vendor << Vendor.new(id)
            end
            self
          end
        end
        
        class VendorSectionBuilder
          def self.build(is_ranged_encoding:)
            if is_ranged_encoding
              VendorSectionRanged.new
            else
              VendorSectionBinary.new
            end
          end
        end
      end
    end
  end
end