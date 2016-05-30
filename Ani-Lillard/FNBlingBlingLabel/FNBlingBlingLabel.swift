//
//  FNBlingBlingLabel.swift
//  Ani-Lillard
//
//  Created by Fnoz on 16/5/30.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit

public class FNBlingBlingLabel: UILabel{
    public var appearDuration = 3.0
    public var disappearDuration = 3.0
    public var attributedString:NSMutableAttributedString?
    
    var displaylink:CADisplayLink?
    var isAppearing:Bool = false
    var isDisappearing:Bool = false
    var isDisappearing4ChangeText:Bool = false
    var beginTime:CFTimeInterval?
    var endTime:CFTimeInterval?
    var durationArray:NSMutableArray?
    var lastString:NSString?
    
    override public var text: String? {
        get {
            
            return self.attributedString?.string
        }
        
        set {
            self.convertToAttributedString(newValue!)
        }
    }
    
    public func convertToAttributedString(text: NSString) {
        lastString = text
        if self.attributedText?.length > 0 {
            disappear()
            isDisappearing4ChangeText = true
        }
        else {
            appear()
        }
    }
    
    public func appear() {
        attributedString = NSMutableAttributedString.init(string: lastString! as String)
        isAppearing = true
        beginTime = CACurrentMediaTime()
        endTime = CACurrentMediaTime() + appearDuration
        displaylink?.paused = false
        
        durationArray = NSMutableArray.init(array: [])
        for(var i = 0; i < self.attributedString?.length ; i += 1) {
            let progress: CGFloat = 1 - (1 - CGFloat(arc4random_uniform(100))/100.0)/1.3
            durationArray?.addObject(progress*CGFloat(appearDuration))
        }
    }
    
    public func disappear() {
        isDisappearing = true
        beginTime = CACurrentMediaTime()
        endTime = CACurrentMediaTime() + appearDuration
        displaylink?.paused = false
        
        durationArray = NSMutableArray.init(array: [])
        for(var i = 0; i < self.attributedString?.length ; i += 1) {
            let progress: CGFloat = 1 - (1 - CGFloat(arc4random_uniform(100))/100.0)/1.3
            durationArray?.addObject(progress*CGFloat(disappearDuration))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initVariable()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initVariable() {
        displaylink = CADisplayLink.init(target: self, selector: #selector(updateAttributedString))
        displaylink?.paused = true
        displaylink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func updateAttributedString() {
        let pastDuration = CACurrentMediaTime() - beginTime!
        if isAppearing {
            if pastDuration>appearDuration {
                displaylink?.paused = true
                isAppearing = false
            }
            for(var i = 0; i < self.attributedString?.length ; i += 1) {
                var progress:CGFloat = CGFloat(pastDuration) / (durationArray![i] as! CGFloat)
                if progress>1 {
                    progress = 1
                }
                let color = self.textColor.colorWithAlphaComponent(progress)
                attributedString?.addAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(i, 1))
            }
        }
        if isDisappearing {
            if pastDuration>disappearDuration {
                displaylink?.paused = true
                isDisappearing = false
                if isDisappearing4ChangeText {
                    isDisappearing4ChangeText = false
                    appear()
                }
                return
            }
            for(var i = 0; i < self.attributedString?.length ; i += 1) {
                var progress:CGFloat = CGFloat(pastDuration) / (durationArray![i] as! CGFloat)
                if progress>1 {
                    progress = 1
                }
                let color = self.textColor.colorWithAlphaComponent(1 - progress)
                attributedString?.addAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(i, 1))
            }
        }
        attributedText = attributedString
    }
}