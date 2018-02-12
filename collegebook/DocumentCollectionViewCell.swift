//
//  EmojiCollectionViewCell.swift
//  collegebook
//
//  Created by Alex Speicher on 2/7/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class DocumentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    var cellPosition: Int?
    var delegate: DocumentCollectionViewCellDelegate?
    
    @IBAction func openFile(_ sender: UIButton) {
        delegate?.openDocument(atIndex: cellPosition!)
    }
    
    func displayContent(name: NSAttributedString){
        label.attributedText = name
    }
}

