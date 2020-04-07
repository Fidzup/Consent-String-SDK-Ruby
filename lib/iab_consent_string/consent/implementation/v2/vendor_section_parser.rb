require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class VendorSectionParser
          def initialize(bits, start_point)
            @bits = bits
            @start_point = start_point
          end

          def parse
            is_range_encoding = getIsRangeEncoding
            max_vendor_id = getMaxVendorId
            vendor_section = VendorSectionBuilder.build(is_ranged_encoding: is_range_encoding)
            if is_range_encoding
              # ranged
              start_range_offset = @start_point + IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET + max_vendor_id
              num_entry = @bits.getInt(start_range_offset, IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE)
              current_offset = start_range_offset + IABConsentString::GDPRConstantsV2::Core::VENDOR_RANGE_NUM_ENTRY_SIZE
              for i in (1..num_entry)
                is_range = @bits.getBit(current_offset)
                current_offset += 1
                vendor_id = @bits.getInt(current_offset, IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE)
                current_offset += IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE
                end_vendor_id = nil
                if is_range
                  end_vendor_id = @bits.getInt(current_offset, IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE)
                  current_offset += IABConsentString::GDPRConstantsV2::Core::VENDOR_ID_SIZE
                end
                vendor_section.addVendor(vendor_id, end_vendor_id)
              end
            else
              # bits
              for vendor_id in (1..max_vendor_id) do
                consent = @bits.getBit(@start_point + IABConsentString::GDPRConstantsV2::Core::VENDOR_SECTION_OFFSET + vendor_id -1)
                vendor_section.addVendor(vendor_id) if consent
              end
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