//
//  Utilities.swift
//  collegebook
//
//  Created by Alex Speicher on 2/19/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
extension String {
    func madeUnique(withRespectTo otherStrings: [String]) -> String {
        var possiblyUnique = self
        var uniqueNumber = 1
        while otherStrings.contains(possiblyUnique) {
            possiblyUnique = self + " \(uniqueNumber)"
            uniqueNumber += 1
        }
        return possiblyUnique
    }
}

//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
