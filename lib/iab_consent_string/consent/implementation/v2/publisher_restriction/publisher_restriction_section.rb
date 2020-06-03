require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative 'purpose_restriction.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class PublisherRestrictionSection
          def initialize
            @purposes = {}
          end

          #
          # Add a restriction to the object
          #
          # @param [Integer] purpose_id purpose ID
          # @param [Integer] restriction restriction type
          # @param [VendorSectionRanged] vendor_section vendor section
          #
          # @return [PublisherRestrictionSection] return self
          #
          def addRestriction(purpose_id, restriction, vendor_section)
            @purposes[purpose_id] = PurposeRestriction.new(purpose_id, restriction, vendor_section)
            self
          end

          #
          # Get restrriction on purpose and vendor
          #
          # @param [Integer] purpose_id Purpose ID
          # @param [Integer] vendor_id Vendor ID
          #
          # @return [Integer] restriction type
          #
          def getRestriction(purpose_id, vendor_id)
            if @purposes[purpose_id]
              return @purposes[purpose_id].restriction if @purposes[purpose_id].vendors.isVendorConsented(vendor_id)
            end
            return PurposeRestriction::UNDEFINED
          end

          def inspect
            @purposes.inspect
          end

          def pub_restriction_size
            @purposes.keys.size
          end

          def string_bit_size
            size = IABConsentString::GDPRConstantsV2::Core::NUM_PUB_RESTRICTIONS_SIZE
            @purposes.each do |k, pr|
              size += IABConsentString::GDPRConstantsV2::Core::PURPOSE_ID_SIZE
              size += IABConsentString::GDPRConstantsV2::Core::RESTRICTION_TYPE_SIZE
              size += pr.vendors.range_vendor_bit_size
            end
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
            bits.setInt(cursor, IABConsentString::GDPRConstantsV2::Core::NUM_PUB_RESTRICTIONS_SIZE, pub_restriction_size)
            cursor += IABConsentString::GDPRConstantsV2::Core::NUM_PUB_RESTRICTIONS_SIZE
            @purposes.each do |k, pr|
              bits.setInt(cursor, IABConsentString::GDPRConstantsV2::Core::PURPOSE_ID_SIZE, k.to_i)
              cursor += IABConsentString::GDPRConstantsV2::Core::PURPOSE_ID_SIZE
              bits.setInt(cursor, IABConsentString::GDPRConstantsV2::Core::RESTRICTION_TYPE_SIZE, pr.restriction)
              cursor += IABConsentString::GDPRConstantsV2::Core::RESTRICTION_TYPE_SIZE
              cursor = pr.vendors.write_bits_no_vendor_size(bits,cursor)
            end
            bits
          end
        end
      end
    end
  end
end