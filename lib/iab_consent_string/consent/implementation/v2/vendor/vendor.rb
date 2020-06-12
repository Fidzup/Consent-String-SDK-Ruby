require 'iab_consent_string/bits'
require 'iab_consent_string/gdpr_constants'

module IABConsentString
  module Consent
    module Implementation
      module V2
        class Vendor
          attr_accessor :vendor_id, :is_a_ranged, :end_vendor_id
          def initialize(vendor_id, is_a_ranged = false, end_vendor_id = nil)
            @vendor_id = vendor_id
            @is_a_ranged = is_a_ranged
            @end_vendor_id = end_vendor_id
          end

          def is_consented?(id)
            return true if @vendor_id == id
            if @is_a_ranged
              return true if @vendor_id <= id && @end_vendor_id >= id
            end
            return false
          end

          def inspect
            @is_a_ranged ? "[#{@vendor_id}:#{@end_vendor_id}]" : "[#{@vendor_id}]"
          end
        end
      end
    end
  end
end