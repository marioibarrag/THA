import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var coordinates: [(Double, Double, String)?] = []

    private let map: MKMapView = {
        let map = MKMapView()
        map.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
            animated: false)
        map.layer.cornerRadius = 15
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
    }
    
    private func setUpView() {
        view.addSubview(map)
        map.frame = view.bounds
        
        let annotations = self.coordinates.compactMap { tuple -> MKPointAnnotation? in

            guard let tuple = tuple else { return nil }

            let annotation = MKPointAnnotation()
            annotation.title = tuple.2
            annotation.coordinate = CLLocationCoordinate2D(latitude: tuple.0, longitude: tuple.1)
            return annotation
        }
        
        map.showAnnotations(annotations, animated: true)
    }
    
}
