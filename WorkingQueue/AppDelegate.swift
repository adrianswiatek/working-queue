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
        navigationBarAppearace.barTintColor = UIColor(white: 0.06, alpha: 1)
        navigationBarAppearace.barStyle = .blackOpaque
        navigationBarAppearace.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)]
        navigationBarAppearace.isTranslucent = false
    }
}
