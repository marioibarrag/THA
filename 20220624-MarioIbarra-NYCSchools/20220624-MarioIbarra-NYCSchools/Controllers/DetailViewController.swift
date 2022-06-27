import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    private var viewModel: SchoolsViewModel?
    var school: School
    let verticalPadding: CGFloat = 10
    let horizontalPadding: CGFloat = 20
    
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
    
    let satScoresLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "SAT Scores:")
        attributeString.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let testTakersLabel = UILabel()
    let mathScoreLabel = UILabel()
    let writingScoreLabel = UILabel()
    let readingScoreLabel = UILabel()
    
    let contactLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Contact Details:")
        attributeString.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel = UILabel()
    let phoneLabel = UILabel()
    
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
        viewModel?.getSchoolData(for: school)
    }
    
    private func setUpView() {
        schoolNameLabel.text = school.schoolName
        
        view.addSubview(map)
        view.addSubview(schoolNameLabel)
        view.addSubview(satScoresLabel)
        view.addSubview(testTakersLabel)
        view.addSubview(mathScoreLabel)
        view.addSubview(writingScoreLabel)
        view.addSubview(readingScoreLabel)
        view.addSubview(contactLabel)
        view.addSubview(locationLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneLabel)
        
        testTakersLabel.translatesAutoresizingMaskIntoConstraints = false
        mathScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        writingScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        readingScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            schoolNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: verticalPadding),
            schoolNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            schoolNameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            map.topAnchor.constraint(equalTo: schoolNameLabel.bottomAnchor, constant: 30),
            map.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            map.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            map.heightAnchor.constraint(equalToConstant: 250),
            
            satScoresLabel.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 30),
            satScoresLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            satScoresLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
                        
            testTakersLabel.topAnchor.constraint(equalTo: satScoresLabel.bottomAnchor, constant: verticalPadding),
            testTakersLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            testTakersLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            
            mathScoreLabel.topAnchor.constraint(equalTo: testTakersLabel.bottomAnchor, constant: verticalPadding),
            mathScoreLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            mathScoreLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            
            writingScoreLabel.topAnchor.constraint(equalTo: mathScoreLabel.bottomAnchor, constant: verticalPadding),
            writingScoreLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            writingScoreLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            
            readingScoreLabel.topAnchor.constraint(equalTo: writingScoreLabel.bottomAnchor, constant: verticalPadding),
            readingScoreLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            readingScoreLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            
            contactLabel.topAnchor.constraint(equalTo: readingScoreLabel.bottomAnchor, constant: 30),
            contactLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            contactLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            
            locationLabel.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: verticalPadding),
            locationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            locationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            
            emailLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: verticalPadding),
            emailLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            emailLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding),
            
            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: verticalPadding),
            phoneLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: horizontalPadding),
            phoneLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -horizontalPadding)
            
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
    
    func didFetchSchoolData(_ school: School, _ schoolDetails: SchoolSATData) {
        DispatchQueue.main.async {
            self.testTakersLabel.text = "Number of SAT test takers: \(schoolDetails.numOfTestTakers)"
            self.mathScoreLabel.text = "Math SAT score: \t\t\(schoolDetails.mathScore)"
            self.readingScoreLabel.text = "Reading SAT score: \t\(schoolDetails.readingScore)"
            self.writingScoreLabel.text = "Writing SAT score: \t\(schoolDetails.writingScore)"
            self.locationLabel.text = school.location
            
            if let email = school.email {
                self.emailLabel.text = email
            } else {
                self.emailLabel.removeFromSuperview()
                NSLayoutConstraint.activate([
                    self.phoneLabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor, constant: self.verticalPadding)
                ])
            }
            self.phoneLabel.text = school.phone
        }
    }
    
    func didFailFetchingData(error: String) {
        self.presentAlertInMainThread(message: error)
    }
    
}
