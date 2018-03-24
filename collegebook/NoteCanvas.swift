//
//  NotePad.swift
//  collegebook
//
//  Created by Alex Speicher on 1/13/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class NoteCanvas: UIView {
    var strokePaths = [[CBFile.Stroke]()]
    var removedStrokes = [[CBFile.Stroke]()]
    var index = 0
    
    var background: UIColor? {
        didSet {
            self.backgroundColor = background
            print("Set Document Background")
        }
    }
    
    override init(frame : CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Stroke variables
    var strokeSize: Float = 5.0
    var strokeOpacity: Float = 1.0
    var strokeColorHex: Int = 0x000000
    
    var touchPoint: CGPoint!
    var touchForce: Float!
    var lowestYPoint: CGFloat = 0.0
    
    var delegate: DocumentScrollViewDelegate?

    /*
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let isStylus = touch?.type == .stylus
        if isStylus {
            delegate?.changeScrolling()
            /*
            touchPoint = touch?.location(in: self)
            touchForce = Float(touch!.force)
            let stroke = CBFile.Stroke(strokePoint: touchPoint, strokeColorHex: strokeColorHex, strokeSize: strokeSize * touchForce, strokeOpacity: strokeOpacity)
            strokePaths[strokePaths.endIndex - 1].append(stroke)
            print(strokePaths)
            self.setNeedsDisplay()
            //print(touchForce)
            */
        }
 
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let isStylus = touch?.type == .stylus
        if isStylus {
            touchPoint = touch?.location(in: self)
            touchForce = Float(touch!.force)
            let stroke = CBFile.Stroke(strokePoint: touchPoint, strokeColorHex: strokeColorHex, strokeSize: strokeSize * touchForce, strokeOpacity: strokeOpacity)
            strokePaths[strokePaths.endIndex - 1].append(stroke)
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let isStylus = touch?.type == .stylus
        if isStylus {
            strokePaths.append([CBFile.Stroke]())
            delegate?.changeScrolling()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for path in strokePaths {
            if path.count >= 1 {
                context!.beginPath()
                context?.move(to: path[0].strokePoint)
                for strokes in path{
                    context!.setLineWidth(CGFloat(strokes.strokeSize))
                    context!.setStrokeColor(UIColor(rgb: strokes.strokeColorHex).withAlphaComponent(CGFloat(strokes.strokeOpacity)).cgColor)
                    context!.setLineCap(.round)
                    context?.addLine(to: strokes.strokePoint)
                }
                context!.strokePath()
            }
            //image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()

    }

    func clearCanvas(){
        if(index >= 0){
            strokePaths = [[CBFile.Stroke]()]
            self.setNeedsDisplay()
        }
    }
    
    func undo(){
        if strokePaths.count > 1{
            removedStrokes.append(strokePaths.last!)
            strokePaths.removeLast()//(at: (strokePaths.count - 1))
            self.setNeedsDisplay()
        }
    }
    
    func redo(){
        if removedStrokes.count > 1{
            strokePaths.append(removedStrokes.last!)
            removedStrokes.removeLast()
            self.setNeedsDisplay()
        }
    }

}

public extension UIImage {
    public convenience init?(Pattern: String, BackgroundColor: UIColor, GuidesColor: UIColor, Scale: Float) {
        var Patternrect: CGRect!
        var DrawPath =  [CGPoint]()
        
        switch Pattern {
            case "Hex":
                Patternrect = CGRect(origin: .zero, size: CGSize(width: 17.32052, height: 30))
                DrawPath = [CGPoint(x: 17.32052, y: 7.5),CGPoint(x: 12.99038, y: 5),CGPoint(x: 12.99038, y: 0),CGPoint(x: 12.99038, y: 5),CGPoint(x: 4.33013, y: 10),CGPoint(x: 0, y: 7.5),CGPoint(x: 4.33013, y: 10),CGPoint(x: 4.33013, y: 20),CGPoint(x: 0, y: 22.5),CGPoint(x: 4.33013, y: 20),CGPoint(x: 12.99038, y: 25),CGPoint(x: 12.99038, y: 30),CGPoint(x: 12.99038, y: 25),CGPoint(x: 17.32052, y: 22.5)]
            case "Graph":
                Patternrect = CGRect(origin: .zero, size: CGSize(width: 25, height: 25))
                DrawPath = [CGPoint(x: 0, y: 12.5),CGPoint(x: 25, y: 12.5),CGPoint(x: 12.5, y: 12.5),CGPoint(x: 12.5, y: 0),CGPoint(x: 12.5, y: 25)]
            case "Ruled":
                Patternrect = CGRect(origin: .zero, size: CGSize(width: 50, height: 25))
                DrawPath = [CGPoint(x: 0, y: 25),CGPoint(x: 50, y: 25)]
            default:
                print( "default case")
        }
        UIGraphicsBeginImageContextWithOptions(Patternrect.size, false, 0.0)
        let Patternpath = UIBezierPath()
        Patternpath.move(to: DrawPath[0])
        for Point in DrawPath[1...] {
            Patternpath.addLine(to: Point)
        }
        BackgroundColor.setFill()
        UIRectFill(Patternrect)
        GuidesColor.setStroke()
        Patternpath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

