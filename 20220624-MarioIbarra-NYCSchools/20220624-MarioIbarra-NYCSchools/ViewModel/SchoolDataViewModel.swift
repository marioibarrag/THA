import Foundation
import MapKit
import CoreLocation

class SchoolDataViewModel {
    
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ViewModelDelegate?
    
    // MARK: - Cache
    /* I could've use NSCache instead of a simple dictionary to cache the data, this would just require a
     little bit more work creating a class to wrap the SchoolSATData struct, or define it as a class in the first place.
     Also, an alternative of using a static property, we could use a "CacheManager"*/
    static private(set) var cache: [String: SchoolSATData] = [:]
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getSchoolData(for school: School) {
        let schoolID = school.dbn
        let url = URLs.satDataURL + schoolID
        
        if let data = SchoolDataViewModel.cache[schoolID] {
            self.delegate?.didFetchSchoolData(school, data)
        } else {
            networkManager.fetchData(from: url, offset: nil, model: [SchoolSATData].self) { [weak self] result in
                switch result {
                    
                case .success(let schoolData):
                    if !schoolData.isEmpty {
                        SchoolDataViewModel.cache[schoolID] = schoolData[0]
                        self?.delegate?.didFetchSchoolData(school, schoolData[0])
                    } else {
                        let defaultMessage = "No data available"
                        
                        let emptySchoolData = SchoolSATData(
                            dbn: schoolID,
                            numOfTestTakers: defaultMessage,
                            readingScore: defaultMessage,
                            mathScore: defaultMessage,
                            writingScore: defaultMessage)
                        
                        SchoolDataViewModel.cache[schoolID] = emptySchoolData
                        self?.delegate?.didFetchSchoolData(school, emptySchoolData)
                        
                        print("Failure, cached for: \(schoolID)")
                    }
                case .failure(let error):
                    self?.delegate?.didFailFetchingData(error: error.rawValue)
                    
                }
            }
        }
    }
        
}
