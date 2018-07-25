import XCTest
@testable import ToDo

class ItemListViewControllerTest: XCTestCase {
    
    var sut: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
        sut = viewController as! ItemListViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_LoadingView_SetsTableViewDataSource() {
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func test_LoadingView_DataSourceEqualDelegate() {
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                       sut.tableView.delegate as? ItemListDataProvider)
    }
    
    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }
    
    func test_AddItem_PresentsAddItemViewController() {

        UIApplication.shared.keyWindow?.rootViewController = sut
        
        XCTAssertNil(sut.presentedViewController)

        performAddItemSelector()
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func testItemListVC_SharesItemManagerWithInputVC() {

        UIApplication.shared.keyWindow?.rootViewController = sut
        
        performAddItemSelector()
        
        guard let inputViewController = sut.presentedViewController as? InputViewController else { XCTFail(); return }
        guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func performAddItemSelector() {
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
        guard let action = addButton.action else { XCTFail(); return }
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
    }
    
    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func test_ViewWillAppear_ReloadTableView() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertTrue(mockTableView.reloadDataGotCalled)
    }
    
    func test_ItemSelectedNotification_PushesDetailViewController() {
        
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        sut.loadViewIfNeeded()
        
        sut.itemManager.add(ToDoItem(title: "foo"))
        sut.itemManager.add(ToDoItem(title: "bar"))
        
        NotificationCenter.default.post(name: NSNotification.Name("ItemSelectedNotification"),
                                        object: self,
                                        userInfo: ["index": 1])
        
        guard let detailViewController = mockNavigationController.lastPushedViewController as? DetailViewController else {
                return XCTFail()
        }
        guard let detailItemManager = detailViewController.itemInfo?.manager else {
            return XCTFail()
        }
        guard let index = detailViewController.itemInfo?.itemPosition else {
            return XCTFail()
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }
}

extension ItemListViewControllerTest {
    class MockTableView: UITableView {
        
        var reloadDataGotCalled = false

        override func reloadData() {
            reloadDataGotCalled = true
            super.reloadData()
        }
    }
    
    class MockNavigationController: UINavigationController {
        var lastPushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            lastPushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
