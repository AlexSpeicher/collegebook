//
//  EmojiCollectionViewCell.swift
//  collegebook
//
//  Created by Alex Speicher on 2/7/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class DocumentCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var selectedMode: UILabel!
    @IBOutlet weak var label: UILabel!
    var cellPosition: Int?
    var selcectionMode: Bool?
    var gotSelected = false
    
    var delegate: DocumentCollectionViewCellDelegate?
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(20.0))
    }
    
    @IBAction func openFile(_ sender: UIButton) {
        if self.selcectionMode!{
            if !gotSelected {
                self.selectedMode.text = "✓"
                self.selectedMode.textColor = UIColor.orange
                self.gotSelected = true
            } else {
                self.selectedMode.text = "◎"
                self.selectedMode.textColor = UIColor.black
                self.gotSelected = false
            }
        }
        delegate?.returnObjectPosition(atIndex: cellPosition!)
    }
    
    
    func displayContent(name: NSAttributedString, mode: Bool){
        let name = NSAttributedString(string: fileURLs[indexPath.item].deletingPathExtension().lastPathComponent, attributes: [.font:font])
        label.attributedText = name
        self.selcectionMode = mode
        self.selectedMode.text = "◎"
        self.selectedMode.isHidden = !mode
        
        /*if self.selcectionMode == false {
            
        }*/
    }
}

