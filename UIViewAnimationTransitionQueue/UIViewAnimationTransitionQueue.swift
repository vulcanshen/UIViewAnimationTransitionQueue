//
//  UIViewAnimationTransitionQueue.swift
//  UIViewAnimationTransitionQueue
//
//  Created by shenyun on 2017/5/7.
//  Copyright © 2017年 shenyun. All rights reserved.
//


import UIKit

class UIViewTransformQueue {
    var transforms: [TransFormInfo] = []
    
    enum TransFromType {
        case Animation, Transition, TransitionFromViewToView, Pause
    }
    
    class TransFormInfo {
        // common
        let duration: TimeInterval
        
        // action
        var animation: (() -> Void)?
        var options: UIViewAnimationOptions?
        // animation
        var delay: TimeInterval = 0
        var dampingRatio: CGFloat = 1
        var velocity: CGFloat = 0
        // transition
        var fromView: UIView?
        var toView: UIView?
        
        let type: TransFromType
        
        var completionCall: [(() -> Void)] = []
        // for pause
        init(duration: TimeInterval, _ type: TransFromType = .Pause) {
            self.duration = duration
            self.type = type
        }
        
        // for animation
        convenience init(duration: TimeInterval, animation: @escaping () -> Void, options: UIViewAnimationOptions, delay: TimeInterval, dampingRatio: CGFloat, velocity: CGFloat) {
            self.init(duration: duration, .Animation)
            self.animation = animation
            self.options = options
            self.delay = delay
            self.dampingRatio = dampingRatio
            self.velocity = velocity
        }
        
        // for transition
        
        convenience init(fromView: UIView, toView: UIView?, duration: TimeInterval, animation: @escaping () -> Void, options: UIViewAnimationOptions) {
            self.init(duration: duration, (toView == nil) ? .Transition : .TransitionFromViewToView)
            self.fromView = fromView
            self.toView = toView
            self.animation = animation
            self.options = options
        }
        
    }
    
    func addAnim(duration: TimeInterval = 1, options: UIViewAnimationOptions = [], delay: TimeInterval = 0, dampingRatio: CGFloat = 1, velocity: CGFloat = 0, _ animation: @escaping ()->Void) -> UIViewTransformQueue {
        transforms.append(TransFormInfo(duration: duration, animation: animation, options: options, delay: delay, dampingRatio: dampingRatio, velocity: velocity))
        return self
    }
    
    func addTrans(_ fromView: UIView, toView: UIView?, duration: TimeInterval = 1, options: UIViewAnimationOptions = [], _ animation: @escaping () -> Void) -> UIViewTransformQueue {
        transforms.append(TransFormInfo(fromView: fromView, toView: toView, duration: duration, animation: animation, options: options))
        return self
    }
    
    func pause(_ duration: TimeInterval = 1) -> UIViewTransformQueue {
        transforms.append(TransFormInfo(duration: duration))
        return self
    }
    
    func done(_ somethingToDo: @escaping () -> Void) -> UIViewTransformQueue {
        transforms.last?.completionCall.append(somethingToDo)
        return self
    }
    
    @objc func start() {
        if transforms.count > 0 {
            let transform = transforms.removeFirst()
            switch transform.type {
            case .Animation:
                UIView.animate(withDuration: transform.duration, delay: transform.delay, usingSpringWithDamping: transform.dampingRatio, initialSpringVelocity: transform.velocity, options: transform.options!
                    , animations: transform.animation!, completion: { (complete) in
                        if complete {
                            for call in transform.completionCall {
                                call()
                            }
                            self.start()
                        }
                })
                break
            case .Transition:
                UIView.transition(with: transform.fromView!, duration: transform.duration, options: transform.options!, animations: transform.animation, completion: { (completed) in
                    if completed {
                        for call in transform.completionCall {
                            call()
                        }
                        self.start()
                    }
                })
                break
            case .TransitionFromViewToView:
                UIView.transition(from: transform.fromView!, to: transform.toView!, duration: transform.duration, options: transform.options!, completion: { (completed) in
                    if completed {
                        for call in transform.completionCall {
                            call()
                        }
                        self.start()
                    }
                })
                break
            case .Pause:
                Timer.scheduledTimer(withTimeInterval: transform.duration, repeats: false, block: { (timer) in
                    timer.invalidate()
                    for call in transform.completionCall {
                        call()
                    }
                    self.start()
                })
                break
            }
        }
    }
}

class UIViewAnimationQueue {
    var animations: [AnimationInfo] = []
    
    enum AnimationType {
        case Normal, Pause
    }
    
    class AnimationInfo {
        let duration: TimeInterval
        var animation: (() -> Void)?
        var options: UIViewAnimationOptions?
        var delay: TimeInterval = 0
        var dampingRatio: CGFloat = 1
        var velocity: CGFloat = 0
        let type: AnimationType
        var completionCall: [(() -> Void)] = []
        
        
        // for pause
        init(duration: TimeInterval, _ type: AnimationType = .Pause) {
            self.duration = duration
            self.type = type
        }
        
