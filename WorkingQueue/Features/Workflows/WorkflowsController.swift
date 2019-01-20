import UIKit

class WorkflowsController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width - 32, height: 150)
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .backgroundColor
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.register(WorkflowCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var workflowEntries: [WorkflowEntry]
    private let cellIdentifier: String

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.workflowEntries = []
        self.cellIdentifier = "WorkflowCell"

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        populateTestData()
    }

    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    private func setupViews() {
        navigationItem.title = "Workflow"
        view.backgroundColor = .backgroundColor

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func populateTestData() {
        let toReadEntry = WorkflowEntry(name: "Read")
        toReadEntry.currentItem = QueueEntry(name: "The Grit")
        toReadEntry.addQueueEntry(QueueEntry(name: "Brain Rules"))
        toReadEntry.addQueueEntry(QueueEntry(name: "So good they can't ignore you"))
        workflowEntries.append(toReadEntry)

        let makeNotesEntry = WorkflowEntry(name: "Make notes")
        makeNotesEntry.currentItem = QueueEntry(name: "The one thing")
        workflowEntries.append(makeNotesEntry)

        let toRetainEntry = WorkflowEntry(name: "Retain")
        toRetainEntry.currentItem = QueueEntry(name: "The Confidence Gap")
        toRetainEntry.addQueueEntry(QueueEntry(name: "The here and now habit"))
        workflowEntries.append(toRetainEntry)
    }
}

extension WorkflowsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let singleQueueController = SingleQueueController()
        singleQueueController.workflowEntry = workflowEntries[indexPath.item]
        navigationController?.pushViewController(singleQueueController, animated: true)
    }
}

extension WorkflowsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workflowEntries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WorkflowCell
        cell.update(workflowEntry: workflowEntries[indexPath.item])
        return cell
    }
}
