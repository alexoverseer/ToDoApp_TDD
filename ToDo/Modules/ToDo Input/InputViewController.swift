import UIKit
import CoreLocation

class InputViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    @IBAction func save() {
        
        guard let titleString = titleTextField.text,
            titleString.count > 0 else { return }
        
        let date: Date?
        if let dateText = self.dateTextField.text,
            dateText.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        
        let descriptionString = descriptionTextField.text
        
        if let locationName = locationTextField.text,
            locationName.count > 0 {
            
            if let address = addressTextField.text,
                address.count > 0 {
                
                geocoder.geocodeAddressString(address) { [unowned self] placemarks, error in
                    let placeMark = placemarks?.first
                    
                    let item = ToDoItem(title: titleString,
                                        itemDescription: descriptionString,
                                        timestamp: date?.timeIntervalSince1970,
                                        location: Location(name: locationName,
                                                           coordinate: placeMark?.location?.coordinate))
                    self.itemManager?.add(item)
                    self.dismiss(animated: true)
                }
            }
        } else {
            let item = ToDoItem(title: titleString,
                                itemDescription: descriptionString,
                                timestamp: date?.timeIntervalSince1970,
                                location: nil)
            self.itemManager?.add(item)
            self.dismiss(animated: true)
        }
    }
}
