import Foundation
//import MapKit
//import CoreLocation

protocol ViewModelDelegate: AnyObject {
    func didFailFetchingData(error: String)
    func didFetchSchoolData(_ schoolDetails: SchoolSATData)
}

extension ViewModelDelegate {
    func didFetchSchoolData(_ schoolDetails: SchoolSATData) {}
}

class SchoolsViewModel {
    
    @Published private(set) var schools = [School]()
    private var networkManager: NetworkManagerProtocol
    weak var delegate: ViewModelDelegate?
    
    // MARK: - Cache
    /* I could've use NSCache instead of a simple dictionary to cache the data, this would just require a
     little bit more work creating a class to wrap the SchoolSATData struct, or define it as a class in the first place. */
    private(set) var cache: [String: SchoolSATData] = [:]
    
    private var isFetchingData = false
    private var moreSchoolsAvail = true
    var offset = 0
//    var annotations: [MKPointAnnotation] = []
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getSchools() {
        
        guard moreSchoolsAvail else { return }
        guard !isFetchingData else { return }
        
        isFetchingData = true
        
        let url = URLs.schoolsURL
        networkManager.fetchData(from: url, offset: offset, model: [School].self) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
                
            case .success(let schools):
                self.isFetchingData = false
                self.schools.append(contentsOf: schools)
                self.offset += schools.count
//                self.getCoordinates()
                if self.offset > 0 && schools.isEmpty {
                    self.moreSchoolsAvail = false
                }
            case .failure(let error):
                self.isFetchingData = false
                self.delegate?.didFailFetchingData(error: error.rawValue)
            }
        }
    }
    
    func getSchoolData(for schoolID: String) {
        let url = URLs.satDataURL + schoolID
        
        if let data = self.cache[schoolID] {
            self.delegate?.didFetchSchoolData(data)
        } else {
            networkManager.fetchData(from: url, offset: nil, model: [SchoolSATData].self) { [weak self] result in
                switch result {
                    
                case .success(let schoolData):
                    if !schoolData.isEmpty {
                        self?.cache[schoolID] = schoolData[0]
                        self?.delegate?.didFetchSchoolData(schoolData[0])
                    } else {
                        let defaultMessage = "No data available"
                        
                        let emptySchoolData = SchoolSATData(
                            dbn: schoolID,
                            numOfTestTakers: defaultMessage,
                            readingScore: defaultMessage,
                            mathScore: defaultMessage,
                            writingScore: defaultMessage)
                        
                        self?.cache[schoolID] = emptySchoolData
                        self?.delegate?.didFetchSchoolData(emptySchoolData)
                    }
                case .failure(let error):
                    self?.delegate?.didFailFetchingData(error: error.rawValue)
                    
                }
            }
        }
    }
    
    func getCoordinates() -> [(Double, Double, String)?] {
        let coordinates = schools.map({ school -> (Double, Double, String)? in
            guard let latStr = school.latitude, let lngStr = school.longitude, let lat = Double(latStr), let lng = Double(lngStr) else {
                return nil
            }
            return (lat, lng, school.schoolName)
        })
        
//        self.annotations = self.schools.compactMap({ school -> MKPointAnnotation? in
//
//            guard let latStr = school.latitude, let lngStr = school.longitude, let lat = Double(latStr), let lng = Double(lngStr) else {
//                return nil
//            }
//
//            let annotation = MKPointAnnotation()
//            annotation.title = school.schoolName
//            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//            return annotation
//        })
        
        return coordinates
    }
}
