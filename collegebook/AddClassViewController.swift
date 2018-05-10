//
//  AddClassViewController.swift
//  collegebook
//
//  Created by Steven Premus on 3/10/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController {
    
    var mainViewController:MainMenuViewController?

    var onSave: ((_ className: String?) -> ())?
    private var myClassItems = [classItem]()
    
    /*@IBOutlet weak var classNameTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var dayOfWeekTF: UITextField!
    */
    @IBOutlet weak var classNameTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var dayOfWeekTF: UITextField!
    
    
    var fileNames = [String]()
    var fileURLs = [URL]()
    var selectedFileUrls = [URL]()
    
    
    let fileManager = FileManager.default
    var documentDirecortyURL: URL?
    var currentDirectoryURL = [URL]()
    var template: URL?
    
    var mainInstance:MainMenuViewController?
    //mainInstance?.createFolder()
    
    
    
    func createFolder(){
        let folderPath = currentDirectoryURL.last!.appendingPathComponent("Untitled Folder")
        //let folderPath = documentDirecortyURL!.appendingPathComponent("Untitled Folder")
        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        mainInstance?.loadDirectoryContents()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        
        //createDatePicker()
        
        // Do any additional setup after loading the view.
    }
    /*
     func createDayPicker() {
     let dayPicker = UIPickerView()
     // dayPicker.delegate = self
     DaysTF.inputView = dayPicker
     }
     */
    /* extension AddClassViewController: UIPickerViewDelegate, UIPickerViewDataSource {
     
     }
     */
    
    /*  @objc
     public func applicationDidEnterBackground(_ notification: NSNotification)
     {
     do
     {
     try todoItems.writeToPersistence()
     }
     catch let error
     {
     NSLog("Error writing to persistence: \(error)")
     }
     }
     
     override func didReceiveMemoryWarning()
     {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }
     */
    
    @IBAction func closeBTN(_ sender: AnyObject) {
        self.removeAnimate()
        //self.createFolder()
    }
    
    @IBAction func SaveBTN(_ sender: AnyObject) {
        self.storeData()
        onSave?(classNameTF.text!)
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func storeData()
    {
        print("Data Saved!!!")
        
        let nameString: String = classNameTF.text!
        let startString: String = startTimeTF.text!
        let endString: String = endTimeTF.text!
        let dayString: String = dayOfWeekTF.text!
        print(nameString)
        print(startString)
        print(endString)
        print(dayString)
    
        
        /*
        self.addNewToDoItem(className: nameString, startTime: startString, endTime: endString, dayOfWeek: dayString)
        
        //creat new folder of nameString
        var mainviewInstance: MainMenuViewController?
       // mainviewInstance?.createFolder("test")
        
        //start here
        var myMain: MainMenuViewController?
*/

       // createFolder()
    }
    private func addNewToDoItem(className: String, startTime: String, endTime:String, dayOfWeek: String)
    {
        // The index of the new item will be the current item count
        let newIndex = myClassItems.count
        print(newIndex)
        
        // Create new item and add it to the todo items list
        myClassItems.append(classItem(className: className, startTime: startTime, endTime: endTime, dayOfWeek: dayOfWeek))
        var otherInstance: classItem?
       // otherInstance?.saveClassItems();
       
        
        /*
         let ids = todoItems.map { $0.className;  }
         let ids2 = todoItems.map { $0.startTime }
         print(ids)
         print(ids2)
         */
    }
    
    
}
