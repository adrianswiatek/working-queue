import UIKit

class SingleQueueController: UIViewController {

    private lazy var controlBar: ControlBar = {
        let controlBar = ControlBar()
        controlBar.delegate = self
        return controlBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let cellIdentifier = "QueueCell"
    private var queue = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setDequeueButtonEditability()
    }

    private func setupViews() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        navigationItem.title = "Queue"

        view.addSubview(controlBar)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            controlBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlBar.heightAnchor.constraint(equalToConstant: 75),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: controlBar.topAnchor)
        ])
    }

    private func addItem(_ name: String) {
        let isNotEmpty = name.trimmingCharacters(in: .whitespaces).count > 0
        guard isNotEmpty else { return }

        queue.append(name)

        let indexPath = IndexPath(
            row: queue.count > 1 ? queue.count - 2 : 0,
            section: queue.count > 1 ? 1 : 0)

        tableView.insertRows(at: [indexPath], with: .automatic)

        setDequeueButtonEditability()
    }

    private func dequeueItem() {
        queue.remove(at: 0)
        tableView.reloadData()
        setDequeueButtonEditability()
    }

    private func setDequeueButtonEditability() {
        if hasFirstItem() {
            controlBar.enableDequeueButton()
        } else {
            controlBar.disableDequeueButton()
        }
    }

    private func hasFirstItem() -> Bool {
        return queue.count > 0
    }
}

extension SingleQueueController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteContextualAction = DeleteContextualAction {
            self.queue.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        return UISwipeActionsConfiguration(actions: [deleteContextualAction])
    }
}

extension SingleQueueController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return queue.count > 0 ? 1 : 0
        } else if section == 1 {
            return queue.count > 0 ? queue.count - 1 : 0
        }

        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SingleQueueHeaderLabel(text: section == 0 ? "Next" : "For later")
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = queue[0]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = queue[indexPath.row + 1]
        }

        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
}

extension SingleQueueController: ControlBarDelegate {
    func controlBarDidAdd(_ controlBar: ControlBar) {
        let popupController = AddSingleQueuePopupBuilder { [unowned self] in self.addItem($0) }

        if let controller = popupController.build().getResult() {
            present(controller, animated: true)
        }
    }

    func controlBarDidDequeue(_ controlBar: ControlBar) {
        dequeueItem()
    }
}
