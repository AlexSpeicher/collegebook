//
//  RenameViewController.swift
//  collegebook
//
//  Created by Alex Speicher on 4/17/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class RenameViewController: UIViewController, UITextFieldDelegate {

    var copySelectedFilesNames: [URL]?
    var selectedFileNames: [URL]?
    var renamedFileNames: [URL] = []
    var onRenameClose: ((_ renamedFiles: [URL]) -> ())?
    
    
    
    var currentFileURL: URL?
    var currentFilePath: String?
    var currentFileExtension: String? {
        didSet {
            if (currentFileExtension! != ""){
                currentFileExtension = "." + currentFileExtension!
            }
        }
    }
    
    
    @IBOutlet weak var originalFileName: UILabel?
    @IBOutlet weak var newFileName: UILabel?
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBAction func confirmName(_ sender: UIButton) {
        let newFilePath = currentFilePath! + textField.text! + currentFileExtension!
        //print(newFileURL)
        let newFileURL = URL(fileURLWithPath: newFilePath)
        
        renamedFileNames.append(newFileURL)
        print(renamedFileNames)
        selectedFileNames?.removeFirst()
        
        if selectedFileNames!.isEmpty {
            
            onRenameClose?(renamedFileNames)

            dismiss(animated: true)
            
        } else {
            updateView()
        }
        //updateView()
    }
    
    @IBAction func cancelName(_ sender: UIButton) {
        
        //Code to clear Note Canvas
        if selectedFileNames!.isEmpty {
            onRenameClose?(renamedFileNames)
            dismiss(animated: true)
        } else{
            selectedFileNames?.removeFirst()
            if selectedFileNames!.isEmpty {
                onRenameClose?(renamedFileNames)
                dismiss(animated: true)
            } else {
                updateView()
            }
        }
    }
    
    
    func updateView(){
        currentFileURL  = selectedFileNames!.first
        
        originalFileName?.text = selectedFileNames!.first?.deletingPathExtension().lastPathComponent
        
        
        let pathComponent = currentFileURL!.deletingLastPathComponent()
        currentFilePath = pathComponent.path + "/"
        currentFileExtension = currentFileURL?.pathExtension
        print(currentFilePath)
        print(currentFileExtension)
        //print(filePath)
        //print(pathComponent)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newFileName?.text = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        newFileName?.text = textField.text
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    override func viewDidLoad() {
        //writingArea.onePageLength = 1000000
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
