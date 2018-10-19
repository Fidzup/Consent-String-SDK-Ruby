# Enumeration of currently defined purposes by IAB
# @see <a href="https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework">https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework</a>
module IABConsentString
  class Purpose
    # The storage of information, or access to information that is already stored, on user device such as accessing advertising identifiers
    # and/or other device identifiers, and/or using cookies or similar technologies.
    STORAGE_AND_ACCESS = 1
    # The collection and processing of information about user of a site to subsequently personalize advertising for them in other contexts,
    #  i.e. on other sites or apps, over time. Typically, the content of the site or app is used to make inferences about user interests, which inform future selections.
    PERSONALIZATION = 2 
    # The collection of information and combination with previously collected information, to select and deliver advertisements and to measure the delivery
    # and effectiveness of such advertisements. This includes using previously collected information about user interests to select ads, processing data about
    # what advertisements were shown, how often they were shown, when and where they were shown, and whether they took any action related to the advertisement,
    # including for example clicking an ad or making a purchase.
    AD_SELECTION = 3
    # The collection of information, and combination with previously collected information, to select and deliver content and to measure the delivery and
    # effectiveness of such content. This includes using previously collected information about user interests to select content, processing data about
    # what content was shown, how often or how long it was shown, when and where it was shown, and whether they took any action related to the content,
    # including for example clicking on content.
    CONTENT_DELIVERY = 4
    # The collection of information about user use of content, and combination with previously collected information, used to measure, understand,
    # and report on user usage of content.
    MEASUREMENT = 5
    # Ads targeted on geolocalization
    GEOLOCALIZED_ADS = 6
    # Purpose ID that is currently not defined
    UNDEFINED = -1

    def initialize(id)
      @id = id
    end

    def getId()
      @id
    end

    def valueOf()
      case @id
      when STORAGE_AND_ACCESS
        return "STORAGE_AND_ACCESS"
      when PERSONALIZATION
        return "PERSONALIZATION"
      when AD_SELECTION
        return "AD_SELECTION"
      when CONTENT_DELIVERY
        return "CONTENT_DELIVERY"
      when MEASUREMENT
        return "MEASUREMENT"
      when GEOLOCALIZED_ADS
        return "GEOLOCALIZED_ADS"
      else
        return "UNDEFINED"
      end
    end
  end
end
