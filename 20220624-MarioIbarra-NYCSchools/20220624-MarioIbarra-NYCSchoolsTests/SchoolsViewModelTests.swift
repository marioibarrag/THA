//
//  SchoolsViewModelTests.swift
//  20220624-MarioIbarra-NYCSchoolsTests
//
//  Created by Mario Ibarra on 6/26/22.
//

import XCTest
import Combine
@testable import _0220624_MarioIbarra_NYCSchools

class SchoolsViewModelTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
        let viewModel = SchoolsViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchoolData(for: "02M438")
        viewModel.getSchoolData(for: "02M438")
        
        XCTAssertTrue(!viewModel.cache.isEmpty)
    }
    
    func testCanGetCoordinatesFromSchool() {
        let fakeNetworkManager = FakeNetworkManager()
        let data = getDataFrom(jsonFile: "School")
        fakeNetworkManager.data = data
        let viewModel = SchoolsViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchools()
        
        let coordinates = viewModel.getCoordinates()
        /*
         Coordinates from JSON file:
         "latitude": "40.73653",
         "longitude": "-73.9927",
         */
        XCTAssertEqual(40.73653, coordinates[0]?.0)
        XCTAssertEqual(-73.9927, coordinates[0]?.1)
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
        let viewModel = SchoolsViewModel(networkManager: fakeNetworkManager)
        viewModel.getSchoolData(for: "02M438")
        
        let defaultMessage = "No data available"
        let emptySchoolData = SchoolSATData(
            dbn: "02M438",
            numOfTestTakers: defaultMessage,
            readingScore: defaultMessage,
            mathScore: defaultMessage,
            writingScore: defaultMessage)
        
        XCTAssertEqual(emptySchoolData, viewModel.cache["02M438"]!)
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
