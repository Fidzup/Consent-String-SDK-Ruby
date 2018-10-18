module IABConsentString
  module Consent
    module Range
      class RangeEntry
        # Append this range entry to the bit buffer
        # @param buffer [Bits] bit buffer
        # @param currentOffset [Integer] current offset in the buffer
        # @return [Integer] new offset
        def appendTo(buffer, currentOffset)
          raise NotImplementedError
        end

        # Check if range entry is valid for the specified max vendor id
        # @param maxVendorId [Integer] max vendor id
        # @return [Boolean] true if range entry is valid, false otherwise
        def valid(maxVendorId)
          raise NotImplementedError
        end
      end
    end
  end
end
