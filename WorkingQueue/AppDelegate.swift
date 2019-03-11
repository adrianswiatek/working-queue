import UIKit
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()

        window?.rootViewController = MainContainerController()

        refreshColorTheme()
        setupToast()
        
        return true
    }

    func refreshColorTheme() {
        setupNavigationControllerAppearance()

        let rootViewController = window?.rootViewController as? ColorThemeRefreshable
        rootViewController?.refreshColorTheme()

        setupToast()
    }

    private func setupNavigationControllerAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = .accentColor
        navigationBarAppearace.barStyle = .currentStyle
        navigationBarAppearace.tintColor = .tintColor
        navigationBarAppearace.isTranslucent = false

        navigationBarAppearace.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.tintColor]
        
        navigationBarAppearace.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.tintColor]
    }

    private func setupToast() {
        func getToastStyle() -> ToastStyle {
            var style = ToastStyle()
            style.backgroundColor = .accentColor
            style.messageColor = .tintColor
            style.verticalPadding = 12
            style.horizontalPadding = 12
            return style
        }

        let toastManager = ToastManager.shared
        toastManager.duration = 4
        toastManager.style = getToastStyle()
    }
}
