import XCTest
@testable import WorkingQueue

class SettingsSectionsTests: XCTestCase {

    func test_getIndexOfSection_withColorThemeSection_returnsSectionIndex() {
        let sut = SettingsSections(headerDidTap: { _ in }, cellDidTap: { _, _ in })
        let colorThemeSection = sut[0]

        XCTAssertNotNil(colorThemeSection)

        let indexOfSection = sut.getIndex(of: colorThemeSection!)

        XCTAssertEqual(indexOfSection, 0)
    }
}
