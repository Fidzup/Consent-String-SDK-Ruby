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
            @vendor.keys.map(&:to_i).max || 0
          end

          def string_bit_size
            size = IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET
            size += self.vendor_size
            size
          end

          def to_bit_string
            b = Bits.new(Array.new(string_bit_size.fdiv(8).ceil, 0))
            write_bits(b, 0)
            b.getBinaryString
          end

          #
          # write vendor section into Bits object
          # @param [Bits] bits bits object to write into
          # @param [Integer] start_offset position to start writing
          # @return [Bits] modified bits
          def write_bits(bits, start_offset)
            cursor = start_offset
            bits.setInt(cursor, IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE, vendor_size)
            cursor += IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE
            bits.setBoolean(cursor, false)
            cursor += 1
            for i in (1..vendor_size)
              bits.setBoolean(cursor, isVendorConsented(i))
              cursor += 1
            end
            bits
          end
        end
      end
    end
  end
end