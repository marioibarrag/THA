import Foundation

struct School: Decodable {
    let dbn: String
    let schoolName: String
    let overview: String
    let location: String
    let phone: String
    let email: String?
    let latitude: String?
    let longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case dbn, location, latitude, longitude
        case schoolName = "school_name"
        case overview = "overview_paragraph"
        case phone = "phone_number"
        case email = "school_email"
    }
}


