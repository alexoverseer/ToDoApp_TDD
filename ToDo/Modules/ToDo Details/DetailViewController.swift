import UIKit
import MapKit

final class DetailViewController: UIViewController {

    // MARK: - IBOutlers
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var itemInfo: (manager: ItemManager, itemPosition: Int)?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    func setupView() {
        guard let itemInfo = itemInfo else { return }
        let item = itemInfo.0.item(at: itemInfo.1)
        titleLabel.text = item.title
        locationLabel.text = item.location?.name
        itemDescriptionLabel.text = item.itemDescription
        if let timestamp = item.timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        }
        if let coordinate = item.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            mapView.region = region
        }
    }
    
    @IBAction func checkItem() {
        if let itemInfo = itemInfo {
            itemInfo.manager.checkItem(at: itemInfo.itemPosition)
            navigationController?.popViewController(animated: true)
        }
    }
}
