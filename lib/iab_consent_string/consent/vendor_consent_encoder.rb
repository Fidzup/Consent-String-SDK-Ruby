require 'base64'

module IABConsentString
  module Consent
    class VendorConsentEncoder
      # Encode vendor consent to Base64 string
      # @param vendorConsent [VendorConsent] vendor consent
      # @return [String] Base64 encoded string
      def self.toBase64String(vendorConsent)
        # Encode Without Padding to respect IAB Consent String Spec
        Base64.urlsafe_encode64(vendorConsent.toByteArray().pack("C*") , padding: false)
      end
    end
  end
end
