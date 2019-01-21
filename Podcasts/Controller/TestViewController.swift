//
//  TestViewController.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/9.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
import Lottie
class TestViewController: UIViewController {
    
    lazy var box = UIView()
    let animationView = LOTAnimationView(name: "favorite_black")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.box.backgroundColor = UIColor.lightGray
        self.view.addSubview(box)
        box.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(view)
            make.center.equalTo(self.view)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        tap.delegate = self as! UIGestureRecognizerDelegate // This is not required
        box.addGestureRecognizer(tap)
        
        
        self.box.addSubview(animationView)
        animationView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
            make.center.equalTo(self.box)
        }
        animationView.contentMode = UIView.ContentMode.scaleAspectFill
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        animationView.play(fromProgress: 0.25, toProgress: 0.5, withCompletion: nil)

    }
    
}
