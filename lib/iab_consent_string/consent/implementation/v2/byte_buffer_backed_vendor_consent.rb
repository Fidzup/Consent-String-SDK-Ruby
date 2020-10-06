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
            @end_vendor_consent = nil
            @bits_disclosed_vendors  = nil
            @bits_allowed_vendors  = nil
            @bits_publisher_purpose  = nil
            @end_vendor_legitimate_interest = nil
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

          def toByteArrayList
            l = [@bits_core.toByteArray]
            l << @bits_disclosed_vendors.toByteArray if @bits_disclosed_vendors
            l << @bits_allowed_vendors.toByteArray if @bits_allowed_vendors
            l << @bits_publisher_purpose.toByteArray if @bits_publisher_purpose
            l
          end

          def getSegmentType(bits)
            bits.getInt(IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_OFFSET,IABConsentString::GDPRConstantsV2::Segment::SEGMENT_TYPE_SIZE)
          end

          def inspect
            core_str = <<~STR
              #{super.inspect}
              \tVersion: #{self.getVersion}
              \tConsentRecordCreated:  #{self.getConsentRecordCreated}
              \tConsentRecordLastUpdated:  #{self.getConsentRecordLastUpdated}
              \tCmpId:  #{self.getCmpId}
              \tCmpVersion:  #{self.getCmpVersion}
              \tConsentScreen:  #{self.getConsentScreen}
              \tConsentLanguage:  #{self.getConsentLanguage}
              \tVendorListVersion:  #{self.getVendorListVersion}
              \tTcfPolicyVersion:  #{self.getTcfPolicyVersion}
              \tIsServiceSpecific:  #{self.getIsServiceSpecific}
              \tUseNonNtandardStacks:  #{self.getUseNonStandardStacks}
              \tSpecialFeatureOptIn:
              #{insepectListAttr("isSpecialFeatureOptIn", IABConsentString::GDPRConstantsV2::Core::SPECIAL_FEATURE_OPT_INS_SIZE)}
              \tPurposesConsentedSpecialFeatureOptIn:
              #{insepectListAttr("isPurposesConsented", IABConsentString::GDPRConstantsV2::Core::PURPOSES_CONSENT_SIZE)}
              \tPurposesLITransparency
              #{insepectListAttr("isPurposeLITransparency", IABConsentString::GDPRConstantsV2::Core::PURPOSES_LI_TRANSPARENCY_SIZE)}
              \tPurposeOneTreatment:  #{self.getPurposeOneTreatment}
              \tPublisherCC:  #{self.getPublisherCC}
              \tVendorConsent:  #{self.getVendorConsent.inspect}
              \tVendorLegitimateInterest:  #{self.getVendorLegitimateInterest.inspect}
              \tPublisherRestrictions:  #{self.getPublisherRestrictions.inspect}
            STR

            disclose_str = ""
            if @bits_disclosed_vendors
              disclose_str << "#Disclose Vendor Segment\n\n"
              disclose_str << "\tDisclosedVendor:  #{self.getDisclosedVendor.inspect}\n"
            end

            allowed_str = ""
            if @bits_allowed_vendors
              allowed_str << "#Allowed Vendor Segment\n\n"
              allowed_str << "\tAllowedVendor:  #{self.getAllowedVendor.inspect}\n"
            end

            pp_str = ""
            if @bits_publisher_purpose
              pp_str << "#PublisherTC Segment\n\n"
              pp_str << "\tPubPurposeConsent:\n"
              pp_str << "#{insepectListAttr("getPubPurposeConsent", 24)}"
              pp_str << "\tPubPurposeLITransparency:\n"
              pp_str << "#{insepectListAttr("getPubPurposeLITransparency", 24)}"
              pp_str << "\tCustomPurposeConsent:\n"
              pp_str << "\tNum: #{self.getNumCustomPurposes}\n"
              pp_str << "\tCustomPurposeConsent:\n"
              pp_str << "#{insepectListAttr("getCustomPurposeConsent", self.getNumCustomPurposes)}"
              pp_str << "\tCustomPurposeLITransparency:\n"
              pp_str << "#{insepectListAttr("getCustomPurposeLITransparency", self.getNumCustomPurposes)}"
            end

            <<~STR
              #{core_str}
              #{disclose_str}
              #{allowed_str}
              #{pp_str}
            STR
          end

          private
          def insepectListAttr(method, max)
            vals = (1..max).map{ |id| send(method, id) }
            header= vals.each_with_index.map{ |v,i| sprintf("%2d", i+1) }.join("|")
            separator = Array.new(vals.count, '--').join('+')
            val_str = vals.map{ |v| (v ? " x" : "  " )}.join("|")
            res = <<~STR
              #{header}
              #{separator}
              #{val_str}
            STR
            res
          end
        end
      end
    end
  end
end
