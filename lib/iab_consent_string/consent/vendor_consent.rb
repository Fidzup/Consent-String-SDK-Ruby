module IABConsentString
  module Consent
    class VendorConsent
      #/**
      # * @return the version of consent string format
      # */
      def getVersion()
        raise NotImplementedError
      end

      #/**
      # * @return the time (milli since epoch) at which the consent string was created
      # */
      def getConsentRecordCreated()
        raise NotImplementedError
      end

      #/**
      # * @return the time (milli since epoch) at which the consent string was last updated
      # */
      def getConsentRecordLastUpdated()
        raise NotImplementedError
      end

      #/**
      # * @return the Consent Manager Provider ID that last updated the consent string
      # */
      def getCmpId()
        raise NotImplementedError
      end

      #/**
      # * @return the Consent Manager Provider version
      # */
      def getCmpVersion()
        raise NotImplementedError
      end

      #/**
      # * @return the screen number in the CMP where consent was given
      # */
      def getConsentScreen()
        raise NotImplementedError
      end

      #/**
      # * @return the two-letter ISO639-1 language code that CMP asked for consent in
      # */
      def getConsentLanguage()
        raise NotImplementedError
      end

      #/**
      # * @return version of vendor list used in most recent consent string update.
      # */
      def getVendorListVersion()
        raise NotImplementedError
      end

      #/**
      # * @return the set of purpose id's which are permitted according to this consent string
      # */
      def getAllowedPurposesIds()
        raise NotImplementedError
      end

      #/**
      # * @return the set of allowed purposes which are permitted according to this consent string
      # */
      def getAllowedPurposes()
        raise NotImplementedError
      end

      #/**
      # * @return an integer equivalent of allowed purpose id bits according to this consent string
      # */
      def getAllowedPurposesBits()
        raise NotImplementedError
      end

      #/**
      # * @return the maximum VendorId for which consent values are given.
      # */
      def getMaxVendorId()
        raise NotImplementedError
      end

      #/**
      # * Check wether purpose with specified ID is allowed
      # * @param purposeId purpose ID
      # * @return true if purpose is allowed in this consent, false otherwise
      # */
      def isPurposeIdAllowed(purposeId)
        raise NotImplementedError
      end

      #/**
      # * Check wether specified purpose is allowed
      # * @param purpose purpose to check
      # * @return true if purpose is allowed in this consent, false otherwise
      # */
      def isPurposeAllowed(purpose)
        raise NotImplementedError
      end

      #/**
      # * Check wether vendor with specified ID is allowed
      # * @param vendorId vendor ID
      # * @return true if vendor is allowed in this consent, false otherwise
      # */
      def isVendorAllowed(vendorId)
        raise NotImplementedError
      end

      #/**
      # * @return the value of this consent as byte array
      # */
      def toByteArray()
        raise NotImplementedError
      end
    end
  end
end
