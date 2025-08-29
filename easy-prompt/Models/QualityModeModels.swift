//
//  QualityModeModels.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation

// MARK: - Quality Mode Input Models
struct QualityModeInput: Codable, Hashable {
    // Section 1: Basic Info
    var businessName: String = ""
    var city: String = ""
    var businessType: BusinessType = .mixed
    var yearsInBusiness: String = ""
    var teamSize: String = ""
    
    // Section 2: Offering / USP
    var topProducts: [String] = ["", "", ""]
    var uniqueSellingProposition: String = ""
    var priceRange: String = ""
    
    // Section 3: Audience
    var primaryAudience: String = ""
    var secondaryAudience: String = ""
    
    // Section 4: Goals
    var goals: Set<ContentGoal> = []
    
    // Section 5: Platforms
    var platforms: Set<Platform> = []
    var postsPerWeek: Int = 7
    var storiesPerWeek: Int = 0
    
    // Section 6: Tone/Style
    var toneWords: [String] = ["", "", ""]
    
    // Section 7: Content Categories
    var contentCategories: Set<SMMContentCategory> = []
    
    // Section 8: Dates/News Hooks
    var monthlyHooks: String = ""
    
    // Section 9: Promotions and Budget
    var promotions: String = ""
    var advertisingBudget: String = ""
    
    // Section 10: Materials and Resources
    var photoVideoStatus: MaterialStatus = .none
    var whoOnCamera: String = ""
    var canUseUGC: Bool = false
    
    // Section 11: Restrictions
    var restrictions: String = ""
    
    // Section 12: CTA and Contacts
    var mainCTA: String = ""
    var contactInfo: String = ""
    
    // Optional fields
    var brandStory: String = ""
    var competitors: String = ""
    var geography: String = ""
    var peakDays: String = ""
    var topFAQs: [String] = ["", "", ""]
    var hashtags: String = ""
    var potentialCollaborations: String = ""
}

// MARK: - Supporting Enums
enum BusinessType: String, Codable, CaseIterable, Hashable {
    case offline = "Offline"
    case online = "Online"
    case mixed = "Mixed"
}

enum ContentGoal: String, Codable, CaseIterable, Hashable {
    case sales = "Sales"
    case booking = "Booking/Reservation"
    case traffic = "Traffic to Store/Website"
    case followers = "Followers"
    case ugc = "UGC/Reviews"
    case leads = "Leads (Applications)"
    case launch = "Launch/Release"
}

enum Platform: String, Codable, CaseIterable, Hashable {
    case instagram = "Instagram"
    case facebook = "Facebook"
    case tiktok = "TikTok"
    case youtube = "YouTube Shorts"
    case linkedin = "LinkedIn"
    case telegram = "Telegram"
    case pinterest = "Pinterest"
    case googleBusiness = "Google Business Profile"
}

enum SMMContentCategory: String, Codable, CaseIterable, Hashable {
    case product = "Product/Service"
    case promotion = "Promotion/Special Offer"
    case brandStory = "Brand Story"
    case educational = "Educational"
    case values = "Values/Mission"
    case ugcReviews = "UGC/Reviews"
    case behindScenes = "Behind the Scenes"
    case trends = "Trends"
    case expertise = "Expertise"
    case faqMyths = "FAQ/Myths"
    case storytelling = "Storytelling/Cases"
    case interactive = "Interactive"
    case inspiration = "Inspiration/Motivation"
    case entertainment = "Entertainment"
    case socialResponsibility = "Social Responsibility"
    case announcements = "Announcements/Events"
    case customerStories = "Behind the Customer's Scenes"
    case testDrive = "Test Drive/Reviews"
    case comparisons = "Comparisons/Alternatives"
    case seasonal = "Seasonal/Holiday"
}

enum MaterialStatus: String, Codable, CaseIterable, Hashable {
    case haveBasic = "Have Basic"
    case haveProfessional = "Have Professional"
    case none = "None"
}

