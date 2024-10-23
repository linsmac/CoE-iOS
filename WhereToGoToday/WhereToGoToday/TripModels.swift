import Foundation

// API 回應的總結構
struct TripResponse: Codable {
    let generatedTripInfo: GeneratedTripInfo
    
    enum CodingKeys: String, CodingKey {
        case generatedTripInfo = "generated_trip_info"
    }
}

// 包含行程總覽和每天行程的結構
struct GeneratedTripInfo: Codable {
    let tripOverview: TripOverview
    let days: [Day]
    
    enum CodingKeys: String, CodingKey {
        case tripOverview = "trip_overview"
        case days
    }
}

// 行程總覽的結構
struct TripOverview: Codable {
    let location: String
    let startDate: String
    let endDate: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case location
        case startDate = "start_date"
        case endDate = "end_date"
        case description
    }
}

// 每天行程的結構
struct Day: Codable {
    let label: String
    let date: String
    let activities: [Activity]
}

// 每個活動的結構
struct Activity: Codable {
    let location: String
    let startTime: String
    let endTime: String
    let activity: String
    let stayDuration: String?   // 可選值，有些活動可能沒有停留時間
    let address: String?        // 有些活動可能沒有地址
    let transportation: Transportation?  // 可選的交通資訊
    
    enum CodingKeys: String, CodingKey {
        case location
        case startTime = "start_time"
        case endTime = "end_time"
        case activity
        case stayDuration = "stay_duration"
        case address
        case transportation
    }
}

// 交通資訊的結構
struct Transportation: Codable {
    let mode: String
    let travelTime: String?  // 有些情況下可能沒有 travelTime
    
    enum CodingKeys: String, CodingKey {
        case mode
        case travelTime = "travel_time"
    }
}

struct TripDay {
    let day: String
    let activities: [String]
}

