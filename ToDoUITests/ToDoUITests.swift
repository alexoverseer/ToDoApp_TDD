import XCTest

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("Meeting")
        
        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.tap()
        dateTextField.typeText("22/02/2018")
        
        let locationTextField = app.textFields["Location"]
        locationTextField.tap()
        locationTextField.tap()
        locationTextField.typeText("Office")
        
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.tap()
        addressTextField.typeText("Infinite Loop 1, Cupertino")
        
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.tap()
        descriptionTextField.typeText("Bring iPad")
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.tables.staticTexts["Meeting"].exists)
        XCTAssertTrue(app.tables.staticTexts["22/02/2018"].exists)
        XCTAssertTrue(app.tables.staticTexts["Office"].exists)    }
}
