require 'set'
require 'date'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/vendor_consent'
require_relative './byte_buffer_backed_core_vendor_consent.rb'
require_relative './byte_buffer_backed_allowed_vendor_consent.rb'
require_relative './byte_buffer_backed_disclosed_vendor_consent.rb'
require_relative './byte_buffer_backed_publisher_purposes_transparency.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class ByteBufferBackedVendorConsent < IABConsentString::Consent::VendorConsent
          include ByteBufferBackedVendorConsentCore
          include ByteBufferBackedDiscloedVendorConsent
          include ByteBufferBackedAllowedVendorConsent
          include ByteBufferBackedPublisherPurposesTransparency
          def initialize(*bits)
            @bits_core = bits[0]
            bits[1..]&.each do |bit|
              case getSegmentType(bit)
              when 1
                @bits_disclosed_vendors  = bit
              when 2
                @bits_allowed_vendors  = bit
              when 3
                @bits_publisher_purpose  = bit
              end
            end 
          end

          def getSegmentType(bits)
            bits.getInt(IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_OFFSET,IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_SIZE)
          end
        end
      end
    end
  end
end
