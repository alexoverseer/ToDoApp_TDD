import XCTest
import CoreLocation
@testable import ToDo

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Init_SetsName() {
        let location = Location(name: "Foo")
        XCTAssertEqual(location.name, "Foo")
    }
    
    func test_Init_SetsCoordinate() {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "", coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
    
    func test_EqualLocations_AreEqual() {
        let first = Location(name: "Foo")
        let second = Location(name: "Foo")
        XCTAssertEqual(first, second)
    }
    
    func test_Locations_WhenLatitudeDiffers_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo",
                                   firstLongLat: (latitude: 1.0, longitude: 0.0),
                                   secondName: "Foo",
                                   secondLongLat: (latitude: 0.0, longitude: 0.0))
    }

    func test_Locations_WhenLongitudeDiffers_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo",
                                   firstLongLat: (latitude: 0.0, longitude: 1.0),
                                   secondName: "Foo",
                                   secondLongLat: (latitude: 0.0, longitude: 0.0))
    }
    
    func test_Locations_WhenOnlyOneHasCoordinate_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo",
                                   firstLongLat: (0.0, 0.0),
                                   secondName: "Foo",
                                   secondLongLat: nil)
    }
    
    func test_Locations_WhenNamesDiffer_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo",
                                   firstLongLat: nil,
                                   secondName: "Bar",
                                   secondLongLat: nil)
    }
    
    func assertLocationNotEqualWith(firstName: String,
                                    firstLongLat: (latitude: Double, longitude: Double)?,
                                    secondName: String,
                                    secondLongLat: (latitude: Double, longitude: Double)?,
                                    line: UInt = #line) {
        
        var firstCoord: CLLocationCoordinate2D? = nil
        if let firstLongLat = firstLongLat {
            firstCoord = CLLocationCoordinate2D(latitude: firstLongLat.latitude, longitude: firstLongLat.longitude)
        }
        let firstLocation = Location(name: firstName, coordinate: firstCoord)
        
        var secondCoord: CLLocationCoordinate2D? = nil
        if let secondLongLat = secondLongLat {
            secondCoord = CLLocationCoordinate2D(latitude: secondLongLat.latitude, longitude: secondLongLat.longitude)
        }
        let secondLocation = Location(name: secondName, coordinate: secondCoord)
        
        XCTAssertNotEqual(firstLocation, secondLocation, line: line)
    }
}
