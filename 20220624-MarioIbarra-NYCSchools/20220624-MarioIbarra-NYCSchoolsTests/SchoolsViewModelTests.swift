import XCTest
import Combine
@testable import _0220624_MarioIbarra_NYCSchools

class SchoolsViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    func testCanFetchAndDecodeSchools() {
        let fakeNetworkManager = FakeNetworkManager()
        let data = getDataFrom(jsonFile: "School")
        fakeNetworkManager.data = data
        let viewModel = SchoolsViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchools()
        
        XCTAssertTrue(!viewModel.schools.isEmpty)
    }
    
    func testCanFetchAndDecodeSchoolData() {
        let fakeNetworkManager = FakeNetworkManager()
        let data = getDataFrom(jsonFile: "SchoolData")
        fakeNetworkManager.data = data
        let viewModel = SchoolDataViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchoolData(for: School(dbn: "02M438", schoolName: "", overview: "", location: "", phone: "", email: nil, latitude: "", longitude: ""))
        
        XCTAssertTrue(!SchoolDataViewModel.cache.isEmpty)
    }
    
    func testCanGetCoordinatesFromSchool() {
        let fakeNetworkManager = FakeNetworkManager()
        let data = getDataFrom(jsonFile: "School")
        fakeNetworkManager.data = data
        let viewModel = SchoolsViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchools()
    
        /*
         Coordinates from JSON file:
         "latitude": "40.73653",
         "longitude": "-73.9927",
         */
        XCTAssertEqual(40.73653, viewModel.annotations[0].coordinate.latitude)
        XCTAssertEqual(-73.9927, viewModel.annotations[0].coordinate.longitude)
    }
    
    func testSchoolsFetchError() {
        let fakeNetworkManager = FakeNetworkManager()
        fakeNetworkManager.error = .other
        let viewModel = SchoolsViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchools()
        
        XCTAssertTrue(viewModel.schools.isEmpty)
    }
    
    func testNoSchoolDataAvailable() {
        let fakeNetworkManager = FakeNetworkManager()
        
        // when there's no SAT scores data available from a school, the NYC Schools API returns an empty array
        let data = "[]".data(using: .utf8)!
        fakeNetworkManager.data = data
        let viewModel = SchoolDataViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchoolData(for: School(dbn: "02M438", schoolName: "", overview: "", location: "", phone: "", email: "", latitude: "", longitude: ""))
        
        let defaultMessage = "No data available"
        let emptySchoolData = SchoolSATData(
            dbn: "02M438",
            numOfTestTakers: defaultMessage,
            readingScore: defaultMessage,
            mathScore: defaultMessage,
            writingScore: defaultMessage)
        
        XCTAssertEqual(emptySchoolData, SchoolDataViewModel.cache["02M438"]!)
    }
    
    private func getDataFrom(jsonFile: String) -> Data {
        let bundle = Bundle(for: FakeNetworkManager.self)
        guard let url = bundle.url(forResource: jsonFile, withExtension: "json")
        else { return Data() }
        return try! Data(contentsOf: url)
    }
}

extension SchoolSATData: Equatable {
    public static func == (lhs: SchoolSATData, rhs: SchoolSATData) -> Bool {
        return lhs.dbn == rhs.dbn
    }
}
