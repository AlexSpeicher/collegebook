//
//  StrokeSettings.swift
//  collegebook
//
//  Created by Alex Speicher on 1/18/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class StrokeSettings: UIView {
    
    var StrokeSize: CGFloat!
    var StrokeOpacity: CGFloat!
    var strokeColorHex: Int!
    
    let colors: [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.black, UIColor.white]
    
    let hexColors: [Int] = [0x890500, 0xff5100, 0xffe700, 0x43a24b, 0x0f3374, 0xD10FDA, 0x000000, 0xFFFFFF]
    
    override func draw(_ rect: CGRect){
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: StrokeSize!/2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        UIColor(rgb: strokeColorHex).withAlphaComponent(StrokeOpacity).setFill()
        path.fill()
    }
    
    func updateSettingsIndicator(_ StrokeValue: Float, _ opacityValue: Float) -> Int{
        StrokeSize = CGFloat(StrokeValue)
        StrokeOpacity = CGFloat(opacityValue)
        
        self.setNeedsDisplay()
        return strokeColorHex
    }
    
    func updateStrokeColor(at index: Int){
        strokeColorHex = (hexColors[index])
    }
}

public extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF)/255,
            green: CGFloat((rgb >> 8) & 0xFF)/255,
            blue: CGFloat(rgb & 0xFF)/255,
            alpha: 1.0
        )
    }
}


