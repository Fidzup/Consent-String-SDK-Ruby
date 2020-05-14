require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative './vendor_section_base.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class VendorSectionBinary < VendorSectionBase
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
            @vendor.to_a.select{ |e| e[1] }.map{|e| e[0]}.inspect
          end

          def vendor_size
            @vendor.keys.map(&:to_i).max
          end

          def string_bit_size
            size = IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET
            size += self.vendor_size
            size
          end

          def to_bit_string
            str = sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE}b", vendor_size)
            str += "0"
            for i in (1..vendor_size)
              str << (isVendorConsented(i) ? "1" : "0")
            end
            str
          end
        end
      end
    end
  end
end