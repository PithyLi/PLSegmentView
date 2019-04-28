//
//  ViewController.swift
//  PLSegmentView
//
//  Created by Jayz Zz on 2019/4/28.
//  Copyright © 2019 Pithy'L. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = SegmentViewController()
        self.addChild(vc)
        self.view.addSubview(vc.view)
        // Do any additional setup after loading the view.
    }


}

