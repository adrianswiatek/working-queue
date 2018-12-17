import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()

        let controller = SingleQueueController()
        let navigationController = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigationController

        setupNavigationControllerAppearance()

        return true
    }

    private func setupNavigationControllerAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = .accentColor
        navigationBarAppearace.barStyle = .blackOpaque
        navigationBarAppearace.tintColor = .tintColor
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tintColor]
        navigationBarAppearace.isTranslucent = false
    }
}
