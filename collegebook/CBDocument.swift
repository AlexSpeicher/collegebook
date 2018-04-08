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
    var thumbnail: UIImage? 
    
    override func contents(forType typeName: String) throws -> Any {
        return cbfile?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            cbfile = CBFile(json: json)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocumentSaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }
}
