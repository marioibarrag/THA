import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    private var viewModel: SchoolsViewModel?
    var school: School
    
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
    
    private let schoolNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let testTakersLabel = UILabel()
    let mathScoreLabel = UILabel()
    let writingScoreLabel = UILabel()
    let readingScoreLabel = UILabel()
    
    init(school: School, _ viewModel: SchoolsViewModel) {
        self.school = school
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "School Data"
        viewModel?.delegate = self
        setUpView()
        viewModel?.getSchoolData(for: school.dbn)
    }
    
    private func setUpView() {
        schoolNameLabel.text = school.schoolName
        
        view.addSubview(map)
        view.addSubview(schoolNameLabel)
        view.addSubview(testTakersLabel)
        view.addSubview(mathScoreLabel)
        view.addSubview(writingScoreLabel)
        view.addSubview(readingScoreLabel)
        
        testTakersLabel.translatesAutoresizingMaskIntoConstraints = false
        mathScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        writingScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        readingScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            schoolNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: padding),
            schoolNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            schoolNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            map.topAnchor.constraint(equalTo: schoolNameLabel.bottomAnchor, constant: 30),
            map.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            map.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            map.heightAnchor.constraint(equalToConstant: 250),
                        
            testTakersLabel.topAnchor.constraint(equalTo: map.bottomAnchor, constant: padding),
            testTakersLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            testTakersLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            
            mathScoreLabel.topAnchor.constraint(equalTo: testTakersLabel.bottomAnchor, constant: padding),
            mathScoreLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            mathScoreLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            
            writingScoreLabel.topAnchor.constraint(equalTo: mathScoreLabel.bottomAnchor, constant: padding),
            writingScoreLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            writingScoreLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            
            readingScoreLabel.topAnchor.constraint(equalTo: writingScoreLabel.bottomAnchor, constant: padding),
            readingScoreLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            readingScoreLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
        ])
        
        guard let latString = self.school.latitude, let lngString = self.school.longitude,
              let lat = Double(latString), let lng = Double(lngString) else {
            return
        }
        
        map.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                latitudinalMeters: 300,
                longitudinalMeters: 300),
            animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.title = self.school.schoolName
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        map.addAnnotation(annotation)
        
    }
    
}

extension DetailViewController: ViewModelDelegate {
    
    func didFetchSchoolData(_ schoolDetails: SchoolSATData) {
        DispatchQueue.main.async {
            self.testTakersLabel.text = "Number of SAT test takers: \(schoolDetails.numOfTestTakers)"
            self.mathScoreLabel.text = "Math SAT score: \t\t\(schoolDetails.mathScore)"
            self.readingScoreLabel.text = "Reading SAT score: \t\(schoolDetails.readingScore)"
            self.writingScoreLabel.text = "Writing SAT score: \t\(schoolDetails.writingScore)"
        }
    }
    
    func didFailFetchingData(error: String) {
        self.presentAlertInMainThread(message: error)
    }
    
}
