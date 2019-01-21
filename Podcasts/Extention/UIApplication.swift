//
//  UIApplication.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/15.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
extension UIApplication{
    static func mainTabBar () -> MainTabBarViewController{
        return shared.keyWindow?.rootViewController as! MainTabBarViewController
    }
}
