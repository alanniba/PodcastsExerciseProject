//
//  PlayerDetailView+Gesture.swift
//  Podcasts
//
//  Created by haoyuan tan on 2018/11/15.
//  Copyright © 2018年 haoyuan tan. All rights reserved.
//

import UIKit
extension PlayerDetialView{
    func handleGestureEnd(gesture : UIPanGestureRecognizer){
        let transform = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if transform.y < -200 || velocity.y < -500{
                UIApplication.mainTabBar().maxmizePlayerDetailView(episode: nil)
                
            } else {
                self.minimizedView.alpha = 1
                self.maxmizeStackView.alpha = 0
            }
        })
    }
    
    @objc func handleMaxmize(){
        UIApplication.mainTabBar().maxmizePlayerDetailView(episode: nil)
    }
    
    func handleGestureChange(gesture : UIPanGestureRecognizer){
        let transform = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: transform.y)
        self.minimizedView.alpha = 1 + transform.y / 200
        self.maxmizeStackView.alpha = -transform.y / 200
    }
    
    @IBAction func handleDismiss(_ sender: Any) {

        
        UIApplication.mainTabBar().minimizePlayerDetailView()
        
    }
    
    @objc func handleMaxStackView(gesture : UIPanGestureRecognizer){
        
        if gesture.state == .changed{
            let transforming = gesture.translation(in: superview)
            maxmizeStackView.transform = CGAffineTransform(translationX: 0, y: transforming.y)
        } else if gesture.state == .ended{
            let transforming = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maxmizeStackView.transform = .identity
                
                if transforming.y > 200{
                    
                    UIApplication.mainTabBar().minimizePlayerDetailView()
                }
                
                
            })
        }
    }

}
