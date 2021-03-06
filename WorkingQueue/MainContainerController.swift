import UIKit

public class MainContainerController: UIViewController, ColorThemeRefreshable {

    private let settingsController: SettingsController & ColorThemeRefreshable = SettingsController()
    private let workflowsController: WorkflowsController & ColorThemeRefreshable = WorkflowsController()

    private var isSettingsViewShown: Bool = false
    private var lastStartingXLocation: CGFloat = 0.0

    private var maxWorkflowsXLocation: CGFloat {
        return view.frame.width - 56
    }

    private let workflowsCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .currentStyle
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupSettingsController()
        setupWorkflowsController()
    }

    public func refreshColorTheme() {
        settingsController.refreshColorTheme()
        workflowsController.refreshColorTheme()
    }

    private func setupWorkflowsController() {
        workflowsController.hamburgerButtonDidTap = handleViewsPassage

        let workflowsNavigationController =
            UINavigationController(rootViewController: workflowsController)

        addChild(workflowsNavigationController)
        view.addSubview(workflowsNavigationController.view)

        let workflowsView = workflowsController.view!

        workflowsView.addSubview(workflowsCoverView)
        NSLayoutConstraint.activate([
            workflowsCoverView.leadingAnchor.constraint(equalTo: workflowsView.leadingAnchor),
            workflowsCoverView.topAnchor.constraint(equalTo: workflowsView.topAnchor),
            workflowsCoverView.trailingAnchor.constraint(equalTo: workflowsView.trailingAnchor),
            workflowsCoverView.bottomAnchor.constraint(equalTo: workflowsView.bottomAnchor)
        ])

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleWorkflowsPan))
        panRecognizer.delegate = self
        workflowsNavigationController.view.addGestureRecognizer(panRecognizer)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleWorkflowsTap))
        workflowsCoverView.addGestureRecognizer(tapRecognizer)
    }

    private func setupSettingsController() {
        let settingsNavigationController =
            UINavigationController(rootViewController: settingsController)

        addChild(settingsNavigationController)
        view.addSubview(settingsNavigationController.view)
    }

    private func handleViewsPassage() {
        isSettingsViewShown ? hideSettingsView() : showSettingsView()
    }

    private func showSettingsView() {
        isSettingsViewShown = true
        workflowsCoverView.isHidden = false

        let showSettingsTranslation = CGAffineTransform(translationX: maxWorkflowsXLocation, y: 0)
        animate { self.workflowsController.navigationController?.view.transform = showSettingsTranslation }
    }

    private func hideSettingsView() {
        isSettingsViewShown = false
        workflowsCoverView.isHidden = true

        animate { self.workflowsController.navigationController?.view.transform = .identity }
    }

    private func animate(animations: @escaping () -> Void) {
        let springTimingParameters =
            UISpringTimingParameters(mass: 0.5, stiffness: 100, damping: 10, initialVelocity: .zero)

        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springTimingParameters)
        animator.addAnimations(animations)
        animator.startAnimation()
    }

    @objc private func handleWorkflowsPan(recognizer: UIPanGestureRecognizer) {
        guard let workflowsNavigationController = workflowsController.navigationController else { return }

        let canHandlePan = workflowsNavigationController.viewControllers.count == 1
        guard canHandlePan else { return }

        if recognizer.state == .began {
            lastStartingXLocation = isSettingsViewShown ? 0 : recognizer.location(in: nil).x
        }

        let xLocation: CGFloat = recognizer.location(in: nil).x
        let xDifference: CGFloat = max(min(xLocation - lastStartingXLocation, maxWorkflowsXLocation), 0)

        workflowsNavigationController.view.transform = CGAffineTransform(translationX: xDifference, y: 0)

        if recognizer.state == .ended {
            let xVelocity: CGFloat = recognizer.velocity(in: nil).x
            handleWorkflowsPanGestureEnd(xDifference, xVelocity)
        }
    }

    private func handleWorkflowsPanGestureEnd(_ xLocation: CGFloat, _ xVelocity: CGFloat) {
        let velocityThreshold: CGFloat = 750.0
        let screenWidth = view.frame.width

        if isSettingsViewShown {
            let locationXThreshold: CGFloat = screenWidth - screenWidth / 3
            let canHide = xLocation <= locationXThreshold || xVelocity < -velocityThreshold
            canHide ? hideSettingsView() : showSettingsView()
        } else {
            let locationXThreshold: CGFloat = screenWidth / 3
            let canShow = xLocation > locationXThreshold || xVelocity > velocityThreshold
            canShow ? showSettingsView() : hideSettingsView()
        }
    }

    @objc private func handleWorkflowsTap() {
        hideSettingsView()
    }
}

extension MainContainerController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
