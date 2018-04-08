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
            self.NotePadView.frame = pageSize!
            self.NotePadView.strokePaths = [[CBFile.Stroke]()]
            self.NotePadView.index = 0
            if let Strokes = newValue?.Strokes, let noteSize = newValue?.DocumentCanvasSize {
                self.NotePadView.strokePaths = (Strokes)
                self.NotePadView.frame = CGRect(origin: CGPoint.zero, size: noteSize )
                scrollView.contentSize = NotePadView.frame.size
            } else {print("fail")}
            self.NotePadView.index = self.NotePadView.strokePaths.count - 1
            self.NotePadView.setNeedsDisplay()
        }
    }
    
    //MARK - Storyboard
    var usPaperRatio = [1, 1.2916666667]
    let screenSize = UIScreen.main.bounds
    
    var NotePadView = NoteCanvas()
    var pages = [NoteCanvas]()
    
    
    var document: CBDocument?
    
    var filenames = [String]()
    var currentDocumentName: String!
    
    var scrollingEnabled = true
    
    var pageSize: CGRect? 
    
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
            NotePadView.scrollDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Pages:", pages)
        currentDocumentName = "Untitled.json"
        
        let screenWidth = Double(screenSize.width)
        usPaperRatio = usPaperRatio.map {$0 * screenWidth}
        pageSize = CGRect(x: 0.0, y: 0.0, width: usPaperRatio[0], height: usPaperRatio[1])
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        document?.thumbnail = NotePadView.snapshot
        dismiss(animated: true) {
            self.close()
        }
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
        
    func saveChanges(){
        
        if NotePadView.strokePaths.count > 1 {
            document?.cbfile = cbfile
            if document?.cbfile != nil {
                document?.updateChangeCount(.done)
                //print("saved succesfully!")
            }
        } else {
            print("nothing to save")
        }
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
        
        NotePadView.frame = pageSize!
        NotePadView.onePageLength = pageSize!.maxY
        canvasBackground = currentDocumentBackgroundSettings(type: "Ruled", sizeRatio: Float(1.0), backgroundColor: UIColor.white, GuidesColor: UIColor.lightGray)
        NotePadView.sizeToFit()
        scrollView.contentSize = NotePadView.frame.size
        NotePadView.noteDelegate = self
        super.viewWillAppear(animated)
    }
}

extension DocumentViewController: DocumentScrollViewDelegate, NoteCanvasDelegate {
    func changeNoteFrame() {
        NotePadView.frame = CGRect(x: 0.0, y: 0.0, width: usPaperRatio[0], height: Double(NotePadView.frame.maxY) + usPaperRatio[1] )
        scrollView.contentSize = NotePadView.frame.size
        print("Increase Frame Size")
    }
    
    func changeScrolling() {
        scrollingEnabled = !scrollingEnabled
        scrollView.isScrollEnabled = scrollingEnabled
    }
    
    func noteHasChanged() {
        saveChanges()
    }
    
    struct currentDocumentBackgroundSettings {
        var type: String? = nil
        var sizeRatio: Float = 1.0
        var backgroundColor: UIColor = UIColor.groupTableViewBackground
        var GuidesColor: UIColor = UIColor.lightGray
    }
}


