//
//  ViewController.swift
//  Swiper
//
//  Created by Theodor Tomander Skippervold on 04/10/2018.
//  Copyright © 2018 Theodor Tomander Skippervold. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: self.view.bounds)
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    let connectButton = CircularActionButton()

    private var currentViewController: UIViewController?
    private var nextViewController: UIViewController?

    private var offsetAnimator = UIViewPropertyAnimator()

    private var connectButtonAnchor: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height)

        addCurrentPageViewController()
        addNextPageViewController()


        view.addSubview(connectButton)

        connectButton.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        connectButtonAnchor = connectButton.rightAnchor.constraint(equalTo: scrollView.leftAnchor)
        connectButtonAnchor.isActive = true
    }

    private func addCurrentPageViewController() {
        let cardViewController = CardViewController()

        addChild(cardViewController)
        scrollView.addSubview(cardViewController.view)
        cardViewController.didMove(toParent: self)

        currentViewController = cardViewController
    }

    private func addNextPageViewController() {
        let cardViewController = CardViewController()
        cardViewController.view.frame.origin = CGPoint(x: scrollView.bounds.width, y: 0)
        cardViewController.view.transform = CGAffineTransform(translationX: -40, y: 0)

        addChild(cardViewController)
        scrollView.addSubview(cardViewController.view)
        cardViewController.didMove(toParent: self)

        nextViewController = cardViewController

        offsetAnimator = UIViewPropertyAnimator()
        offsetAnimator.addAnimations {
            cardViewController.view.transform = .identity
        }
    }

    private func removeAsChild(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
    }

}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percentageScrolled = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)

        if percentageScrolled < 0 {
            let flippedContentOffset = (scrollView.contentOffset.x * -1)
            connectButtonAnchor.constant = min(scrollView.contentOffset.x * -1, 100)
            connectButton.backgroundFillPercentage = max(0, min(1, flippedContentOffset / 130))
            return // Bouncing to the left
        }

        if percentageScrolled > 1 {
            return // Bouncing to the right
        }

        offsetAnimator.fractionComplete = percentageScrolled

        if let viewController = currentViewController {
            let isViewControllerVisible = scrollView.bounds.intersects(viewController.view.frame)
            if isViewControllerVisible {
                return
            }

            removeAsChild(viewController)

            currentViewController = nextViewController
            currentViewController?.view.frame.origin = .zero

            if offsetAnimator.state != .stopped {
                offsetAnimator.addCompletion { _ in
                    self.addNextPageViewController()
                    scrollView.contentOffset = .zero
                }
                offsetAnimator.stopAnimation(false)
                offsetAnimator.finishAnimation(at: .end)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let percentageScrolled = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.width)

        if percentageScrolled < 0.5 {
            print("scrollViewDidEndDecelerating on first page")
        } else {
            print("scrollViewDidEndDecelerating on second page")
        }
    }

}

class CircularActionButton: UIButton {

    var backgroundFillPercentage: CGFloat = 0 {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(backgroundFillPercentage)
        }
    }

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(equalToConstant: 80).isActive = true
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        layer.cornerRadius = 40

        backgroundColor = UIColor.green.withAlphaComponent(0.0)
        layer.borderWidth = 3
        layer.borderColor = UIColor.green.cgColor

        setTitle("Connect", for: .normal)
    }

}
