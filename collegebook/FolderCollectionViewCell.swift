//
//  FolderCollectionViewCell.swift
//  collegebook
//
//  Created by Alex Speicher on 3/26/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectionIndicator: UIButton!
    @IBOutlet weak var label: UILabel!
    var cellPosition: Int?
    var selcectionMode: Bool?
    var delegate: DocumentCollectionViewCellDelegate?
    
    @IBAction func openFile(_ sender: UIButton) {
        delegate?.returnObjectPosition(atIndex: cellPosition!)
    }
    
    @IBAction func selectThisCell(_ sender: UIButton) {
        print("Hello")
    }
    
    
    func displayContent(name: NSAttributedString, mode: Bool){
        label.attributedText = name
        self.selcectionMode = mode
        selectionIndicator.isHidden = !mode
        /*if self.selcectionMode == false {
         
         }*/
    }
}
