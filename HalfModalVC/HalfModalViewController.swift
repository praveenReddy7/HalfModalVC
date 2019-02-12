//
//  HalfModalViewController.swift
//  HalfModalVC
//
//  Created by praveen reddy on 1/26/19.
//  Copyright © 2019 praveen reddy. All rights reserved.
//

import UIKit

final class HalfModalViewController: UIViewController {
    
//    lazy var backdropView: UIView = {
//        let bdView = UIView(frame: self.view.bounds)
//        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
//        return bdView
//    }()
    
    private let backdropView = UIView()
    let contentView = UIView()
    var height: CGFloat = 0  //UIScreen.main.bounds.height / 1.5
    var isPresenting = false
    
    init(height: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
        let maxHeight: CGFloat = UIScreen.main.bounds.height - 64
        self.height = (maxHeight > height) ? height : maxHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        backdropView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.addSubview(backdropView)
        
        backdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backdropView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .yellow
        view.addSubview(contentView)

        let contentHeight = contentView.heightAnchor.constraint(equalToConstant: height)
        contentHeight.identifier = "height"
        contentHeight.isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        contentView.constraints.forEach { constraint in
            if constraint.identifier == "height" {
                constraint.isActive = false
                let newMaxHeight: CGFloat = size.height - 64
                let newHeight = contentView.heightAnchor.constraint(equalToConstant: (newMaxHeight > self.height) ? self.height : newMaxHeight)
                newHeight.identifier = "height"
                newHeight.isActive = true            }
        }
    }
}

extension HalfModalViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            contentView.frame.origin.y += height
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.contentView.frame.origin.y -= self.height
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.contentView.frame.origin.y += self.height
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
