//
//  SHProgressView.swift
//  SwiftNewProject
//
//  Created by lalala on 2017/5/10.
//  Copyright © 2017年 lsh. All rights reserved.
//

import UIKit

class SHProgressView: UIView {
    
    //进度
    var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //半径默认 50
    var radius: CGFloat = 50
    //线宽
    var lineWidth: CGFloat = 3
    //背景圆颜色
    var trackColor = UIColor(red: 0.843, green: 0.843, blue: 0.843, alpha: 1)
    //进度条颜色
    var progressColor = UIColor(red: 0.122, green: 0.729, blue: 0.949, alpha: 0.8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
         //背景
        let trackPath = UIBezierPath(arcCenter: CGPoint.init(x: radius, y: radius), radius: radius - lineWidth, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(M_PI * 2), clockwise: true)
        trackPath.lineWidth = lineWidth
        trackColor.setStroke()
        trackPath.stroke()
        
        //进度
        let endAngle = CGFloat(M_PI * 2) * progress
        let progressPath = UIBezierPath(arcCenter: CGPoint.init(x: radius, y: radius), radius: radius - lineWidth, startAngle: CGFloat(-M_PI_2), endAngle: endAngle, clockwise: true)
        progressPath.lineWidth = lineWidth
        progressPath.lineCapStyle = CGLineCap.round
        progressColor.setStroke()
        progressPath.stroke()
    }
    
}
