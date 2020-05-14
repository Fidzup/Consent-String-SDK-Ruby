require 'set'
require 'date'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/vendor_consent'
require_relative './byte_buffer_backed_core_vendor_consent.rb'
require_relative './byte_buffer_backed_allowed_vendor_consent.rb'
require_relative './byte_buffer_backed_disclosed_vendor_consent.rb'
require_relative './byte_buffer_backed_publisher_purposes_transparency.rb'
require_relative './containers/consent_core.rb'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class VendorConsentBuilder
          def initialize
            # @type [Container::ConsentCore]
            @consent_core = Container::ConsentCore.new
          end

          # With creation date
          # @param consentRecordCreated [DateTime] Epoch deciseconds when record was created
          # @return [VendorConsentBuilder] self
          def withConsentRecordCreatedOn(consentRecordCreated)
            @consent_core.consent_record_created = consentRecordCreated
            self
          end

          # With update date
          # @param consentRecordLastUpdated [DateTime] Epoch deciseconds when consent string was last updated
          # @return [VendorConsentBuilder] self
          def withConsentRecordLastUpdatedOn(consentRecordLastUpdated)
            @consent_core.consent_record_last_updated = consentRecordLastUpdated
            self
          end

          # With CMP version
          # @param cmpVersion [Integer] Consent Manager Provider version
          # @return [VendorConsentBuilder] self
          def withCmpVersion(cmpVersion)
            @consent_core.cmp_version = cmpVersion
            self
          end

          # With CMP Id
          # @param cmpId [Integer] Consent Manager Provider Id
          # @return [VendorConsentBuilder] self
          def withCmpId(cmpId)
            @consent_core.cmp_id = cmpId
            self
          end

          # With Consent Screen Id
          # @param consentScreenId [Integer] Consent Screen Id
          # @return [VendorConsentBuilder] self
          def withConsentScreenId(consentScreenId)
            @consent_core.consent_screen = consentScreenId
            self
          end

          # With consent language
          # @param consentLanguage [Char(2)] Two-letter ISO639-1 language code that CMP asked for consent in
          # @return [VendorConsentBuilder] self
          def withConsentLanguage(consentLanguage)
            @consent_core.consent_language = consentLanguage
            self
          end

          # With TCF policy
          # @param [Integer] tcfPolicyVersion  	Version of policy used 
          # @return [VendorConsentBuilder] self
          def withTcfPolicyVersion(tcfPolicyVersion)
            @consent_core.tcf_policy_version = TcfPolicyVersion
            self
          end

          # Whether the signals encoded in this TC String were from 
          # service-specific storage (true) versus ‘global’ consensu.org 
          # shared storage (false). 
          # @param [Boolean] isServiceSpecific true|false
          # @return [VendorConsentBuilder] self
          def withIsServiceSpecific(isServiceSpecific)
            @consent_core.is_service_specific = isServiceSpecific
            self
          end

          # Setting this to true means that a publisher-run CMP, 
          # that is still IAB Europe registered, is using customized 
          # Stack descriptions and not the standard stack descriptions 
          # defined in the Policies (Appendix A section E). A CMP that 
          # services multiple publishers sets this value to false. 
          # @param [useNonStandardStacks] useNonStandardStacks true : CMP used non-IAB standard stacks during consent gathering, false : IAB standard stacks were used 
          # @return [VendorConsentBuilder] self
          def withUseNonStandardStacks(useNonStandardStacks)
            @consent_core.use_non_standard_stacks = useNonStandardStacks
            self
          end

          #
          # The TCF Policies designates certain Features as “special” which means a CMP 
          # must afford the user a means to opt in to their use. These “Special Features”
          # are published and numerically identified in the Global Vendor List separately
          #  from normal Features. 
          #
          # @param [Integer ] id Special Feature id
          # @param [Boolean] val Optin Boolean value
          # @return [VendorConsentBuilder] self
          def withSpecialFeatureOptIns(id, val)
            @consent_core.set_special_feature_opt_in(id, val)
            self
          end

          #
          # The user’s consent value for each Purpose established on the legal basis of consent.
          # The Purposes are numerically identified and published in the Global Vendor List. 
          # From left to right, Purpose 1 maps to the 0th bit, purpose 24 maps to the bit at 
          # index 23. Special Purposes are a different ID space and not included in this field. 
          #
          # @param [Integer] id purpose id
          # @param [Boolean] val Consent Boolean value
          # @return [VendorConsentBuilder] self
          #
          def withPurposeConsent(id, val)
            @consent_core.set_special_feature_opt_in(id, val)
            self
          end

          #
          # The Purpose’s transparency requirements are met for each Purpose on the legal 
          # basis of legitimate interest and the user has not exercised their 
          # “Right to Object” to that Purpose.
          # By default or if the user has exercised their “Right to Object” to a Purpose, 
          # the corresponding bit for that Purpose is set to 0. From left to right, 
          # Purpose 1 maps to the 0th bit, purpose 24 maps to the bit at index 23. 
          # Special Purposes are a different ID space and not included in this field. 
          #
          # @param [Integer] id Purpose id
          # @param [Boolean] val true :  legitimate interest established. false : legitimate interest was NOT established or it was established but user exercised their “Right to Object” to the Purpose 
          #
          # @return [<Type>] <description>
          #
          def withPurposesLITransparency(id, val)
            @consent_core.set_purposes_li_transparency(id, val)
            self
          end

          def build
            bitBufferSizeInBits = IABConsentString::GDPRConstantsV2::Core::VENDOR_START_SECTION_OFFSET
          end
          

        end
      end
    end
  end
end
