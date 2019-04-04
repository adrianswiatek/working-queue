import UIKit

class WorkflowsController: UIViewController, ColorThemeRefreshable {

    public var hamburgerButtonDidTap: (() -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.register(WorkflowCell.self, forCellWithReuseIdentifier: workflowCellIdentifier)
        collectionView.register(WorkflowEndCell.self, forCellWithReuseIdentifier: workflowEndCellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var workflowEntries: [WorkflowEntry]
    private var workflowEndEntry: WorkflowEndEntry
    private let workflowCellIdentifier: String
    private let workflowEndCellIdentifier: String

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.workflowEntries = []
        self.workflowEndEntry = WorkflowEndEntry()
        self.workflowCellIdentifier = "WorkflowCell"
        self.workflowEndCellIdentifier = "WorkflowEndCell"

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigationControllerViewShadow()
        setupHamburgerButton()
        refreshColorTheme()
        populateTestData()
    }

    public func refreshColorTheme() {
        navigationController?.refreshNavigationBar()
        navigationController?.view.layer.shadowColor = UIColor.shadowColor.cgColor
        collectionView.backgroundColor = .backgroundColor
        collectionView.refreshCellsColors()
    }

    private func setupViews() {
        navigationItem.title = "Workflow"

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigationControllerViewShadow() {
        navigationController?.view.layer.shadowRadius = 5
        navigationController?.view.layer.shadowOffset = CGSize(width: -5, height: 0)
        navigationController?.view.layer.shadowOpacity = 0.35
    }

    private func setupHamburgerButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "hamburger"), style:
            UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(handleHamburgerButtonTap))
    }

    @objc private func handleHamburgerButtonTap() {
        hamburgerButtonDidTap?()
    }

    private func populateTestData() {
        let toReadEntry = WorkflowEntry(name: "Read")
        toReadEntry.currentQueueEntry = QueueEntry(name: "The Grit")
        toReadEntry.addQueueEntry(QueueEntry(name: "Brain Rules"))
        toReadEntry.addQueueEntry(QueueEntry(name: "So good they can't ignore you"))
        toReadEntry.addQueueEntry(QueueEntry(name: "The Shallows"))
        toReadEntry.addQueueEntry(QueueEntry(name: "Digital Minimalism"))
        workflowEntries.append(toReadEntry)

        let makeNotesEntry = WorkflowEntry(name: "Make notes")
        makeNotesEntry.currentQueueEntry = QueueEntry(name: "The one thing")
        workflowEntries.append(makeNotesEntry)

        let toRetainEntry = WorkflowEntry(name: "Retain")
        toRetainEntry.currentQueueEntry = QueueEntry(name: "The Confidence Gap")
        toRetainEntry.addQueueEntry(QueueEntry(name: "The here and now habit"))
        workflowEntries.append(toRetainEntry)
    }
}

extension WorkflowsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLastItem(indexPath) {
            let finishedItemsController = FinishedItemsController()
            finishedItemsController.entry = workflowEndEntry
            finishedItemsController.delegate = self
            navigationController?.pushViewController(finishedItemsController, animated: true)
        } else {
            let singleQueueController = SingleQueueController()
            singleQueueController.workflowEntry = workflowEntries[indexPath.item]
            singleQueueController.delegate = self
            navigationController?.pushViewController(singleQueueController, animated: true)
        }
    }
}

extension WorkflowsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workflowEntries.count + (workflowEndEntry.numberOfEntries > 0 ? 1 : 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if isLastItem(indexPath) {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: workflowEndCellIdentifier,
                for: indexPath) as! WorkflowEndCell
            cell.update(workflowEndEntry: workflowEndEntry)
            cell.delegate = self
            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: workflowCellIdentifier,
            for: indexPath) as! WorkflowCell
        cell.update(workflowEntry: workflowEntries[indexPath.item])
        cell.delegate = self
        return cell
    }

    private func isLastItem(_ indexPath: IndexPath) -> Bool {
        return indexPath.item == workflowEntries.count
    }
}

extension WorkflowsController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 32
        return isLastItem(indexPath)
            ? .init(width: width, height: 96)
            : .init(width: width, height: 160)
    }
}

