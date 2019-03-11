public struct SettingsViewModel {
    private let colorThemeSection = ColorThemeSettingSectionViewModel()

    public func getNumberOfSections() -> Int {
        return 1
    }

    public func getNumberOfSettingsInSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return colorThemeSection.colorThemes.count
        default:
            return 0
        }
    }
}

public struct ColorThemeSettingSectionViewModel {
    public let settingName: String
    public let colorThemes: [ColorThemeType]

    private var colorThemeDidChangeListeners: [(ColorThemeType) -> Void]

    private var _currentColorTheme: ColorThemeType = .light
    public var currentColorTheme: ColorThemeType {
        get {
            return _currentColorTheme
        }
        set {
            _currentColorTheme = newValue
            colorThemeDidChangeListeners.forEach { $0(newValue) }
        }
    }

    init() {
        settingName = "Color theme"
        colorThemes = ColorThemeType.allCases
        colorThemeDidChangeListeners = []
    }

    public mutating func bindColorThemeChange(listener: @escaping (ColorThemeType) -> Void) {
        colorThemeDidChangeListeners.append(listener)
    }
}
