import UIKit

public class SettingsController: UICollectionViewController, ColorThemeRefreshable {

    private let colorThemeCellId = "CellId"

    convenience init() {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        refreshColorTheme()
    }

    private func setViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        collectionView.register(ColorThemeSettingCell.self, forCellWithReuseIdentifier: colorThemeCellId)
    }

    public func refreshColorTheme() {
        navigationController?.refreshNavigationBar()
        navigationController?.view.backgroundColor = .accentColor
        collectionView.backgroundColor = .accentColor
        collectionView.refreshCellsColors()
    }

    public override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    public override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: colorThemeCellId, for: indexPath)
    }

    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            handleColorThemeCellDidTap(indexPath)
        default:
            break
        }
    }

    private func handleColorThemeCellDidTap(_ indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Select Color Theme", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        for colorThemeType in ColorThemeType.allCases {
            guard colorThemeType.rawValue != Theme.shared.current.type.rawValue else { continue }

            let action = UIAlertAction(title: colorThemeType.rawValue, style: .default, handler: { _ in
                let cell = self.collectionView.cellForItem(at: indexPath) as? ColorThemeSettingCell
                cell?.setOption(to: colorThemeType)
                Theme.shared.switchTheme(to: colorThemeType)
            })

            alertController.addAction(action)
        }

        present(alertController, animated: true)
    }
}

extension SettingsController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 48)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 0, right: 0)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
