import Foundation

struct SchoolSATData: Decodable {
    let dbn: String
    let numOfTestTakers: String
    let readingScore: String
    let mathScore: String
    let writingScore: String
    
    
    enum CodingKeys: String, CodingKey {
        case dbn
        case numOfTestTakers = "num_of_sat_test_takers"
        case readingScore = "sat_critical_reading_avg_score"
        case mathScore = "sat_math_avg_score"
        case writingScore = "sat_writing_avg_score"
    }
}
