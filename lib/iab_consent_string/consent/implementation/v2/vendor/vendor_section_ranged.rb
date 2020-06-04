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
            @vendor.map { |v| v.end_vendor_id || v.vendor_id }.max || 0
          end

          def string_bit_size
            size = IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET
            size += range_vendor_bit_size
            size
          end

          def range_vendor_bit_size
            size = IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE
            res = @vendor.inject(size) do |sum, v|
              if v.is_a_ranged
                sum + 2 * IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE + 1 #start vendor id + end_vendor id + range bit
              else
                sum + IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE + 1 #start vendor id + range bit
              end
            end
            res
          end

          def to_bit_string
            b = Bits.new(Array.new(string_bit_size.fdiv(8).ceil, 0))
            write_bits(b, 0)
            b.getBinaryString
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

          def write_bits(bits, start_offset)
            @cursor = start_offset
            bits.setInt(@cursor, IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE, vendor_size)
            @cursor += IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE
            bits.setBoolean(@cursor, true)
            @cursor += 1
            @cursor += write_bits_no_vendor_size(bits, @cursor)
            bits
          end

          def write_bits_no_vendor_size(bits, start_offset)
            @cursor = start_offset
            bits.setInt(@cursor, IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE, num_entry)
            @cursor += IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE
            @vendor.each do |v|
              bits.setBoolean(@cursor, v.is_a_ranged)
              @cursor += 1
              bits.setInt(@cursor, IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE, v.vendor_id)
              @cursor += IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE
              if v.is_a_ranged
                bits.setInt(@cursor, IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE, v.end_vendor_id)
                @cursor += IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE
              end
            end
            @cursor
          end
        end
      end
    end
  end
end