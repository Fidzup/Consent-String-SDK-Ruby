require 'iab_consent_string/bits'

module IABConsentString
  module Util
    class Utils
      # Create bit buffer from string representation
      # @param binaryString [String] binary string
      # @return [Bits] bit buffer
      def self.fromBinaryString(binaryString)
        length = binaryString.length
        bitsFit = (length % 8) == 0
        str = ""
        for i in (0...length / 8 + (bitsFit ? 0 : 1)) do
          str << 0b00000000
        end
        bits = IABConsentString::Bits.new(str.bytes.to_a)
        for i in (0...length) do
          if binaryString[i] == '1'
            bits.setBit(i)
          else
            bits.unsetBit(i)
          end
        end
        bits
      end
    end
  end
end
