import XCTest
@testable import ToDo
import MapKit
import CoreLocation

class DetailViewControllerTest: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")
        sut = viewController as! DetailViewController
        sut.loadViewIfNeeded()
        
        let coordinate = CLLocationCoordinate2DMake(51.2277, 6.7735)
        let location = Location(name: "Foo", coordinate: coordinate)
        let item = ToDoItem(title: "Bar", itemDescription: "Baz", timestamp: 1456150025, location: location)
        let itemManager = ItemManager()
        itemManager.add(item)
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    override func tearDown() {
        sut.itemInfo?.manager.removeAll()
        super.tearDown()
    }
    
    func test_HasTitleLabel() {
        let titleLabelIsSubView = sut.titleLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleLabelIsSubView)
    }
    
    func test_HasDateLabel() {
        let titleLabelIsSubView = sut.dateLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleLabelIsSubView)
    }
    
    func test_HasLocationLabel() {
        let titleLabelIsSubView = sut.locationLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleLabelIsSubView)
    }
    
    func test_HasItemDescriptionLabel() {
        let titleLabelIsSubView = sut.itemDescriptionLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleLabelIsSubView)
    }
    
    func test_HasMapView() {
        let mapViewIsSubView = sut.mapView?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(mapViewIsSubView)
    }
    
    func test_SettingItemInfo_SetsTitleToLabel() {
        XCTAssertEqual(sut.titleLabel.text, "Bar")
    }
    
    func test_SettingItemInfo_SetsDateToLabel() {
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
    }
    
    func test_SettingItemInfo_SetsLocationToLabel() {
        XCTAssertEqual(sut.locationLabel.text, "Foo")
    }
    
    func test_SettingItemInfo_SetsItemDescriptionToLabel() {
        XCTAssertEqual(sut.itemDescriptionLabel.text, "Baz")
    }
    
    func test_SettingItemInfo_SetsCoordinatesToMapView() {
        let coordinate = CLLocationCoordinate2DMake(51.2277, 6.7735)
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, coordinate.longitude, accuracy: 0.001)
    }
    
    func test_CheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "Foo"))
        sut.itemInfo = (itemManager, 0)
        sut.checkItem()
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
}
