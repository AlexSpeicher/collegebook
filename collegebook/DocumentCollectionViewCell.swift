//
//  EmojiCollectionViewCell.swift
//  collegebook
//
//  Created by Alex Speicher on 2/7/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class DocumentCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var thumbnail: UIImageView! {
        didSet{
            print("thumbnail has been set")
        }
    }
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
        self.label.attributedText = name
        self.selcectionMode = mode
        self.selectedMode.text = "◎"
        self.selectedMode.textColor = UIColor.black
        self.selectedMode.isHidden = !mode
        self.gotSelected = false
        
        /*if self.selcectionMode == false {
            
        }*/
    }
}

