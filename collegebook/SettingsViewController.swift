//
//  SettingsViewController.swift
//  collegebook
//
//  Created by Alex Speicher on 1/25/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var backgroundPattern = "None"
    
    var onSettingsConfirm: ((_ background: String) -> ())?
    
    @IBAction func setRuled(_ sender: UIButton) {
        backgroundPattern = "Ruled"
    }
    
    @IBAction func setGraph(_ sender: UIButton) {
        backgroundPattern = "Graph"
    }
    
    @IBAction func setHex(_ sender: UIButton) {
        backgroundPattern = "Hex"
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        onSettingsConfirm?(backgroundPattern)
        dismiss(animated: true)
    }
    
    @IBAction func confrim(_ sender: UIButton) {
        onSettingsConfirm?(backgroundPattern)
        dismiss(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
