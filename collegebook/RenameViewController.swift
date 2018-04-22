//
//  RenameViewController.swift
//  collegebook
//
//  Created by Alex Speicher on 4/17/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class RenameViewController: UIViewController {

    var selectedFileNames: [URL]?
    
    @IBOutlet weak var originalFileName: UILabel!
    @IBOutlet weak var newFileName: UILabel!
    
    @IBAction func undoStroke(_ sender: UIButton) {
    }
    
    @IBAction func confirmName(_ sender: UIButton) {
    }
    
    @IBAction func cancelName(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
