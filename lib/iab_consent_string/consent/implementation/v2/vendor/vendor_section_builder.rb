require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative  'vendor_section_binary.rb'
require_relative  'vendor_section_ranged.rb'


module IABConsentString
  module Consent
    module Implementation
      module V2
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