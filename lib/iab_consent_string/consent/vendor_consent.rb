module IABConsentString
  module Consent
    class VendorConsent
      # @return [Integer] the version of consent string format
      def getVersion
        raise NotImplementedError
      end

      # @return [Timestamp] the time (milli since epoch) at which the consent string was created
      def getConsentRecordCreated
        raise NotImplementedError
      end

      # @return [Timestamp] the time (milli since epoch) at which the consent string was last updated
      def getConsentRecordLastUpdated
        raise NotImplementedError
      end

      # @return [Integer] the Consent Manager Provider ID that last updated the consent string
      def getCmpId
        raise NotImplementedError
      end

      # @return [Integer] the Consent Manager Provider version
      def getCmpVersion
        raise NotImplementedError
      end

      # @return [Integer] the screen number in the CMP where consent was given
      def getConsentScreen
        raise NotImplementedError
      end

      # @return [Char(2)] the two-letter ISO639-1 language code that CMP asked for consent in
      def getConsentLanguage
        raise NotImplementedError
      end

      # @return [Integer] version of vendor list used in most recent consent string update.
      def getVendorListVersion
        raise NotImplementedError
      end

      # @return [Set<Integer>] the set of purpose id's which are permitted according to this consent string
      def getAllowedPurposesIds
        raise NotImplementedError
      end

      # @return [Set<Purpose>] the set of allowed purposes which are permitted according to this consent string
      def getAllowedPurposes
        raise NotImplementedError
      end

      # @return [Integer] an integer equivalent of allowed purpose id bits according to this consent string
      def getAllowedPurposesBits
        raise NotImplementedError
      end

      # @return [Integer] the maximum VendorId for which consent values are given.
      def getMaxVendorId
        raise NotImplementedError
      end

      # Check wether purpose with specified ID is allowed
      # @param purposeId [Integer] purpose ID
      # @return [Boolean] true if purpose is allowed in this consent, false otherwise
      def isPurposeIdAllowed(purposeId)
        raise NotImplementedError
      end

      # Check wether specified purpose is allowed
      # @param purpose [Purpose] purpose to check
      # @return [Boolean] true if purpose is allowed in this consent, false otherwise
      def isPurposeAllowed(purpose)
        raise NotImplementedError
      end

      # Check wether vendor with specified ID is allowed
      # @param vendorId [Integer] vendor ID
      # @return [Boolean] true if vendor is allowed in this consent, false otherwise
      def isVendorAllowed(vendorId)
        raise NotImplementedError
      end

      # @return [Array<Byte>] the value of this consent as byte array
      def toByteArray
        raise NotImplementedError
      end
    end
  end
end
