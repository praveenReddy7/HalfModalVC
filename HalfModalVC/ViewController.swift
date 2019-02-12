//
//  ViewController.swift
//  HalfModalVC
//
//  Created by praveen reddy on 1/26/19.
//  Copyright © 2019 praveen reddy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped(_:)))
        self.navigationItem.rightBarButtonItem = add
    }

    
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        let vc = HalfModalViewController(height: 1000)
        present(vc, animated: true, completion: nil)
    }
    
    

}
