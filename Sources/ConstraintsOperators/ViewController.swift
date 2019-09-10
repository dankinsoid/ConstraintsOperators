//
//  ViewController.swift
//  TestProject
//
//  Created by Daniil on 05.09.2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let red = UIView()
    let blue = UIView()
    let green = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        red.backgroundColor = .red
        blue.backgroundColor = .blue
        green.backgroundColor = .green
//        Axis.vertical   =| [0, red, 8, blue, 16, green.fixed(100), ...]
        Axis.horizontal =| [8, [red, blue, green], 8, red.layout.centerX]
        
        red.layout.width.priority(.defaultLow).equal(to: blue.layout.width * 2 - 1)
        red.layout.width.less(than: 345)
        red.layout.width.deactivated.greater(than: blue.layout.width / 2)
        red.layout.height.equal(to: blue)
        red.layout.height.priority(10).within(0...10)
        
        [red, blue].layout.edges(.vertical).equal(to: 0)
        [red, blue].layout.edges(.horizontal).equal(to: view)
        
        
        red.layout.width.priority(.defaultLow) =| blue.layout.width * 2 - 1
        red.layout.width <=| 345
        red.layout.width.deactivated >=| blue.layout.width / 2
        red.layout.height =| blue
        red.layout.height.priority(10) =| 0...10
        
        [red, blue].layout.edges(.vertical) =| 0
        [red, blue].layout.edges(.horizontal) =| view
        
        // Do any additional setup after loading the view.
    }

}
