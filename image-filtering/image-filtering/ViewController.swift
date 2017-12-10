//
//  ViewController.swift
//  image-filtering
//
//  Created by Leo Thomas on 17.11.17.
//  Copyright © 2017 Leonard Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let image = #imageLiteral(resourceName: "Camel.jpg")

        let result = image.convolve(with: .gaussian(size: 1001, sigma: 101 / 6))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
