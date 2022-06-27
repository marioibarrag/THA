import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var pointAnnotations: [MKPointAnnotation]

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
    
    init(pointAnnotations: [MKPointAnnotation]) {
        self.pointAnnotations = pointAnnotations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpView()
    }
    
    private func setUpView() {
        view.addSubview(map)
        map.frame = view.bounds
        map.showAnnotations(self.pointAnnotations, animated: true)
    }
    
}
