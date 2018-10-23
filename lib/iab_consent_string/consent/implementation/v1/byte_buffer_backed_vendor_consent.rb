require 'set'
require 'date'
require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/consent/vendor_consent'

module IABConsentString
  module Consent
    module Implementation
      module V1
        class ByteBufferBackedVendorConsent < IABConsentString::Consent::VendorConsent
          def initialize(bits)
            @bits = bits
          end

          def getVersion
            @bits.getInt(IABConsentString::GDPRConstants::VERSION_BIT_OFFSET,IABConsentString::GDPRConstants::VERSION_BIT_SIZE)
          end

          def getConsentRecordCreated
            @bits.getDateTimeFromEpochDeciseconds(IABConsentString::GDPRConstants::CREATED_BIT_OFFSET, IABConsentString::GDPRConstants::CREATED_BIT_SIZE)
          end

          def getConsentRecordLastUpdated
            @bits.getDateTimeFromEpochDeciseconds(IABConsentString::GDPRConstants::UPDATED_BIT_OFFSET,IABConsentString::GDPRConstants::UPDATED_BIT_SIZE)
          end

          def getCmpId
            @bits.getInt(IABConsentString::GDPRConstants::CMP_ID_OFFSET,IABConsentString::GDPRConstants::CMP_ID_SIZE)
          end

          def getCmpVersion
            @bits.getInt(IABConsentString::GDPRConstants::CMP_VERSION_OFFSET,IABConsentString::GDPRConstants::CMP_VERSION_SIZE)
          end

          def getConsentScreen
            @bits.getInt(IABConsentString::GDPRConstants::CONSENT_SCREEN_SIZE_OFFSET,IABConsentString::GDPRConstants::CONSENT_SCREEN_SIZE)
          end

          def getConsentLanguage
            @bits.getSixBitString(IABConsentString::GDPRConstants::CONSENT_LANGUAGE_OFFSET,IABConsentString::GDPRConstants::CONSENT_LANGUAGE_SIZE)
          end

          def getVendorListVersion
            @bits.getInt(IABConsentString::GDPRConstants::VENDOR_LIST_VERSION_OFFSET,IABConsentString::GDPRConstants::VENDOR_LIST_VERSION_SIZE)
          end

          def getAllowedPurposeIds
            allowedPurposes = Set[]
            for i in (IABConsentString::GDPRConstants::PURPOSES_OFFSET...(IABConsentString::GDPRConstants::PURPOSES_OFFSET + IABConsentString::GDPRConstants::PURPOSES_SIZE)) do
              if (@bits.getBit(i))
                allowedPurposes.add(i - IABConsentString::GDPRConstants::PURPOSES_OFFSET + 1)
              end
            end
            allowedPurposes
          end

          def getAllowedPurposes
            allowedPurposes = getAllowedPurposeIds().map! {|id| IABConsentString::Purpose.new(id)}
            allowedPurposes.to_a.uniq{|o| [o.getId]}.to_set
          end

          def getAllowedPurposesBits
            @bits.getInt(IABConsentString::GDPRConstants::PURPOSES_OFFSET,IABConsentString::GDPRConstants::PURPOSES_SIZE)
          end

          def getMaxVendorId
            @bits.getInt(IABConsentString::GDPRConstants::MAX_VENDOR_ID_OFFSET,IABConsentString::GDPRConstants::MAX_VENDOR_ID_SIZE)
          end

          def isPurposeIdAllowed(purposeId)
            if ((purposeId < 1) || (purposeId > IABConsentString::GDPRConstants::PURPOSES_SIZE))
              return false
            end
            @bits.getBit(IABConsentString::GDPRConstants::PURPOSES_OFFSET + purposeId - 1);
          end

          def isPurposeAllowed(purpose)
            isPurposeIdAllowed(purpose.getId())
          end

          def isVendorAllowed(vendorId)
            if ((vendorId < 1) || (vendorId > getMaxVendorId()))
              return false
            end
            if (encodingType() == IABConsentString::GDPRConstants::VENDOR_ENCODING_RANGE)
              defaultConsent = @bits.getBit(IABConsentString::GDPRConstants::DEFAULT_CONSENT_OFFSET)
              present = isVendorPresentInRange(vendorId)
              return (present != defaultConsent)
            else
              return @bits.getBit(IABConsentString::GDPRConstants::VENDOR_BITFIELD_OFFSET + vendorId - 1)
            end
          end

          def toByteArray
            @bits.toByteArray()
          end

          def hashCode
            @bit.toByteArray().toString().hash
          end

          def toString
            "ByteBufferVendorConsent{" +
                "Version=" + getVersion().to_s +
                ",Created=" + getConsentRecordCreated().to_s +
                ",LastUpdated=" + getConsentRecordLastUpdated().to_s +
                ",CmpId=" + getCmpId().to_s +
                ",CmpVersion=" + getCmpVersion().to_s +
                ",ConsentScreen=" + getConsentScreen().to_s +
                ",ConsentLanguage=" + getConsentLanguage() +
                ",VendorListVersion=" + getVendorListVersion().to_s +
                ",PurposesAllowed=" + getAllowedPurposeIds().to_s +
                ",MaxVendorId=" + getMaxVendorId().to_s +
                ",EncodingType=" + encodingType().to_s +
                "}"
          end

          private
          def encodingType
            @bits.getInt(IABConsentString::GDPRConstants::ENCODING_TYPE_OFFSET, IABConsentString::GDPRConstants::ENCODING_TYPE_SIZE)
          end

          def isVendorPresentInRange(vendorId)
            numEntries = @bits.getInt(IABConsentString::GDPRConstants::NUM_ENTRIES_OFFSET, IABConsentString::GDPRConstants::NUM_ENTRIES_SIZE)
            maxVendorId = getMaxVendorId()
            currentOffset = IABConsentString::GDPRConstants::RANGE_ENTRY_OFFSET
            for i in (0...numEntries) do
              range = @bits.getBit(currentOffset)
              currentOffset += 1
              if range
                startVendorId = @bits.getInt(currentOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE)
                currentOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
                endVendorId = @bits.getInt(currentOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE)
                currentOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE

                if ((startVendorId > endVendorId) || (endVendorId > maxVendorId))
                  raise IABConsentString::Error::VendorConsentParseError.new("Start VendorId must not be greater than End VendorId and End VendorId must not be greater than Max Vendor Id")
                end
                if ((vendorId >= startVendorId) && (vendorId <= endVendorId))
                  return true
                end
              else
                singleVendorId = @bits.getInt(currentOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE)
                currentOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE

                if (singleVendorId > maxVendorId)
                  raise IABConsentString::Error::VendorConsentParseError.new("VendorId in the range entries must not be greater than Max VendorId")
                end
                if (singleVendorId == vendorId)
                  return true
                end
              end
            end

            false
          end
        end
      end
    end
  end
end
