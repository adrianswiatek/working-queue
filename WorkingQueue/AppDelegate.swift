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

        return true
    }
}
