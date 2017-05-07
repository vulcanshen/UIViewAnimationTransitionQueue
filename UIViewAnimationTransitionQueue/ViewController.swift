//
//  ViewController.swift
//  UIViewAnimationTransitionQueue
//
//  Created by shenyun on 2017/5/7.
//  Copyright © 2017年 shenyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vBlock: UIView!
    
    var originFrame: CGRect?
    var miniFrame: CGRect?
    var largeFrame: CGRect?
    var ivEmoji: UIImageView = UIImageView(image: "😁".image())
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ivEmoji.frame = CGRect(origin: CGPoint.zero, size: vBlock.bounds.size)
        originFrame = vBlock.frame
        miniFrame = CGRect(origin: CGPoint(x:vBlock.frame.origin.x+vBlock.bounds.width/4, y: vBlock.frame.origin.y+vBlock.bounds.height/4), size: CGSize(width: vBlock.bounds.width/2,height: vBlock.bounds.height/2))
        largeFrame = CGRect(origin: CGPoint(x:vBlock.frame.origin.x-vBlock.bounds.width/2, y: vBlock.frame.origin.y-vBlock.bounds.height/2), size: CGSize(width: vBlock.bounds.width*2, height: vBlock.bounds.height*2))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAnim(sender: UIBarButtonItem) {
        UIView.animationQ
            .add {
                self.vBlock.frame = self.miniFrame!
            }.add(duration: 3, dampingRatio: 0.1, velocity: 1) {
                self.vBlock.frame = self.largeFrame!
            }.add(duration: 2) {
                self.vBlock.frame = self.miniFrame!
            }.done {
                print("pausing 3 secs")
            }
            .pause(3)
            .done {
                print("pause end")
            }
            .add {
                self.vBlock.frame = self.originFrame!
            }.done {
                print("ani end")
            }.start()
    }
    
    @IBAction func startTrans(sender: UIBarButtonItem) {
        UIView.transitionQ
            .add(vBlock, toView: nil, options: .transitionFlipFromBottom) {
                self.vBlock.addSubview(self.ivEmoji)
            }.done {
                print("pausing 3 secs")
            }
            .pause(3)
            .done {
                print("pause end")
            }
            .add(vBlock, toView: nil, options: .transitionFlipFromTop) {
                self.ivEmoji.removeFromSuperview()
            }.done {
                print("transition end")
            }.start()
    }
    
    @IBAction func startBoth(sender: UIBarButtonItem) {
        UIView.transformQ
            .addTrans(vBlock, toView: nil, options: .transitionFlipFromBottom) {
                self.vBlock.addSubview(self.ivEmoji)
            }.addAnim {
                self.vBlock.frame = self.largeFrame!
                self.ivEmoji.frame = CGRect(origin: CGPoint.zero, size:self.largeFrame!.size)
            }.done {
                print("pausing 2 sec")
            }.pause(2)
            .done {
                print("pause end")
            }.addTrans(vBlock, toView: nil,options: .transitionFlipFromTop){
                self.ivEmoji.removeFromSuperview()
                self.ivEmoji.frame = CGRect(origin: CGPoint.zero, size: self.originFrame!.size)
            }.addAnim {
                self.vBlock.frame = self.originFrame!
            }.done {
                print("all end")
            }.start()
    }
}


extension String {
    func image() -> UIImage {
        
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        let attribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 30),
            NSParagraphStyleAttributeName: textStyle
        ]
        (self as NSString).draw(in: rect, withAttributes: attribute)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

