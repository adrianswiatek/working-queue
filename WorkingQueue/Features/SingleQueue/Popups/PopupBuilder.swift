import UIKit

protocol PopupBuilder {
    func build() -> Self
    func getResult() -> UIViewController?
}
