//
//  ActivityExpadableView.swift
//  Reminder
//
//  Created by Rusłan Chamski on 14/10/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

class ActivityExpandableView: UIView {
    enum State {
        case open
        case closed
    }

    enum Constants {
        static let transitionDuration: TimeInterval = 0.6
        static let initialState: State = .closed
        static let animateOnTap = false
    }

    private var velocityFactor : CGFloat = 1000


    // MARK: - GestureRecognizer
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(viewPanned))
        recognizer.delegate = self
        return recognizer
    }()

    // MARK: - Public
    var transitionAnimation: ((State) -> Void)?
    var transitionCompletion: ((State) -> Void)?
    var transitionFraction: ((CGFloat) -> Void)?
    var isTrackingDetection: Bool = true
    private(set) var currentState: State = Constants.initialState

    // MARK: - Properties
    private var runningAnimators: [UIViewPropertyAnimator] = []
    private var animationProgress: [CGFloat] = []

    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(panRecognizer)
    }

    // MARK: - Action
    @objc private func viewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            break
        case .changed:
            if runningAnimators.isEmpty {
                animateTransitionIfNeeded(to: currentState.opposite, duration: Constants.transitionDuration)
                runningAnimators.forEach { $0.pauseAnimation() }
                animationProgress = runningAnimators.map { $0.fractionComplete }
            }
            if (isTrackingDetection && currentState == .open) || currentState == .closed  {
                let translation = recognizer.translation(in: self)
                let offset = State.open.height - State.closed.height
                var fraction = -translation.y / offset
                transitionFraction?(fraction)
                if currentState == .open {
                    transitionFraction?(1)
                }
                [currentState == .open, runningAnimators[0].isReversed].forEach {
                    if $0 { fraction *= -1 }
                }
                runningAnimators.enumerated().forEach { index, animator in
                    animator.fractionComplete = fraction + animationProgress[index]
                }
            }
        case .ended:
            let translation = recognizer.translation(in: self)
            guard !(currentState == .open && translation.y < 0),
                !(currentState == .closed && translation.y > 0)
                else { return }
            var fractionCompleted = translation.y / (State.open.height - State.closed.height)
            var velocity = recognizer.velocity(in: self).y
            velocity = velocity > 0 ? velocity : -velocity
            fractionCompleted = fractionCompleted > 0 ? fractionCompleted : -fractionCompleted
            let modifiedFraction = velocity/velocityFactor + fractionCompleted
            ///
            let shouldClose = modifiedFraction > 0.5

            if velocity == 0 {
                if Constants.animateOnTap {
                    continueAllAnimations()
                }
                break
            }

            let isReversed = runningAnimators[0].isReversed

            switch currentState {
            case .open:
                if !isTrackingDetection  {
                    toggleRunningAnimators()
                    continueAllAnimations()
                    return
                }
                if shouldClose == isReversed {
                    toggleRunningAnimators()
                }
            case .closed:
                if shouldClose == isReversed {
                    toggleRunningAnimators()
                }
            }

            continueAllAnimations()
        default:
            break
        }
    }

    // MARK: - Private
    private func continueAllAnimations() {
        runningAnimators.forEach {
            $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

    private func toggleRunningAnimators() {
        runningAnimators.forEach { $0.isReversed.toggle() }
    }

    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }
        let transitionAnimator = self.transitionAnimator(for: state, duration: duration)
        [transitionAnimator].forEach {
            $0.startAnimation()
            runningAnimators.append($0)
        }
    }

    // an animator for the transition
    private func transitionAnimator(for state: State, duration: TimeInterval) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) { [weak self] in
            self?.transitionAnimation?(state)
        }

        animator.addCompletion { [weak self] position in
            guard let self = self else { return }
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                break
            @unknown default:
                break
            }

            self.transitionCompletion?(self.currentState)
            self.runningAnimators.removeAll()
        }
        return animator
    }
}

extension ActivityExpandableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

// MARK: - Status
private extension ActivityExpandableView.State {
    var height: CGFloat {
        switch self {
        case .open: return 500
        case .closed: return 60
        }
    }

    var opposite: ActivityExpandableView.State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