extension WorkflowsController: WorkflowCellDelegate {
    func doneButtonDidTap(_ workflowCell: WorkflowCell) {
        if let indexPath = collectionView.indexPath(for: workflowCell) {
            moveQueueEntriesBetweenWorkflowEntries(startingFrom: indexPath)
        }
    }

    private func moveQueueEntriesBetweenWorkflowEntries(startingFrom indexPath: IndexPath) {
        let currentWorkflowEntry = workflowEntries[indexPath.item]
        guard let currentQueueEntry = currentWorkflowEntry.currentQueueEntry else { return }

        let nextIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
        let indexPathsToReload = [indexPath, nextIndexPath]

        let isThisLastWorkflowEntry = indexPath.item == workflowEntries.count - 1
        isThisLastWorkflowEntry
            ? setQueueEntryInWorkflowEndEntry(currentQueueEntry, nextIndexPath)
            : setQueueEntryInNextWorkflowEntry(currentQueueEntry, nextIndexPath)

        currentWorkflowEntry.dequeueToCurrent()
        collectionView.reloadItems(at: indexPathsToReload)
    }

    private func setQueueEntryInNextWorkflowEntry(_ currentQueueEntry: QueueEntry, _ nextIndexPath: IndexPath) {
        let nextWorkflowEntry = workflowEntries[nextIndexPath.item]
        if nextWorkflowEntry.currentQueueEntry == nil {
            nextWorkflowEntry.currentQueueEntry = currentQueueEntry
        } else {
            nextWorkflowEntry.addQueueEntry(currentQueueEntry)
        }
    }

    private func setQueueEntryInWorkflowEndEntry(_ currentQueueEntry: QueueEntry, _ nextIndexPath: IndexPath) {
        workflowEndEntry.addEntry(currentQueueEntry)
        collectionView.insertItems(at: [nextIndexPath])
    }
}

extension WorkflowsController: WorkflowEndCellDelegate {
    func removeAllButton(_ workflowEndCell: WorkflowEndCell) {
        let alertController = UIAlertController(
            title: "Remove All",
            message: "Do you want to remove all items in section?",
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        let removeAllAction = UIAlertAction(title: "Remove All", style: .destructive) { [weak self] _ in
            guard let `self` = self else { return }
            self.workflowEndEntry.removeAllEntries()

            if let indexPath = self.collectionView.indexPath(for: workflowEndCell) {
                self.collectionView.deleteItems(at: [indexPath])
            }
        }
        alertController.addAction(removeAllAction)

        present(alertController, animated: true)
    }
}

extension WorkflowsController: SingleQueueControllerDelegate {
    func didProceedInWorkflow(currentWorkflowEntry: WorkflowEntry) {
        if let indexPath = getIndexPathOf(workflowEntry: currentWorkflowEntry) {
            moveQueueEntriesBetweenWorkflowEntries(startingFrom: indexPath)
        }
    }

    func didReplaceQueueEntry(currentWorkflowEntry: WorkflowEntry) {
        if let indexPath = getIndexPathOf(workflowEntry: currentWorkflowEntry) {
            replaceQueueEntryAt(workflowEntryIndexPath: indexPath)
        }
    }

    private func getIndexPathOf(workflowEntry: WorkflowEntry) -> IndexPath? {
        return workflowEntries
            .firstIndex(where: { $0 === workflowEntry })
            .map { IndexPath(item: $0, section: 0) }
    }

    private func replaceQueueEntryAt(workflowEntryIndexPath indexPath: IndexPath) {
        let currentWorkflowEntry = workflowEntries[indexPath.item]

        if let currentQueueEntry = currentWorkflowEntry.currentQueueEntry {
            currentWorkflowEntry.addQueueEntry(currentQueueEntry)
        }

        currentWorkflowEntry.currentQueueEntry = currentWorkflowEntry.removeFirstQueueEntry()

        collectionView.reloadItems(at: [indexPath])
    }
}

extension WorkflowsController: FinishedItemsControllerDelegate {
    func entryDidDelete(viewController: FinishedItemsController, entry: WorkflowEndEntry) {
        workflowEndEntry = entry
        collectionView.reloadData()
    }
}
