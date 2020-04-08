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
        end
      end
    end
  end
end