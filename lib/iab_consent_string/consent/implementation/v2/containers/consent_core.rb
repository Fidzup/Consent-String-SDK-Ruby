require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require_relative '../vendor/vendor_section.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        module Container
          class ConsentCore
            attr_accessor :consent_record_created, :consent_record_last_updated,
              :cmp_id, :cmp_version, :consent_screen, :consent_language, :vendor_list_version,
              :tcf_policy_version, :is_service_specific, :use_non_standard_stacks, :purposes_li_transparency, :purpose_one_treatment,
              :publisher_cc, :vendor_consent, :vendor_legitimate_interest, :publisher_restrictions

            def initialize
              @version = 2
              @consent_record_created = Time.now
              @consent_record_last_updated = Time.now
              @cmp_id = 0
              @cmp_version = 0
              @consent_screen = 0
              @consent_language = 'en'
              @vendor_list_version = 0
              @tcf_policy_version = 0
              @is_service_specific = false
              @use_non_standard_stacks = false
              @special_feature_opt_in = Array.new(IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_SIZE, false)
              @purposes_consented = Array.new(IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_SIZE, false)
              @purposes_li_transparency = Array.new(IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_SIZE, false)
              @publisher_restrictions = PublisherRestrictionSection.new
            end

            #
            # set Special Feature Opt in value 
            #
            # @param [Integer] id Special feature id
            # @param [Boolean] val OptIn value
            #
            # @return [Boolean] value set
            #
            def set_special_feature_opt_in(id, val)
              if id < 1 || id > IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_SIZE
                raise "Invalid id number", caller
              end
              @special_feature_opt_in[id - 1] = val
            end

            #
            # set Purpose Consented value
            #
            # @param [Integer] id Purpose Id
            # @param [Boolean] val Consentement value
            #
            # @return [Boolean] value set
            #
            def set_purposes_consented(id, val)
              if id < 1 || id > IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_SIZE
                raise "Invalid id number", caller
              end
              @purposes_consented[id - 1] = val
            end

            #
            # set Purpose Legitimate Interest transparency value
            #
            # @param [Integer] id Purpose Id
            # @param [Boolan] val Legitimate interest value
            #
            # @return [Boolean] value set
            #
            def set_purposes_li_transparency(id, val)
              if id < 1 || id > IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_SIZE
                raise "Invalid id number", caller
              end
              @purposes_li_transparency[id - 1] = val
            end

            #
            # init Vendor consent according to range value
            #
            # @param [boolean] ranged is a ranged?
            #
            # @return [VendorConsent] proper Vendor consent instance
            #
            def init_vendor_consent(ranged:)
              @vendor_consent = VendorConsentBuilder.new.build(is_ranged_encoding: ranged)
              @vendor_consent
            end
            
            #
            # init Vendor legitimate interest according to range value
            #
            # @param [boolean] ranged is a ranged?
            #
            # @return [VendorConsent] proper Vendor legitimate interest instance
            #
            def init_vendor_legitimate_interest(ranged:)
              @vendor_legitimate_interest = VendorConsentBuilder.new.build(is_ranged_encoding: ranged)
              @vendor_legitimate_interest
            end
          end
        end
      end
    end
  end
end
