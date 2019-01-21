//
//  CMTime.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/11.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import Foundation
import AVKit
extension CMTime{
    func toReadableTime() -> String{
        if CMTimeGetSeconds(self).isNaN{
            return "--:--"
        }
        let totalSecond = Int(CMTimeGetSeconds(self))
        let second = totalSecond % 60
        let minite = totalSecond / 60
        let hour = minite / 60
        let timeFormatter = String(format: "%02d:%02d:%02d", hour,minite,second)
        return timeFormatter
    }
}
