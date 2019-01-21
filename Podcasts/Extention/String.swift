//
//  String.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/6.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import Foundation
extension String{
    func toSecureHTTPS() -> (String){
        return self.contains("http") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