        // for animation
        convenience init(duration: TimeInterval, options: UIViewAnimationOptions, delay: TimeInterval, dampingRatio: CGFloat, velocity: CGFloat, animation: @escaping () -> Void) {
            self.init(duration: duration, .Normal)
            self.options = options
            self.delay = delay
            self.dampingRatio = dampingRatio
            self.velocity = velocity
            self.animation = animation
        }
    }
    
    func done(_ somethingToDo: @escaping () -> Void) -> UIViewAnimationQueue {
        animations.last?.completionCall.append(somethingToDo)
        return self
    }
    
    func add(duration: TimeInterval = 1, options: UIViewAnimationOptions = [], delay: TimeInterval = 0, dampingRatio: CGFloat = 1, velocity: CGFloat = 0, _ animation: @escaping () -> Void) -> UIViewAnimationQueue {
        animations.append(AnimationInfo(duration: duration, options: options, delay: delay, dampingRatio: dampingRatio, velocity: velocity, animation: animation))
        return self
    }
    
    func pause(_ duration: TimeInterval = 1) -> UIViewAnimationQueue {
        animations.append(AnimationInfo(duration: duration))
        return self
    }
    
    @objc func start() {
        if animations.count > 0 {
            let ani = animations.removeFirst()
            switch ani.type {
            case .Normal:
                UIView.animate(withDuration: ani.duration, delay: ani.delay, usingSpringWithDamping: ani.dampingRatio, initialSpringVelocity: ani.velocity, options: ani.options!, animations: ani.animation!, completion: { (complete) in
                    if complete {
                        for call in ani.completionCall {
                            call()
                        }
                        self.start()
                    }
                })
                break
            case .Pause:
                Timer.scheduledTimer(withTimeInterval: ani.duration, repeats: false, block: { (timer) in
                    timer.invalidate()
                    for call in ani.completionCall {
                        call()
                    }
                    self.start()
                })
                break
            }
            
        }
    }
}

class UIViewTransitionQueue {
    var transitions: [TransitionInfo] = []
    
    enum TransitionInfoType {
        case Normal, FromViewToView, Pause
    }
    
    class TransitionInfo {
        var fromView: UIView?
        var toView: UIView?
        let duration: TimeInterval
        var options: UIViewAnimationOptions?
        var animation: (() -> Void)?
        let type: TransitionInfoType
        
        var completionCall: [(() -> Void)] = []
        
        init(duration: TimeInterval, _ type: TransitionInfoType = .Pause) {
            self.duration = duration
            self.type = type
        }
        convenience init(duration: TimeInterval, fromView: UIView, toView: UIView?, options: UIViewAnimationOptions, animation: @escaping () -> Void) {
            self.init(duration: duration, (toView == nil) ? .Normal : .FromViewToView)
            self.fromView = fromView
            self.options = options
            self.animation = animation
        }
        
    }
    
    func done(_ somethingToDo: @escaping () -> Void) -> UIViewTransitionQueue {
        transitions.last?.completionCall.append(somethingToDo)
        return self
    }
    
    func add(_ fromView: UIView, toView: UIView?, duration: TimeInterval = 1, options: UIViewAnimationOptions = [], _ animation: @escaping () -> Void) -> UIViewTransitionQueue {
        transitions.append(TransitionInfo(duration: duration, fromView: fromView, toView: toView, options: options, animation: animation))
        return self
    }
    
    func pause(_ duration: TimeInterval = 1) -> UIViewTransitionQueue {
        transitions.append(TransitionInfo(duration: duration))
        return self
    }
    
    @objc func start() {
        if transitions.count > 0 {
            let trans = transitions.removeFirst()
            switch trans.type {
            case .Normal:
                UIView.transition(with: trans.fromView!, duration: trans.duration, options: trans.options!, animations: trans.animation!, completion: { (completed) in
                    if completed {
                        for call in trans.completionCall {
                            call()
                        }
                        self.start()
                    }
                })
                break
            case .FromViewToView:
                UIView.transition(from: trans.fromView!, to: trans.toView!, duration: trans.duration, options: trans.options!, completion: { (completed) in
                    if completed {
                        for call in trans.completionCall {
                            call()
                        }
                        self.start()
                    }
                })
                break
            case .Pause:
                Timer.scheduledTimer(withTimeInterval: trans.duration, repeats: false, block: { (timer) in
                    timer.invalidate()
                    for call in trans.completionCall {
                        call()
                    }
                    self.start()
                })
                break
            }
        }
    }
}

extension UIView {
    class var animationQ: UIViewAnimationQueue {
        get {
            return UIViewAnimationQueue()
        }
    }
    class var transitionQ: UIViewTransitionQueue {
        get {
            return UIViewTransitionQueue()
        }
    }
    class var transformQ: UIViewTransformQueue {
        get {
            return UIViewTransformQueue()
        }
    }
}
