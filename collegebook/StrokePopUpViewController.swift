//
//  StrokePopUpViewController.swift
//  collegebook
//
//  Created by Alex Speicher on 1/16/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class StrokePopUpViewController: UIViewController {

    @IBOutlet weak var StrokeSettingsIndicator: StrokeSettings!
    
    @IBOutlet weak var PopUpTitle: UILabel!
    @IBOutlet weak var PopupView: UIView!
    
    @IBOutlet weak var StrokeSizeIndicator: UILabel!
    @IBOutlet weak var StrokeSizeSlider: UISlider!
    
    @IBOutlet weak var OpacityIndicator: UILabel!
    @IBOutlet weak var OpacitySlider: UISlider!
    
    @IBOutlet var ColorIndicators: [UIButton]!
    
    var onConfirm: ((_ StrokeSize: Float, _ strokeColorHex: Int, _ strokeOpacity: Float) -> ())?
    
    var strokeSize : Float!
    var strokeOpacity : Float!
    var strokeColorHex: Int!
    
    @IBAction func strokeSizeChange(_ sender: UISlider) {
        changeValues()
    }
    
    @IBAction func opacityChange(_ sender: UISlider) {
        changeValues()
    }
    
    @IBAction func setColor(_ sender: UIButton) {
        if let colorIndex = ColorIndicators.index(of: sender){
            StrokeSettingsIndicator.updateStrokeColor(at: colorIndex)
            changeValues()
        } else {
            print("button not connected to colors")
        }
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        onConfirm?(strokeSize, strokeColorHex, strokeOpacity)
        dismiss(animated: true)
    }
    
    func changeValues(){
        strokeSize = StrokeSizeSlider.value
        strokeOpacity = OpacitySlider.value
        changeIndicators()
    }
    
    func changeIndicators(){
        let RoundedStrokeValue = String(format: "%.2f", strokeSize)
        let RoundedOpacityValue = String(format: "%.2f", strokeOpacity)
        StrokeSizeIndicator.text = RoundedStrokeValue
        OpacityIndicator.text = RoundedOpacityValue
        strokeColorHex  = StrokeSettingsIndicator.updateSettingsIndicator(strokeSize, strokeOpacity)
    }
    
    func setButtonColors(){
        for index in ColorIndicators.indices{
            let Button = ColorIndicators[index]
            Button.setTitle("", for: UIControlState.normal)
            Button.backgroundColor =  UIColor(rgb: StrokeSettingsIndicator.hexColors[index])
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonColors()
        StrokeSizeSlider.value = strokeSize
        OpacitySlider.value = strokeOpacity
        StrokeSettingsIndicator.strokeColorHex = strokeColorHex
        changeIndicators()

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
