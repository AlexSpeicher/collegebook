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
            if NotePadView.strokePaths.count > 1 {
                let Strokes = NotePadView.strokePaths
                let DocumentSize = NotePadView.frame.size
                return CBFile(Strokes: Strokes, DocumentCanvasSize: DocumentSize)
            } else { return nil }
        }
        set {
            self.NotePadView.frame = initalNoteSize//CGRect(origin: CGPoint.zero, size: CGSize.zero)
            self.NotePadView.strokePaths = [[CBFile.Stroke]()]
            self.NotePadView.index = 0
            if let Strokes = newValue?.Strokes, let noteSize = newValue?.DocumentCanvasSize {
                self.NotePadView.strokePaths = (Strokes)
                self.NotePadView.frame = CGRect(origin: CGPoint.zero, size: noteSize )
            } else { print("fail")}
            self.NotePadView.index = self.NotePadView.strokePaths.count - 1
            self.NotePadView.setNeedsDisplay()
        }
    }
    
    //MARK - Storyboard

    var NotePadView = NoteCanvas()
    
    var document: CBDocument?
    
    var filenames = [String]()
    var currentDocumentName: String!
    
    var scrollingEnabled = true
    
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
            scrollView.addSubview(NotePadView)
            //scrollView.isScrollEnabled = false
            scrollView.delaysContentTouches = false
            NotePadView.delegate = self
        }
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDocumentName = "Untitled.json"//"Untitled".madeUnique(withRespectTo: filenames) + ".json"
        /*
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent(currentDocumentName) {
                document = CBDocument(fileURL: url)
        }
        */
        
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
        
        if NotePadView.strokePaths.count > 1 {
            document?.cbfile = cbfile
            if document?.cbfile != nil {
                document?.updateChangeCount(.done)
                print("saved succesfully!")
            }
        } else {
            print("nothing to save")
        }
    }
    
    @IBAction func load(_ sender: UIBarButtonItem) {
        
    }
    
    func close(){
        document?.close()
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
        document?.open { success in
            if success {
                self.title =  self.document?.localizedName
                self.cbfile = self.document?.cbfile
                print("successful load!")
            }
        }
        currentDocumentName = "Untitled.json"
        NotePadView.frame = initalNoteSize
        canvasBackground = currentDocumentBackgroundSettings(type: "Ruled", sizeRatio: Float(1.0), backgroundColor: UIColor.white, GuidesColor: UIColor.lightGray)
        NotePadView.sizeToFit()
        scrollView.contentSize = NotePadView.frame.size
        super.viewWillAppear(animated)
    }
}

extension DocumentViewController: DocumentScrollViewDelegate {
    func changeScrolling() {
        scrollingEnabled = !scrollingEnabled
        print(scrollingEnabled)
        scrollView.isScrollEnabled = scrollingEnabled
    }
    
    struct currentDocumentBackgroundSettings {
        var type: String? = nil
        var sizeRatio: Float = 1.0
        var backgroundColor: UIColor = UIColor.groupTableViewBackground
        var GuidesColor: UIColor = UIColor.lightGray
    }
}


