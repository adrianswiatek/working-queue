import UIKit

public class WorkflowsContainerController: UIViewController {

    private var isSettingsViewShown: Bool = false

    private let settingsController = UIViewController()
    private let workflowsController = WorkflowsController()

    private let workflowsCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupSettingsController()
        setupWorkflowsController()
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
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleWorkflowsTap))

        workflowsNavigationController.view.addGestureRecognizer(panRecognizer)
        workflowsCoverView.addGestureRecognizer(tapRecognizer)
    }

    private func setupSettingsController() {
        settingsController.view.backgroundColor = .white
        addChild(settingsController)
        view.addSubview(settingsController.view)
    }

    private func handleViewsPassage() {
        isSettingsViewShown ? hideSettingsView() : showSettingsView()
    }

    private func showSettingsView() {
        isSettingsViewShown = true
        workflowsCoverView.isHidden = false

        getAnimator() {
            self.workflowsController.navigationController?.view.transform =
                CGAffineTransform(translationX: self.getMaxWorkflowsControllerXLocation(), y: 0)
        }.startAnimation()
    }

    private func getAnimator(animations: @escaping () -> Void) -> UIViewPropertyAnimator {
        let springTimingParameters =
            UISpringTimingParameters(mass: 0.5, stiffness: 100, damping: 10, initialVelocity: .zero)

        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: springTimingParameters)
        animator.addAnimations(animations)
        return animator
    }

    private func hideSettingsView() {
        isSettingsViewShown = false
        workflowsCoverView.isHidden = true

        getAnimator() {
            self.workflowsController.navigationController?.view.transform = .identity
        }.startAnimation()
    }

    private func getMaxWorkflowsControllerXLocation() -> CGFloat {
        return workflowsController.view.bounds.width / 1.25
    }

    private var lastStartingXLocation: CGFloat = 0.0

    @objc private func handleWorkflowsPan(recognizer: UIPanGestureRecognizer) {
        guard
            let workflowsNavigationController = workflowsController.navigationController,
            workflowsNavigationController.viewControllers.count == 1
        else { return }

        if recognizer.state == .began {
            lastStartingXLocation = isSettingsViewShown ? 0 : recognizer.location(in: nil).x
        }

        let xLocation: CGFloat = recognizer.location(in: nil).x
        let xDifference: CGFloat =
            max(min(xLocation - lastStartingXLocation, getMaxWorkflowsControllerXLocation()), 0)

        workflowsNavigationController.view.transform = CGAffineTransform(translationX: xDifference, y: 0)

        if recognizer.state == .ended {
            let xVelocity: CGFloat = recognizer.velocity(in: nil).x
            handleWorkflowsPanGestureEnd(xDifference, xVelocity)
        }
    }

    private func handleWorkflowsPanGestureEnd(_ xLocation: CGFloat, _ xVelocity: CGFloat) {
        let velocityThreshold: CGFloat = 750.0

        if isSettingsViewShown {
            let locationXThreshold: CGFloat = view.frame.width - view.frame.width / 3
            let canHide = xLocation <= locationXThreshold || xVelocity < -velocityThreshold
            canHide ? hideSettingsView() : showSettingsView()
        } else {
            let locationXThreshold: CGFloat = view.frame.width / 3
            let canShow = xLocation > locationXThreshold || xVelocity > velocityThreshold
            canShow ? showSettingsView() : hideSettingsView()
        }
    }

    @objc private func handleWorkflowsTap() {
        hideSettingsView()
    }
}
