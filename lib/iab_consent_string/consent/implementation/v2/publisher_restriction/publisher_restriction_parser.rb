require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative 'publisher_restriction_section.rb'
require 'pry'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class PublisherRestrictionParser
          attr_reader :current_offset

          def initialize(bits, start_point)
            @bits = bits
            @start_point = start_point
            @current_offset = start_point
          end

          #
          # parse publishere restriction
          #
          # @return [PublisherRestrictionSection] publisher restriction object>
          #
          def parse
            num_pub_restriction = getNumPubRestrictions
            publisher_restriction_section = PublisherRestrictionSection.new
            @current_offset += IABConsentString::GDPRConstantsV2::Core::NUM_PUB_RESTRICTIONS_SIZE
            num_pub_restriction.times do
              purpose_id = @bits.getInt(@current_offset,IABConsentString::GDPRConstantsV2::Core::PURPOSE_ID_SIZE)
              @current_offset += IABConsentString::GDPRConstantsV2::Core::PURPOSE_ID_SIZE
              restriction_type = @bits.getInt(@current_offset,IABConsentString::GDPRConstantsV2::Core::RESTRICTION_TYPE_SIZE)
              @current_offset += IABConsentString::GDPRConstantsV2::Core::RESTRICTION_TYPE_SIZE
              vendor_parser = IABConsentString::Consent::Implementation::V2::VendorSectionParser.new(@bits, @current_offset)
              vendor_consent = vendor_parser.parse_range_vendor
              @current_offset = vendor_parser.current_offset
              publisher_restriction_section.addRestriction(purpose_id, restriction_type, vendor_consent)
            end
            publisher_restriction_section
          end

          #
          # get the number of publisher restriction
          #
          # @return [Integer] number of publisher restriction
          #
          def getNumPubRestrictions
            @bits.getInt(@start_point,IABConsentString::GDPRConstantsV2::Core::NUM_PUB_RESTRICTIONS_SIZE)
          end
        end
      end
    end
  end
end