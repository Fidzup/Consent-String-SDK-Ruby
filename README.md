![GitHub release](https://img.shields.io/github/release/Fidzup/Consent-String-SDK-Ruby.svg)

# Transparency and Consent Framework: Consent-String-SDK-Ruby

Encode and decode web-safe base64 consent information with the IAB EU's GDPR Transparency and Consent Framework.

This library is a Ruby reference implementation for dealing with consent strings in the IAB EU's GDPR Transparency and Consent Framework.  
It should be used by anyone who receives or sends consent information like vendors that receive consent data from a partner, or consent management platforms that need to encode/decode the global cookie.

The IAB specification for the consent string format is available on the [IAB Github](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/Consent%20string%20and%20vendor%20list%20formats%20v1.1%20Final.md) (section "Vendor Consent Cookie Format").

**This library supports the version v1.1 of the specification. It can encode and decode consent strings with version bit 1.**

## IAB Europe Transparency and Consent Framework 

In November 2017, IAB Europe and a cross-section of the publishing and advertising industry, announced a new Transparency & Consent Framework to help publishers, advertisers and technology companies comply with key elements of GDPR. The Framework will give the publishing and advertising industries a common language with which to communicate consumer consent for the delivery of relevant online advertising and content. 

Framework Technical specifications available at: https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework 


# Consent String SDK (Ruby)
- [Installation](#installation)
- [Usage](#usage)
- [Building](#building)
- [Contributing](#contributing)
- [Versioning](#versioning)


## Installation

Install the gem via rubygem site

```
  gem install iab_consent_string
```

Or if you have built it by hand

```
  gem install ./iab_consent_string-1.0.0.gem
```

## Usage

### Decoding consent string

```
require 'iab_consent_string'

...

vendorConsent = IABConsentString::Consent::VendorConsentDecoder.fromBase64String(consentString);

if (vendorConsent.isVendorAllowed(vendorId) && vendorConsent.isPurposeAllowed(IABConsentString::GDPRConstants::STORAGE_AND_ACCESS)
   ...
else
   ...
end

```

### Creating vendor consent
```
vendorConsent = IABConsentString::Consent::Implementation::V1::VendorConsentBuilder.new()
        .withConsentRecordCreatedOn(now)
        .withConsentRecordLastUpdatedOn(now)
        .withCmpID(cmpId)
        .withCmpVersion(cmpVersion)
        .withConsentScreenID(consentScreenID)
        .withConsentLanguage(consentLanguage)
        .withVendorListVersion(vendorListVersion)
        .withAllowedPurposes(allowedPurposes)
        .withMaxVendorId(maxVendorId)
        .withVendorEncodingType(vendorEncodingType)
        .withDefaultConsent(false)
        .withRangeEntries(rangeEntries)
        .build()
```

### Encoding vendor consent to string
```
base64String = IABConsentString::Consent::VendorConsentEncoder.toBase64String(vendorConsent)
```

## Building

Use the gem command to build the gem file
```
git clone https://github.com/Fidzup/Consent-String-SDK-Ruby.git
cd  Consent-String-SDK-Ruby
gem build iab_consent_string.gemspec
```

## Contributing

### Branching 
We use following branching setup
1. **master** branch is the current branch where active development is taking place and is associated with the latest release
1. Previous releases are under branches release/x, where x is the major release version, for example release/1. Those branches are used for bug bixes in previous releases
1. Each release version is associated with a git tag, for example tag v2.0.0

### Pull request procedures
1. Make sure there is a unit test for each added feature. If pull request is for bug fix, create a unit test that would trigger a bug
1. Make sure **all** tests pass
1. Update this document if usage is changing
 

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/tags). 

## About 

#### About Fidzup


Learn more about Fidzup here: [https://www.fidzup.com/](https://www.fidzup.com/)

#### Contributors and Technical Governance

All Fidzup Coding Stars are able to manage this repository. But we encourage all others Coding Stars (never forget, if you code, you're a coding star) to open an issue, or submit a PR. 

