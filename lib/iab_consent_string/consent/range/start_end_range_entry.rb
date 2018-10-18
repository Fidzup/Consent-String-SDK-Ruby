require 'iab_consent_string/consent/range/range_entry'
require 'iab_consent_string/gdpr_constants'

module IABConsentString
  module Consent
    module Range
      class StartEndRangeEntry < RangeEntry

        def initialize(startVendorId,endVendorId)
          @startVendorId = startVendorId
          @endVendorId = endVendorId
        end

        def size()
          #  One bit for SingleOrRange flag, 2 * VENDOR_ID_SIZE for 2 vendor IDs
          1 + ( IABConsentString::GDPRConstants::VENDOR_ID_SIZE * 2 )
        end

        def appendTo(buffer, currentOffset)
          newOffset = currentOffset
          buffer.setBit(newOffset)
          newOffset += 1
          buffer.setInt(newOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE, @startVendorId)
          newOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
          buffer.setInt(newOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE, @endVendorId)
          newOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
          newOffset
        end

        def valid(maxVendorId)
          (@startVendorId > 0) && (@endVendorId > 0) && (@startVendorId < @endVendorId) && (@endVendorId <= maxVendorId)
        end
      end
    end
  end
end
