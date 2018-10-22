require 'iab_consent_string/gdpr_constants'
require 'iab_consent_string/error/vendor_consent_create_error'

module IABConsentString
  module Consent
    module Implementation
      module V1
        #  Builder for version 1 of vendor consent
        class VendorConsentBuilder
          VERSION = 1

          # With creation date
          # @param consentRecordCreated [DateTime] Epoch deciseconds when record was created
          # @return [VendorConsentBuilder] self
          def withConsentRecordCreatedOn(consentRecordCreated)
            @consentRecordCreated = consentRecordCreated
            self
          end

          # With update date
          # @param consentRecordLastUpdated [DateTime] Epoch deciseconds when consent string was last updated
          # @return [VendorConsentBuilder] self
          def withConsentRecordLastUpdatedOn(consentRecordLastUpdated)
            @consentRecordLastUpdated = consentRecordLastUpdated;
            self
          end

          # With CMP version
          # @param cmpVersion [Integer] Consent Manager Provider version
          # @return [VendorConsentBuilder] self
          def withCmpVersion(cmpVersion)
            @cmpVersion = cmpVersion
            self
          end

          # With consent language
          # @param consentLanguage [Char(2)] Two-letter ISO639-1 language code that CMP asked for consent in
          # @return [VendorConsentBuilder] self
          def withConsentLanguage(consentLanguage)
            @consentLanguage = consentLanguage
            self
          end

          # With vendor list version
          # @param vendorListVersion [Integer] Version of vendor list used in most recent consent string update
          # @return [VendorConsentBuilder] self
          def withVendorListVersion(vendorListVersion)
            @vendorListVersion = vendorListVersion
            self
          end

          # With allowed purpose IDs
          # @param allowedPurposeIds [Set<Integer>] set of allowed purposes
          # @return [VendorConsentBuilder] self
          def withAllowedPurposeIds(allowedPurposeIds)
            if allowedPurposeIds.nil?
              raise "Argument allowedPurposeIds is null"
            end
            allowedPurposeIds.each do |purposeId|
              if purposeId < 0 || purposeId > IABConsentString::GDPRConstants::PURPOSES_SIZE
                raise "Invalid purpose ID found"
              end
            end
            @allowedPurposes = allowedPurposeIds;
            self
          end

          # With allowed purposes
          # @param allowedPurposes [Set<Purpose>] set of allowed purposes
          # @return [VendorConsentBuilder] self
          def withAllowedPurposes(allowedPurposes)
            if allowedPurposes.nil?
              raise "Argument allowedPurposes is null"
            end
            @allowedPurposes = allowedPurposes.map! {|purpose| purpose.getId }
            self
          end

          # With max vendor ID
          # @param maxVendorId [Integer] The maximum VendorId for which consent values are given.
          # @return [VendorConsentBuilder] self
          def withMaxVendorId(maxVendorId)
            this.maxVendorId = maxVendorId
            self
          end

          # With vendor encoding type
          # @param vendorEncodingType [Integer] 0=BitField 1=Range
          # @return [VendorConsentBuilder] self
          def withVendorEncodingType(vendorEncodingType)
            if (vendorEncodingType < 0 || vendorEncodingType > 1)
              raise "Illegal value for argument vendorEncodingType:" + vendorEncodingType.to_s
            end
            @vendorEncodingType = vendorEncodingType
            self
          end

          # With bit field entries
          # @param bitFieldEntries [Set<Integer>] set of VendorIds for which the vendors have consent
          # @return [VendorConsentBuilder] self
          def withBitField(bitFieldEntries)
            @vendorsBitField = bitFieldEntries
            self
          end

          # With range entries
          # @param rangeEntries [Set<RangeEntry>] List of VendorIds or a range of VendorIds for which the vendors have consent
          # @return [VendorConsentBuilder] self
          def withRangeEntries(rangeEntries)
            @rangeEntries = rangeEntries
            self
          end

          # With default consent
          # @param defaultConsent [Boolean] Default consent for VendorIds not covered by a RangeEntry. 0=No Consent 1=Consent
          # @return [VendorConsentBuilder] self
          def withDefaultConsent(defaultConsent)
            @defaultConsent = defaultConsent
            self
          end

          # Validate supplied values and build VendorConsent object
          # @return [IABConsentString::Consent::VendorConsent] vendor consent object
          def build
            if @consentRecordCreated.nil?
              raise IABConsentString::Error::VendorConsentCreateError, "consentRecordCreated must be set", caller
            end
            if @consentRecordLastUpdated.nil?
              raise IABConsentString::Error::VendorConsentCreateError, "consentRecordLastUpdated must be set", caller
            end
            if @consentLanguage.nil?
              raise IABConsentString::Error::VendorConsentCreateError, "consentLanguage must be set", caller
            end

            if @vendorListVersion.nil? || @vendorListVersion <=0
              raise IABConsentString::Error::VendorConsentCreateError, "Invalid value for vendorListVersion:" + @vendorListVersion.to_s, caller
            end

            if @maxVendorId.nil? || @maxVendorId<=0
              raise IABConsentString::Error::VendorConsentCreateError, "Invalid value for maxVendorId:" + @maxVendorId.to_s, caller
            end

            # For range encoding, check if each range entry is valid
            if @vendorEncodingType == IABConsentString::GDPRConstants::VENDOR_ENCODING_RANGE
              if @rangeEntries.nil?
                raise IABConsentString::Error::VendorConsentCreateError, "Range entries  must be set", caller
              end
              @rangeEntries.each do |rangeEntry|
                if !rangeEntry.valid(@maxVendorId)
                  raise IABConsentString::Error::VendorConsentCreateError, "Invalid range entries found", caller
                end
              end
            end

            # Calculate size of bit buffer in bits
            bitBufferSizeInBits = 0
            if (@vendorEncodingType == IABConsentString::GDPRConstants::VENDOR_ENCODING_RANGE)
              rangeEntrySectionSize = 0
              @rangeEntries.each do |rangeEntry|
                rangeEntrySectionSize += rangeEntry.size
              end
              bitBufferSizeInBits = IABConsentString::GDPRConstants::RANGE_ENTRY_OFFSET + rangeEntrySectionSize.to_s
            else
              bitBufferSizeInBits = IABConsentString::GDPRConstants::VENDOR_BITFIELD_OFFSET + @maxVendorId.to_s
            end

            # Create new bit buffer
            bitsFit = (bitBufferSizeInBits % 8) == 0
            bits = Bits.new(Array.new(bitBufferSizeInBits / 8 + (bitsFit ? 0 : 1)))

            # Set fields in bit buffer
            bits.setInt(IABConsentString::GDPRConstants::VERSION_BIT_OFFSET, IABConsentString::GDPRConstants::VERSION_BIT_SIZE, VERSION)
            bits.setDateTimeToEpochDeciseconds(IABConsentString::GDPRConstants::CREATED_BIT_OFFSET, IABConsentString::GDPRConstants::CREATED_BIT_SIZE, @consentRecordCreated)
            bits.setDateTimeToEpochDeciseconds(IABConsentString::GDPRConstants::UPDATED_BIT_OFFSET, IABConsentString::GDPRConstants::UPDATED_BIT_SIZE, @consentRecordLastUpdated)
            bits.setInt(IABConsentString::GDPRConstants::CMP_ID_OFFSET, IABConsentString::GDPRConstants::CMP_ID_SIZE, @cmpID)
            bits.setInt(IABConsentString::GDPRConstants::CMP_VERSION_OFFSET, IABConsentString::GDPRConstants::CMP_VERSION_SIZE, @cmpVersion)
            bits.setInt(IABConsentString::GDPRConstants::CONSENT_SCREEN_SIZE_OFFSET, IABConsentString::GDPRConstants::CONSENT_SCREEN_SIZE, @consentScreenID)
            bits.setSixBitString(IABConsentString::GDPRConstants::CONSENT_LANGUAGE_OFFSET, IABConsentString::GDPRConstants::CONSENT_LANGUAGE_SIZE, @consentLanguage)
            bits.setInt(IABConsentString::GDPRConstants::VENDOR_LIST_VERSION_OFFSET, IABConsentString::GDPRConstants::VENDOR_LIST_VERSION_SIZE, @vendorListVersion)

            # Set purposes bits
            for i in (0...IABConsentString::GDPRConstants::PURPOSES_SIZE) do
              if (@allowedPurposes.include?(i+1))
                bits.setBit(IABConsentString::GDPRConstants::PURPOSES_OFFSET + i)
              else
                bits.unsetBit(IABConsentString::GDPRConstants::PURPOSES_OFFSET + i)
              end
            end

            bits.setInt(IABConsentString::GDPRConstants::MAX_VENDOR_ID_OFFSET, IABConsentString::GDPRConstants::MAX_VENDOR_ID_SIZE, @maxVendorId)
            bits.setInt(IABConsentString::GDPRConstants::ENCODING_TYPE_OFFSET, IABConsentString::GDPRConstants::ENCODING_TYPE_SIZE, @vendorEncodingType)

            # Set the bit field or range sections
            if (@vendorEncodingType == IABConsentString::GDPRConstants::VENDOR_ENCODING_RANGE)
              # Range encoding
              if (@defaultConsent)
                bits.setBits(IABConsentString::GDPRConstants::DEFAULT_CONSENT_OFFSET)
              else
                bits.unsetBits(IABConsentString::GDPRConstants::DEFAULT_CONSENT_OFFSET)
              end
              bits.setInt(IABConsentString::GDPRConstants::NUM_ENTRIES_OFFSET, IABConsentString::GDPRConstants::NUM_ENTRIES_SIZE, @rangeEntries.size)

              currentOffset = IABConsentString::GDPRConstants::RANGE_ENTRY_OFFSET

              @rangeEntries.each do |rangeEntry|
                currentOffset = rangeEntry.appendTo(bits, currentOffset)
              end
            else
              # Bit field encoding
              for i in (0...@maxVendorId) do
                if @vendorsBitField.include?(i+1)
                  bits.setBit(IABConsentString::GDPRConstants::VENDOR_BITFIELD_OFFSET+i)
                else
                  bits.unsetBit(IABConsentString::GDPRConstants::VENDOR_BITFIELD_OFFSET+i)
                end
              end
            end

            ByteBufferBackedVendorConsent.new(bits)
          end
        end
      end
    end
  end
end
