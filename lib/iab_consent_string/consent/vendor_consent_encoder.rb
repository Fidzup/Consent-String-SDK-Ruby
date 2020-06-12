require 'base64'

module IABConsentString
  module Consent
    class VendorConsentEncoder
      # Encode vendor consent to Base64 string
      # @param vendorConsent [VendorConsent] vendor consent
      # @return [String] Base64 encoded string
      def self.toBase64String(vendorConsent)
        vendorConsent.toByteArrayList.map do |arr|
          Base64.urlsafe_encode64(arr.pack("C*") , padding: false)
        end.join(".")
      end
    end
  end
end
