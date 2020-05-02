//
//  CircularProgressBar.swift
//  SensorsAssignment
//
//  Created by Yael Bilu Eran on 02/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation
import UIKit

class CircularProgressBar: UIView {

    // MARK: Properties
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var backgroundLayer = CAShapeLayer()
    fileprivate var progressLable = CenterTextLayer()
    var startProgress:Int = 0
    var suffix = "%"
    var font = UIFont (name: "Helvetica Neue", size: 12)
    var reverse = false {
        didSet{
            if reverse{
                let color = backgroundLayer.strokeColor
                backgroundLayer.strokeColor = progressLayer.strokeColor
                progressLayer.strokeColor = color
            }
            
        }
    }
    
    var progress: Int = 0 {
        didSet {
            progressLable.string = "\(progress) \(suffix)"
        }
    }
    
    /// A UIColor value that contains the color of progress line.
    var progressColor: UIColor = .orange {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
            progressLable.foregroundColor = progressColor.cgColor
        }
    }
    
    /// A UIColor value that contains the background color of line.
    var backgroundProgressLayer: UIColor = .lightGray {
        didSet {
            progressLayer.strokeColor = backgroundProgressLayer.cgColor
        }
    }
    
    /// A CGFloat value that constains the width of progress line.
    var lineWidth: CGFloat = 8.0 {
        didSet {
            progressLayer.lineWidth = lineWidth
        }
    }
    
    /// A CAShapeLayerLineCap value that constains the line cap of progress line.
    var lineCap: CAShapeLayerLineCap = .round {
        didSet {
            progressLayer.lineCap = lineCap
        }
    }
    
    /// A TimeInterval value that constains the animation duration.
    var animationDuration: TimeInterval = 0.3
    
    /// A CAMediaTimingFunctionName value that contains the name of timing function.
    var timingFunctionName: CAMediaTimingFunctionName = .easeOut
    
    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSublayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSublayers()
    }
    
    // MARK: Setter
    
    func setProgress(to value: Int) {
        if value > 100 { progress = 100 }
        else if value < 0 { progress = 0 }
        else {
            startProgress = progress
            progress = value }
        createAnimation()
    }

    // MARK: Create layers
    
    fileprivate func createSublayers() {
        backgroundColor = .clear
        
        let centerX = frame.size.width / 2
        let centerY = frame.size.height / 2
        
        let startAngle = -CGFloat.pi / 2.0
        let endAngle: CGFloat = 2 * CGFloat.pi + startAngle
        
        let progressPath = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY),
                                        radius: min(frame.size.height,frame.size.width) / 2,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
        
        backgroundLayer.path = progressPath.cgPath
        backgroundLayer.strokeColor = backgroundProgressLayer.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = lineWidth
        layer.addSublayer(backgroundLayer)
        
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd  = 0
        progressLayer.lineCap = lineCap
        layer.addSublayer(progressLayer)

        progressLable.backgroundColor = backgroundColor?.cgColor
        progressLable.foregroundColor = progressColor.cgColor
        progressLable.frame = layer.bounds
        progressLable.alignmentMode = .center
        progressLable.fontSize = 18.0
        //progressLable.font = font
        layer.addSublayer(progressLable)
    }
    
    fileprivate func createAnimation() {
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.fromValue = Double(startProgress) / 100.0
        progressAnimation.toValue = Double(progress) / 100.0
        progressAnimation.duration = animationDuration
        progressAnimation.timingFunction = .init(name: timingFunctionName)
        progressLayer.strokeEnd = CGFloat(progress) / 100.0
        progressLayer.add(progressAnimation, forKey: nil)
    }
    
}

class CenterTextLayer: CATextLayer {
    override open func draw(in ctx: CGContext) {
        let yDiff: CGFloat
        let fontSize: CGFloat
        let height = self.bounds.height

        if let attributedString = self.string as? NSAttributedString {
            fontSize = attributedString.size().height
            yDiff = (height-fontSize)/2
        } else {
            fontSize = self.fontSize
            yDiff = (height-fontSize)/2 - fontSize/10
        }

        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
}
