import UIKit

class TrackListViewController: UIViewController{
    var tableView: UITableView?
    var viewModel: TrackListViewModel = TrackListViewModel()
    let cellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initVM()
    }

    func setupUI() {
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }

    /// setup trackViewModel
    func initVM(completion: (() -> Void)? = nil) {
        viewModel.loadingErrorClosure = showErrorAlert
        viewModel.fetchTracks { [weak self] tracks in
            guard let self = self else { return }
            self.viewModel.tracks = tracks
            self.tableView?.reloadData()
            completion?()
        }
    }

    func showErrorAlert() {
        let failedAlert = UIAlertController(title: "Failed to load playlist",
                                            message: "Sorry...",
                                            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        failedAlert.addAction(okAction)
        present(failedAlert, animated: true, completion: nil)
    }
}

extension TrackListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracks.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = viewModel.trackTitle(for: indexPath)
        return cell
    }
}
