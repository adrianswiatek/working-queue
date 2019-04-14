import UIKit
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var userDefaultsManager: UserDefaultsManager?

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainContainerController()

        userDefaultsManager = UserDefaultsManager(userDefaults: UserDefaults.standard)

        setInitialColorTheme()
        refreshColorTheme()
        refreshToastAppearance()
        
        return true
    }

    func switchColorTheme(to colorThemeType: ColorThemeType) {
        Theme.shared.switchTheme(to: colorThemeType)
        userDefaultsManager?.setColorThemeType(to: colorThemeType)
        refreshColorTheme()
    }

    private func setInitialColorTheme() {
        guard let colorThemeType = userDefaultsManager?.getColorThemeType() else {
            return Theme.shared.switchTheme(to: .light)
        }

        Theme.shared.switchTheme(to: colorThemeType)
    }

    private func refreshColorTheme() {
        refreshNavigationControllerAppearance()
        refreshToastAppearance()

        let rootViewController = window?.rootViewController as? ColorThemeRefreshable
        rootViewController?.refreshColorTheme()
    }

    private func refreshNavigationControllerAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = .accentColor
        navigationBarAppearance.barStyle = .currentStyle
        navigationBarAppearance.tintColor = .tintColor
        navigationBarAppearance.isTranslucent = false

        navigationBarAppearance.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.tintColor]
        
        navigationBarAppearance.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.tintColor]

        let toolbarAppearance = UIToolbar.appearance()
        toolbarAppearance.tintColor = .tintColor
        toolbarAppearance.barTintColor = .accentColor
    }

    private func refreshToastAppearance() {
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
