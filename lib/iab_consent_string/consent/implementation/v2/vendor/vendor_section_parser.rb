require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class VendorSectionParser
          attr_reader :current_offset

          def initialize(bits, start_point)
            @bits = bits
            @start_point = start_point
            @current_offset = start_point
          end

          def parse
            is_range_encoding = getIsRangeEncoding
            @current_offset += IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE
            max_vendor_id = getMaxVendorId
            @current_offset += 1
            if is_range_encoding
              # ranged
              vendor_section = parse_range_vendor
            else
              # bits
              vendor_section = VendorSectionBuilder.build(is_ranged_encoding: is_range_encoding)
              for vendor_id in (1..max_vendor_id) do
                consent = @bits.getBit(@start_point + IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET + vendor_id - 1)
                vendor_section.addVendor(vendor_id) if consent
              end
              @current_offset += max_vendor_id
            end
            vendor_section
          end

          def parse_range_vendor
            vendor_section = VendorSectionBuilder.build(is_ranged_encoding: true)
            num_entry = @bits.getInt(@current_offset, IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE)
            @current_offset += IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE
            num_entry.times do
              is_range = @bits.getBit(@current_offset)
              @current_offset += 1
              vendor_id = @bits.getInt(@current_offset, IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE)
              @current_offset += IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE
              end_vendor_id = nil
              if is_range
                end_vendor_id = @bits.getInt(@current_offset, IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE)
                @current_offset += IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE
              end
              vendor_section.addVendor(vendor_id, end_vendor_id)
            end
            vendor_section
          end

          def getMaxVendorId
            @bits.getInt(@start_point,IABConsentString::GDPRConstantsV2::Core::MAX_VENDOR_ID_SIZE)
          end

          def getIsRangeEncoding
            @bits.getBit(@start_point + IABConsentString::GDPRConstantsV2::Core::VENDOR_IS_RANGE_ENCODING_OFFSET)
          end
        end
      end
    end
  end
end