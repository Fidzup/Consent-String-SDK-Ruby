require 'base64'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/implementation/v1/byte_buffer_backed_vendor_consent'

module IABConsentString
  module Consent
    class VendorConsentDecoder
      def self.fromBase64String(consentString)
        if consentString.nil?
          raise "Null or empty consent string passed as an argument"
        end
        fromByteArray(Base64.urlsafe_decode64(consentString).bytes.to_a)
      end

      def self.fromByteArray(bytes)
        if ( bytes.nil?  || bytes.length == 0)
          raise "Null or empty consent string passed as an argument"
        end
        bits = Bits.new(bytes)
        version = getVersion(bits)
        case version
        when 1
          IABConsentString::Consent::Implementation::V1::ByteBufferBackedVendorConsent.new(bits)
        else
          raise "Unsupported version: " + version.to_s
        end
      end

      def self.getVersion(bits)
        bits.getInt(IABConsentString::GDPRConstants::VERSION_BIT_OFFSET, IABConsentString::GDPRConstants::VERSION_BIT_SIZE)
      end
    end
  end
end
