require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative 'purpose_restriction.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class PublisherRestrictionSection
          def initialize
            @purposes = {}
          end

          #
          # Add a restriction to the object
          #
          # @param [Integer] purpose_id purpose ID
          # @param [Integer] restriction restriction type
          # @param [VendorSectionRanged] vendor_section vendor section
          #
          # @return [PublisherRestrictionSection] return self
          #
          def addRestriction(purpose_id, restriction, vendor_section)
            @purposes[purpose_id] = PurposeRestriction.new(purpose_id, restriction, vendor_section)
            self
          end

          #
          # Get restrriction on purpose and vendor
          #
          # @param [Integer] purpose_id Purpose ID
          # @param [Integer] vendor_id Vendor ID
          #
          # @return [Integer] restriction type
          #
          def getRestriction(purpose_id, vendor_id)
            if @purposes[purpose_id]
              return @purposes[purpose_id].restriction if @purposes[purpose_id].vendors.isVendorConsented(vendor_id)
            end
            return PurposeRestriction::UNDEFINED
          end

          def inspect
            @purposes.inspect
          end

          def pub_restriction_size
            @purposes.keys.size
          end

          def to_bit_string
            str = sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::NUM_PUB_RESTRICTIONS_SIZE}b", pub_restriction_size)
            @purposes.each do |k, pr|
              str += sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::PURPOSE_ID_SIZE}b", k.to_i)
              str += sprintf("%0#{IABConsentString::GDPRConstantsV2::Core::RESTRICTION_TYPE_SIZE}b", pr.restriction)
              str += pr.vendors.to_bit_string_no_vendor_size
            end
            str
          end
        end
      end
    end
  end
end