require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative './vendor_section_base.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class VendorSectionRanged < VendorSectionBase
          def initialize
            # @type [Vendor[]]
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

          def inspect
            @vendor.inspect
          end

          def num_entry
            @vendor.size
          end

          def vendor_size
            @vendor.map { |v| v.end_vendor_id || v.vendor_id }.max
          end

          def string_bit_size
            size = IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET
            size += IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE
            size += range_vendor_bit_size
            size
          end

          def to_bit_string
            str = sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE}b", vendor_size)
            str += "1"
            str += to_bit_string_no_vendor_size
            str
          end

          def to_bit_string_no_vendor_size
            str = sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE}b", num_entry)
            @vendor.each do |v|
              if v.is_a_ranged
                str += "1"
                str += sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE}b", v.vendor_id)
                str += sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE}b", v.end_vendor_id)
              else
                str += "0"
                str += sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE}b", v.vendor_id)
              end
            end
            str
          end

          private
          def range_vendor_bit_size
            @vendor.inject do |sum, v|
              if v.is_a_ranged
                2 * ABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET + 1 #start vendor id + end_vendor id + range bit
              else
                ABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET + 1 #start vendor id + range bit
              end
            end
          end
        end
      end
    end
  end
end