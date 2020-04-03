require 'iab_consent_string/error/vendor_consent_create_error'
require 'iab_consent_string/error/vendor_consent_parse_error'

# @author Fidzup Coding Stars Team
module IABConsentString
  class Bits
    # big endian
    BYTE_POWS = [ -128, 64, 32, 16, 8, 4, 2, 1 ]

    def initialize(b)
      @bytes = b
    end

    # Get the value of the specified index bit, under a boolean format (1 = true, 0 = false)
    # @param index [Integer] the nth number bit to get from the bit string
    # @return [Boolean], true if the bit is switched to 1, false otherwise
    def getBit(index)
      byteIndex = index / 8
      bitExact = index % 8
      b = @bytes[byteIndex]
      return (b & BYTE_POWS[bitExact]) != 0
    end

    # Set the value of the specified index bit to 1
    # @param index [Integer] set the nth number bit from the bit string
    def setBit(index)
      byteIndex = index / 8
      shift = (byteIndex + 1) * 8 - index - 1
      @bytes[byteIndex] |= 1 << shift
    end

    # Set the value of the specified index bit to 1
    # @param index [Integer] set the nth number bit from the bit string
    def unsetBit(index)
      byteIndex = index / 8
      shift = (byteIndex + 1) * 8 - index - 1
      @bytes[byteIndex] &= ~(1 << shift)
    end

    # Interprets n number of bits as a big endiant int
    # @param startInclusive [Integer] the nth to begin interpreting from
    # @param size [Integer] the number of bits to interpret
    # @return [void]
    # @raise [VendorConsentParseError] when the bits cannot fit in an int sized field
    def getInt(startInclusive, size)
      # Integer Size limited to 32 bits
      if (size > 32)
        raise IABConsentString::Error::VendorConsentParseError, "can't fit bit range in int " + size, caller
      end
      val = 0
      sigMask = 1
      sigIndex = size - 1

      for i in (0...size) do
        if getBit(startInclusive + i)
          val += (sigMask << sigIndex)
        end 
        sigIndex -= 1
      end
      val
    end

    # Writes an integer value into a bit array of given size
    # @param startInclusive [Integer] the nth to begin writing to
    # @param size [Integer] the number of bits available to write
    # @param to [Integer] the integer to write out
    # @return [void]
    # @raise [VendorConsentCreateError] when the bits cannot fit into the provided size
    def setInt(startInclusive, size, to)
      # Integer Size limited to 32 bits
      if (size > 32 || to > maxOfSize(size) || to < 0)
        raise IABConsentString::Error::VendorConsentCreateError, "can't fit integer into bit range of size" + size , caller
      end

      setNumber(startInclusive, size, to);
    end

    # Interprets n bits as a big endian long
    # @param startInclusive [Integer] the nth to begin interpreting from
    # @param size [Integer] the number of bits to interpret
    # @return [Long] the long value create by interpretation of provided bits
    # @raise [VendorConsentParseError] when the bits cannot fit in a long sized field
    def getLong(startInclusive, size)
      # Long Size limited to 64 bits
      if (size > 64)
        raise IABConsentString::Error::VendorConsentParseError, "can't fit bit range in long: " + size , caller
      end
      val = 0
      sigMask = 1
      sigIndex = size - 1

      for i in (0...size) do
        if (getBit(startInclusive + i))
          val += (sigMask << sigIndex)
        end
        sigIndex -= 1
      end
      val
    end

    # Writes a long value into a bit array of given size
    # @param startInclusive [Integer] the nth to begin writing to
    # @param size [Integer] the number of bits available to write
    # @param to [Integer] the long number to write out
    # @return [void]
    # @raise [VendorConsentCreateError] when the bits cannot fit into the provided size
    def setLong(startInclusive, size, to)
      # Long Size limited to 64 bits
      if (size > 64 || to > maxOfSize(size) || to < 0)
        raise IABConsentString::Error::VendorConsentCreateError, "can't fit long into bit range of size " + size , caller
      end

      setNumber(startInclusive, size, to)
    end

    # returns a time derived from interpreting the given interval on the bit string as long representing
    #   the number of demiseconds from the unix epoch
    # @param startInclusive [Integer] the bit from which to begin interpreting
    # @param size [Integer] the number of bits to interpret
    # @return [void]
    # @raise [VendorConsentParseError] when the number of bits requested cannot fit in a long
    def getDateTimeFromEpochDeciseconds(startInclusive,size)
      epochDemi = getLong(startInclusive, size)
      epochDemi * 100
    end

    def setDateTimeToEpochDeciseconds(startInclusive, size, dateTime)
      setLong(startInclusive, size, dateTime / 100)
    end

    # @return [Integer] the number of bits in the bit string
    def length
      @bytes.length * 8
    end

    # Interprets the given interval in the bit string as a series of six bit characters, where 0=A and 26=Z
    # @param startInclusive [Integer]  the nth bit in the bitstring from which to start the interpretation
    # @param size [Integer]  the number of bits to include in the string
    # @return [String] the string given by the above interpretation
    # @raise [VendorConsentParseError] when the requested interval is not a multiple of six
    def getSixBitString(startInclusive, size)
      if (size % 6 != 0)
        raise IABConsentString::Error::VendorConsentParseError , "string bit length must be multiple of six: " + size, caller
      end
      charNum = size / 6
      val = String.new()
      for i in (0...charNum) do
        charCode = getInt(startInclusive + (i * 6), 6) + 65
        val << charCode.chr
      end
      val.upcase
    end

    # Interprets characters, as 0=A and 26=Z and writes to the given interval in the bit string as a series of six bits
    # @param startInclusive [Integer] the nth bit in the bitstring from which to start writing
    # @param size [Integer] the size of the bitstring
    # @param to [Integer] the string given by the above interpretation
    # @raise [VendorConsentCreateError] when the requested interval is not a multiple of six
    def setSixBitString(startInclusive, size, to)
      if (size % 6 != 0 || size / 6 != to.length())
        raise IABConsentString::Error::VendorConsentCreateError , "bit array size must be multiple of six and equal to 6 times the size of string", caller
      end
      values = to.chars
      for i in (0...values.length) do
        charCode = values[i].ord - 65
        setInt(startInclusive + (i * 6), 6, charCode)
      end
    end 

    # @return [String] a string representation of the byte array passed in the constructor. for example, a bit array of [4]
    #   yields a String of "0100"
    def getBinaryString
      s = String.new()
      size = length()
      for i in (0...size) do
        if (getBit(i))
          s << "1"
        else
          s << "0"
        end
      end
      s
    end

    def toByteArray
      @bytes
    end

    def setNumber(startInclusive,size,to)
      (size - 1).downto(0) do |i|
        index = startInclusive + i
        byteIndex = index / 8
        shift = (byteIndex + 1) * 8 - index - 1
        @bytes[byteIndex] |= (to % 2) << shift
        to /= 2
      end
    end

    def maxOfSize(size)
      max = 0
      for i in (0...size) do
        max += 2**i
      end
      max
    end
  end
end
