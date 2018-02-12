//
//  DocumentViewController.swift
//  collegebook
//
//  Created by Alex Speicher on 1/12/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit


class DocumentViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Model
    
     var cbfile: CBFile? {
        get {
            if let Strokes = NotePadView?.strokePaths {
                let DocumentSize = NotePadView.frame.size
                return CBFile(Strokes: Strokes, DocumentCanvasSize: DocumentSize)
            }
            return nil
        }
        set {
            if (cbfile?.Strokes)?[0].isEmpty == false {
                print("SUCCESS * 2")
                print(cbfile?.Strokes)
                self.NotePadView.strokePaths = (cbfile!.Strokes)
                self.NotePadView.frame = initalNoteSize
            } else { print("fail")}
        }
    }
    
    //MARK - Storyboard

    var NotePadView:  NoteCanvas!
    
    var document: CBDocument?
    
    let initalNoteSize = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: CGFloat(UIScreen.main.bounds.width),
                                height: CGFloat(UIScreen.main.bounds.height)*2)
    
    var canvasBackground: currentDocumentBackgroundSettings! {
        didSet {
            if let Pattern = canvasBackground.type {
                let background = UIColor(patternImage: (UIImage(Pattern: Pattern, BackgroundColor: canvasBackground.backgroundColor, GuidesColor: canvasBackground.GuidesColor, Scale: canvasBackground.sizeRatio))!)
                NotePadView.background = background
            } else {
                let background = canvasBackground.backgroundColor
                NotePadView.background = background
            }
            
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delete later
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("Untitled.json") {
                document = CBDocument(fileURL: url)
            }
        // Delete later
        
        
        NotePadView = NoteCanvas(frame: initalNoteSize)
        canvasBackground = currentDocumentBackgroundSettings(type: "Ruled", sizeRatio: Float(1.0), backgroundColor: UIColor.white, GuidesColor: UIColor.lightGray)
        NotePadView.delegate = self
        scrollView.addSubview(NotePadView)

        NotePadView.sizeToFit()
        scrollView.contentSize = NotePadView.frame.size

    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func undo(_ sender: UIBarButtonItem) {
        NotePadView.undo()
    }
    
    @IBAction func redo(_ sender: UIBarButtonItem) {
        NotePadView.redo()
    }
    
    @IBAction func openStrokeSettings(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "StrokePopUpView", bundle: nil)
        let strokePopUp = sb.instantiateInitialViewController()! as! StrokePopUpViewController
        strokePopUp.strokeSize = Float(NotePadView.strokeSize)
        strokePopUp.strokeOpacity = NotePadView.strokeOpacity
        strokePopUp.strokeColorHex = NotePadView.strokeColorHex
        self.present(strokePopUp, animated: true)
        strokePopUp.onConfirm = onConfirm
    }
    
    @IBAction func openGeneralSettings(_ sender: UIBarButtonItem) {
        let ssb = UIStoryboard(name: "SettingsView", bundle: nil)
        let settingsPopUp = ssb.instantiateInitialViewController()! as! SettingsViewController
        self.present(settingsPopUp, animated: true)
        settingsPopUp.onSettingsConfirm = onSettingsConfirm
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        document?.cbfile = cbfile
        if document?.cbfile != nil{
            document?.updateChangeCount(.done)
            print("successful save")
        }
    }

    func onConfirm(_ StrokeSize: Float, _ strokeColorHex: Int, _ strokeOpacity: Float) -> () {
        NotePadView.strokeSize = StrokeSize
        NotePadView.strokeColorHex = strokeColorHex
        NotePadView.strokeOpacity = strokeOpacity
    }
    
    func onSettingsConfirm(_ background: String) -> () {
        if background != "None" {
            canvasBackground = currentDocumentBackgroundSettings(type: background, sizeRatio: Float(1.0), backgroundColor: UIColor.white, GuidesColor: UIColor.lightGray)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        document?.open { success in
            if success {
                self.title =  self.document?.localizedName
                self.cbfile = self.document?.cbfile
                print("SUCCESS!!")
            }
        }
        /*
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("Untitled.json") {
                if let jsonData = try? Data(contentsOf: url) {
                    cbDocument = CBDocument(json: jsonData)
                }
            
        }
        */
    }
    

}

extension DocumentViewController {
    struct currentDocumentBackgroundSettings {
        var type: String? = nil
        var sizeRatio: Float = 1.0
        var backgroundColor: UIColor = UIColor.groupTableViewBackground
        var GuidesColor: UIColor = UIColor.lightGray
    }
}

extension DocumentViewController: NotePadDelegate {
    func NoteFrameHasChanged(){
        NotePadView.sizeToFit()
        scrollView.contentSize = NotePadView.frame.size
    }
}