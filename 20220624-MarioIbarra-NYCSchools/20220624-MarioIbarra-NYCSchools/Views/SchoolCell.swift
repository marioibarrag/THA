import UIKit

class SchoolCell: UITableViewCell {

    static let identifier = "SchoolCell"
    
    private let schoolNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let schoolOverviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(schoolNameLabel)
        addSubview(schoolOverviewLabel)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            schoolNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            schoolNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            schoolNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            
            schoolOverviewLabel.topAnchor.constraint(equalTo: schoolNameLabel.bottomAnchor, constant: padding),
            schoolOverviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            schoolOverviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            schoolOverviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    func configureCell(_ school: School) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: school.schoolName)
        attributeString.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 24, weight: .medium), range: NSMakeRange(0, attributeString.length))
        
        schoolNameLabel.attributedText = attributeString
        schoolOverviewLabel.text = school.overview
    }
    
}
