//
//  ViewController.swift
//  Reminder
//
//  Created by Rusłan Chamski on 12/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    typealias State = ActivityExpandableView.State
    // MARK: - Views
    @IBOutlet var circleView: CircleView!
    @IBOutlet var activityContainerView: ActivityExpandableView!

    // MARK: - Constraints
    @IBOutlet var activityViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties
    private var currentState: State {
            return activityContainerView.currentState
        }
    var updateState: ((State) -> Void)?

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupExpandingView()
            activityViewBottomConstraint.constant = currentState.popupOffset
        }

        // MARK: - Private
        private func setupExpandingView() {
            activityContainerView.transitionAnimation = { [weak self] state in
                guard let self = self else { return }
                self.activityViewBottomConstraint.constant = state.popupOffset
                self.view.layoutIfNeeded()
            }

            activityContainerView.transitionCompletion = { [weak self] state in
                guard let self = self else { return }
                // manually reset the constraint positions
                self.activityViewBottomConstraint.constant = state.popupOffset
            }

            activityContainerView.transitionFraction = { [weak self] fraction in
                let state: State = (fraction <= 0.99) ? State.open: State.closed
                self?.updateState?(state)
            }
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ActivitiesViewController
        vc.isTableViewScrolling = { [weak self] tableViewScrolling in
            self?.activityContainerView.isTrackingDetection = tableViewScrolling

        }
        updateState = { state in
            vc.isClosedState = state == .closed
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}


// MARK: - Animation
private extension ActivityExpandableView.State {
    var popupOffset: CGFloat {
        switch self {
        case .open: return 0
        case .closed: return -440
        }
    }

    var overlayViewAlpha: CGFloat {
        switch self {
        case .open: return 0.5
        case .closed: return 0
        }
    }
}
