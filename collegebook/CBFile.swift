//
//  Document.swift
//  collegebook
//
//  Created by Alex Speicher on 1/20/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import Foundation
import UIKit

struct CBFile: Codable {
    var Strokes = [[Stroke]()]
    //var Background: backgroundSettings
    var DocumentCanvasSize: CGSize
    
    /*
    struct backgroundSettings: Codable {
        let type: String
        let sizeRatio: Float
        let backgroundColor: UIColor //Must be a string
        let GuidesColor: UIColor    //Must be a string
    }
     */
    struct Stroke: Codable {
        let strokePoint: CGPoint
        let strokeColorHex: Int    //Must be a string
        let strokeSize: Float
        let strokeOpacity: Float
        //let strokeShape:
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(CBFile.self, from: json){
            self = newValue
            print("was able to decode")
        } else {
            print("was NOT able to decode")
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }

    init(Strokes: [[Stroke]], DocumentCanvasSize: CGSize) { //, Background: backgroundSettings
        self.Strokes = Strokes
        //self.Background = Background
        self.DocumentCanvasSize = DocumentCanvasSize
    }

    
}
