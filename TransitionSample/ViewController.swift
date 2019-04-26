//
//  ViewController.swift
//  TransitionSample
//
//  Created by SHINGAI YOSHIMI on 2019/01/22.
//  Copyright © 2019 SHINGAI YOSHIMI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func show() {
        let container = storyboard?.instantiateViewController(withIdentifier: "ContainerViewController")
        let vc = SheetViewController(childViewController: container!)
        present(vc, animated: true, completion: nil)
    }
}

