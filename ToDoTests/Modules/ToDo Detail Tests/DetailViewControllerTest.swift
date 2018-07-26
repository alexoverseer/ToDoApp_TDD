import XCTest
@testable import ToDo
import CoreLocation

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        sut = storyboard
            .instantiateViewController(
                withIdentifier: "DetailViewController")
            as! DetailViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut.itemInfo?.0.removeAll()
        
        super.tearDown()
    }
    
    func test_HasTitleLabel() {
        let titleLabelIsSubView = sut.titleLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleLabelIsSubView)
    }
    
    func test_HasMapView() {
        let mapViewIsSubView =
            sut.mapView?.isDescendant(
                of: sut.view) ?? false
        XCTAssertTrue(mapViewIsSubView)
    }
    
    func test_SettingItemInfo_SetsTextsToLabels() {
        let coordinate =
            CLLocationCoordinate2DMake(
                51.2277, 6.7735)
        
        let location = Location(name: "Foo", coordinate: coordinate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "27/08/2017")
        let timestamp = date?.timeIntervalSince1970
        
        let item = ToDoItem(title: "Bar",
                            itemDescription: "Baz",
                            timestamp: timestamp,
                            location: location)
        
        
        let itemManager = ItemManager()
        itemManager.add(item)
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertEqual(sut.titleLabel.text, "Bar")
        XCTAssertEqual(sut.dateLabel.text, "27/08/2017")
        XCTAssertEqual(sut.locationLabel.text, "Foo")
        XCTAssertEqual(sut.itemDescriptionLabel.text, "Baz")
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude,
                       coordinate.latitude,
                       accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude,
                       coordinate.longitude,
                       accuracy: 0.001)
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
