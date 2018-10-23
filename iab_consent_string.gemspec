Gem::Specification.new do |s|
  s.name        = 'iab_consent_string'
  s.version     = '1.0.0'
  s.licenses    = ['MIT']
  s.summary     = "Encode and decode web-safe base64 consent information with the IAB EU's GDPR Transparency and Consent Framework."
  s.description = "This library is a Ruby reference implementation for dealing with consent strings in the IAB EU's GDPR Transparency and Consent Framework.
It should be used by anyone who receives or sends consent information like vendors that receive consent data from a partner, or consent management platforms that need to encode/decode the global cookie.

The IAB specification for the consent string format is available on the IAB Github (section 'Vendor Consent Cookie Format').

This library supports the version v1.1 of the specification. It can encode and decode consent strings with version bit 1."
  s.authors     = ["Fidzup Coding Star Team"]
  s.email       = 'coding.stars@fidzup.com'
  s.files       = [
    "lib/iab_consent_string.rb",
    "lib/iab_consent_string/bits.rb",
    "lib/iab_consent_string/purpose.rb",
    "lib/iab_consent_string/gdpr_constants.rb",
    "lib/iab_consent_string/util/utils.rb",
    "lib/iab_consent_string/error/vendor_consent_create_error.rb",
    "lib/iab_consent_string/error/vendor_consent_parse_error.rb",
    "lib/iab_consent_string/error/vendor_consent_error.rb",
    "lib/iab_consent_string/consent/vendor_consent.rb",
    "lib/iab_consent_string/consent/vendor_consent_encoder.rb",
    "lib/iab_consent_string/consent/vendor_consent_decoder.rb",
    "lib/iab_consent_string/consent/range/range_entry.rb",
    "lib/iab_consent_string/consent/range/single_range_entry.rb",
    "lib/iab_consent_string/consent/range/start_end_range_entry.rb",
    "lib/iab_consent_string/consent/implementation/v1/byte_buffer_backed_vendor_consent.rb",
    "lib/iab_consent_string/consent/implementation/v1/vendor_consent_builder.rb",
  ]
  s.homepage    = 'https://rubygems.org/gems/iab_consent_string'
  s.metadata    = { "source_code_uri" => "https://github.com/Fidzup/Consent-String-SDK-Ruby" }
end
