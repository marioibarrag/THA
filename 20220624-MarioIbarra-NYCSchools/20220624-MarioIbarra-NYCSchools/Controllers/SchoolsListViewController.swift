import UIKit
import Combine

class SchoolsListViewController: UIViewController {
    
    private let viewModel = SchoolsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(SchoolCell.self, forCellReuseIdentifier: SchoolCell.identifier)
//        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setUpView()
        bindData()
    }
    
    func setDelegates() {
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpView() {
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "map"),
            style: .plain,
            target: self,
            action: #selector(didTapMapButton))
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
    }

    private func bindData() {
        self.viewModel.$schools
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        self.viewModel.getSchools()
    }
    
    @objc private func didTapMapButton() {
        let mapVC = MapViewController(pointAnnotations: viewModel.annotations)
        
        navigationController?.pushViewController(mapVC, animated: true)
    }

}

extension SchoolsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolCell.identifier, for: indexPath) as! SchoolCell
        cell.configureCell(viewModel.schools[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DetailViewController(school: viewModel.schools[indexPath.row]), animated: true)
    }
    
    // Very basic "infinite" scrolling. Not really infinite because API only has 440 schools.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.schools.count - 5 {
            viewModel.getSchools()
        }
    }
    
}

extension SchoolsListViewController: ViewModelDelegate {
    
    func didFailFetchingData(error: String) {
        self.presentAlertInMainThread(message: error)
    }
    
}
