//
//  CBDocument.swift
//  collegebook
//
//  Created by Alex Speicher on 2/4/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class CBDocument: UIDocument {
    
    var cbfile: CBFile?
    
    override func contents(forType typeName: String) throws -> Any {
        return cbfile?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            cbfile = CBFile(json: json)
        }
    }
    
    
}
