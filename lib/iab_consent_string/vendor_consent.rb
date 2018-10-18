require 'iab_consent_string/bits'

module IABConsentString
  class VendorConsent
    class Builder
        # @param version [Integer] Version of the Consent String Format
        def withVersion(version)
            @version = version
            self
        end

        # @param consentRecordCreated [Timestamp] Epoch deciseconds when consent string was first created
        def withConsentRecordCreatedOn(consentRecordCreated)
            @consentRecordCreated = consentRecordCreated;
            self
        end

        # @param consentRecordLastUpdated [Timestamp] Epoch deciseconds when consent string was last updated
        def withConsentRecordLastUpdatedOn(consentRecordLastUpdated)
            @consentRecordLastUpdated = consentRecordLastUpdated;
            self
        end

        # @param cmpID [Integer] Consent Manager Provider ID that last updated the consent string
        def withCmpID(cmpID)
            @cmpID = cmpID
            self
        end

        # @param cmpVersion [Integer] Consent Manager Provider version
        def withCmpVersion(cmpVersion)
            @cmpVersion = cmpVersion
            self
        end

        # @param consentScreenID [Integer] Screen number in the CMP where consent was given
        def withConsentScreenID(consentScreenID)
            @consentScreenID = consentScreenID
            self
        end

        # @param consentLanguage [Char(2)] Two-letter ISO639-1 language code that CMP asked for consent in. Each letter should be encoded as
        #   6 bits, A=0..Z=25 . This will result in the base64url-encoded bytes spelling out the language code
        #   (in uppercase).
        def withConsentLanguage(consentLanguage)
            @consentLanguage = consentLanguage
            self
        end

        # @param vendorListVersion [Integer] Version of vendor list used in most recent consent string update
        def withVendorListVersion(vendorListVersion)
            @vendorListVersion = vendorListVersion
            self
        end

        # @param allowedPurposes [Hash<Integer, Boolean>] For each Purpose, one bit: 0=No Consent 1=Consent Purposes are listed in the global Vendor List.
        #   Resultant consent value is the ?AND? of the applicable bit(s) from this field and a vendor?s
        #   specific consent bit. Purpose #1 maps to the first (most significant) bit, purpose #24 maps to the
        #   last (least significant) bit.
        def withAllowedPurposes(allowedPurposes)
            @integerPurposes = allowedPurposes
            for i in (0...IABConsentString::GDPRConstants::PURPOSES_SIZE)
                @allowedPurposes.add(false)
            end
            allowedPurposes.each do |purpose|
                @allowedPurposes.set(purpose - 1, true)
            end
            self
        end

        # @param maxVendorId [Integer] The maximum VendorId for which consent values are given.
        def withMaxVendorId(maxVendorId)
            this.maxVendorId = maxVendorId
            self
        end

        # @param vendorEncodingType [Integer] 0=BitField 1=Range
        def withVendorEncodingType(vendorEncodingType)
            @vendorEncodingType = vendorEncodingType
            self
        end

        # @param bitFieldEntries [Hash<Integer, Boolean>] List of VendorIds for which the vendors have consent
        def withBitField(bitFieldEntries)
            @vendorsBitField = bitFieldEntries
            self
        end

        # @param rangeEntries [Hash<Integer>] List of VendorIds or a range of VendorIds for which the vendors have consent
        def withRangeEntries(rangeEntries)
            @rangeEntries = rangeEntries
            self
        end

        # @param defaultConsent [Integer] Default consent for VendorIds not covered by a RangeEntry. 0=No Consent 1=Consent
        def withDefaultConsent(defaultConsent)
            @defaultConsent = defaultConsent
            self
        end

        def build()
            return VendorConsent.new(self)
        end
    end

    def initialize(builder)
      @version = builder.version
      @consentRecordCreated = builder.consentRecordCreated
      @consentRecordLastUpdateed = builder.consentRecordLastUpdated
      @cmpID = builder.cmpID
      @cmpVersion = builder.cmpVersion
      @consentScreenID = builder.consentScreenID
      @consentLanguage = builder.consentLanguage
      @vendorListVersion = builder.vendorListVersion
      @maxVendorId = builder.maxVendorId
      @vendorEncodingType = builder.vendorEncodingType
      @allowedPurposes = builder.allowedPurposes

      if (@vendorEncodingType == IABConsentString::GDPRConstants::VENDOR_ENCODING_RANGE)
        @defaultConsent = builder.defaultConsent
        builder.rangeEntries.each do |rangeEntry|
          if rangeEntry.endVendorId > maxVendorId
          raise IABConsentString::Error::VendorConsentCreateError , "VendorId in range entry is greater than Max VendorId", caller
          end
        end
        @rangeEntries = builder.rangeEntries
      else
        @bitfield = Array.new(@maxVendorId)
        (0...@maxVendorId).each do |vendorId|
          @bitfield.add(false)
        end
        builder.vendorsBitField.each do |vendorId|
          if (vendorId > @maxVendorId || vendorId < 1)
            raise IABConsentString::Error::VendorConsentCreateError , "VendorId in bit field is greater than Max VendorId or less than 1", caller
          end
          @bitfield.set(vendorId - 1, true);
        end
      end

      @integerPurposes = builder.integerPurposes

      if (@vendorEncodingType == IABConsentString::GDPRConstants::VENDOR_ENCODING_RANGE)
        rangeEntrySize = @rangeEntries.size(); # one bit SingleOrRange flag per entry
        @rangeEntries.each do |entry|
          if (entry.endVendorId == entry.startVendorId)
            rangeEntrySize += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
          else
            rangeEntrySize += IABConsentString::GDPRConstants::VENDOR_ID_SIZE * 2
          end
        end 
        bitSize = IABConsentString::GDPRConstants::RANGE_ENTRY_OFFSET + rangeEntrySize
        bitsFit = (bitSize % 8) == 0
        @bits = new Bits(new byte[bitSize / 8 + (bitsFit ? 0 : 1)])
      else
        bitSize = IABConsentString::GDPRConstants::VENDOR_BITFIELD_OFFSET + @maxVendorId
        bitsFit = (bitSize % 8) == 0
        @bits = new Bits(new byte[(bitSize / 8 + (bitsFit ? 0 : 1))])
      end

      @bits.setInt(IABConsentString::IABConsentString::GDPRConstants::VERSION_BIT_OFFSET, IABConsentString::GDPRConstants::VERSION_BIT_SIZE, @version)
      @bits.setInstantToEpochDeciseconds(IABConsentString::GDPRConstants::CREATED_BIT_OFFSET, IABConsentString::GDPRConstants::CREATED_BIT_SIZE, @consentRecordCreated)
      @bits.setInstantToEpochDeciseconds(IABConsentString::GDPRConstants::UPDATED_BIT_OFFSET, IABConsentString::GDPRConstants::UPDATED_BIT_SIZE, @consentRecordLastUpdated)

      @bits.setInt(IABConsentString::GDPRConstants::CMP_ID_OFFSET, IABConsentString::GDPRConstants::CMP_ID_SIZE, @cmpID)
      @bits.setInt(IABConsentString::GDPRConstants::CMP_VERSION_OFFSET, IABConsentString::GDPRConstants::CMP_VERSION_SIZE, @cmpVersion)
      @bits.setInt(IABConsentString::GDPRConstants::CONSENT_SCREEN_SIZE_OFFSET, IABConsentString::GDPRConstants::CONSENT_SCREEN_SIZE, @consentScreenID)
      @bits.setSixBitString(IABConsentString::GDPRConstants::CONSENT_LANGUAGE_OFFSET, IABConsentString::GDPRConstants::CONSENT_LANGUAGE_SIZE, @consentLanguage)

      @bits.setInt(IABConsentString::GDPRConstants::VENDOR_LIST_VERSION_OFFSET, IABConsentString::GDPRConstants::VENDOR_LIST_VERSION_SIZE, @vendorListVersion)

      i = 0
      @allowedPurposes.each do |purpose|
        if (purpose)
          @bits.setBit(IABConsentString::GDPRConstants::PURPOSES_OFFSET + i)
          i += 1
        else
          @bits.unsetBit(IABConsentString::GDPRConstants::PURPOSES_OFFSET + i)
          i += 1
        end
      end

      @bits.setInt(IABConsentString::GDPRConstants::MAX_VENDOR_ID_OFFSET, IABConsentString::GDPRConstants::MAX_VENDOR_ID_SIZE, @maxVendorId)
      @bits.setInt(IABConsentString::GDPRConstants::ENCODING_TYPE_OFFSET, IABConsentString::GDPRConstants::ENCODING_TYPE_SIZE, @vendorEncodingType)

      if (@vendorEncodingType == IABConsentString::GDPRConstants::VENDOR_ENCODING_RANGE)
        if (defaultConsent)
          @bits.setBit(IABConsentString::GDPRConstants::DEFAULT_CONSENT_OFFSET)
        else
          @bits.unsetBit(IABConsentString::GDPRConstants::DEFAULT_CONSENT_OFFSET)
        end
        @bits.setInt(IABConsentString::GDPRConstants::NUM_ENTRIES_OFFSET, IABConsentString::GdprConstants::NUM_ENTRIES_SIZE, @rangeEntries.size())

        currentOffset = IABConsentString::GDPRConstants::RANGE_ENTRY_OFFSET

        @rangeEntries.each do |entry|
          if (entry.endVendorId > entry.startVendorId) # range
            @bits.setBit(currentOffset)
            currentOffset += 1
            @bits.setInt(currentOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE, entry.startVendorId)
            currentOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
            @bits.setInt(currentOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE, entry.endVendorId)
            currentOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
          else
            @bits.unsetBit(currentOffset)
            currentOffset += 1
            @bits.setInt(currentOffset, IABConsentString::GDPRConstants::VENDOR_ID_SIZE, entry.startVendorId)
            currentOffset += IABConsentString::GDPRConstants::VENDOR_ID_SIZE
          end
        end
      else
        bitfieldOffset = IABConsentString::GDPRConstants::VENDOR_BITFIELD_OFFSET
        @bitfield.each do |vendorBit|
          if (vendorBit)
            @bit.setBit(bitfieldOffset)
          end
          bitfieldOffset += 1
        end
      end
      @consentString = encoder.encodeToString(bits.toByteArray())
    end
  end
end
