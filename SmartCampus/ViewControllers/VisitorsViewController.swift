import UIKit

final class VisitorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var visitors: [Visitor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"), style: .plain,
            target: self, action: #selector(registerTapped))

        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search name, pass ID or host"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        tableView.register(VisitorTableViewCell.self, forCellReuseIdentifier: VisitorTableViewCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.pin(to: view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    private func reload() {
        let all = Array(VisitorStore.shared.visitors.reversed())
        let query = (searchController.searchBar.text ?? "").trimmed.lowercased()
        visitors = query.isEmpty ? all : all.filter {
            $0.name.lowercased().contains(query) ||
            $0.passID.lowercased().contains(query) ||
            $0.host.lowercased().contains(query)
        }
        tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) { reload() }

    @objc private func registerTapped() {
        navigationController?.pushViewController(RegisterVisitorViewController(), animated: true)
    }

    // MARK: Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { visitors.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitorTableViewCell.reuseID, for: indexPath)
        (cell as? VisitorTableViewCell)?.configure(with: visitors[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        VisitorStore.shared.currentPassID = visitors[indexPath.row].passID
        tabBarController?.selectedIndex = 3   // open the Pass tab
    }
}
