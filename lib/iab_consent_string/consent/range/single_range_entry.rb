require 'iab_consent_string/consent/range/range_entry'
require 'iab_consent_string/gdpr_constants'

module IABConsentString
  module Consent
    module Range
      class SingleRangeEntry < RangeEntry

        def initialize(singleVendorId)
          @singleVendorId = singleVendorId
        end

        def size()
          #  One bit for SingleOrRange flag, VENDOR_ID_SIZE for single vendor ID
          1 + IABConsentString::GDPRConstants::VENDOR_ID_SIZE
        end

        def appendTo(buffer, currentOffset)
          newOffset = currentOffset
          buffer.unsetBit(newOffset)
          newOffset += 1
          buffer.setInt(newOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE, @singleVendorId)
          newOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
          newOffset
        end

        def valid(maxVendorId)
          (@singeVendorId > 0) && (@singeVendorId <= maxVendorId)
        end
      end
    end
  end
end
