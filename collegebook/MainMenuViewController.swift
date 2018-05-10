//
//  ViewController.swift
//  collegebook
//
//  Created by Alex Speicher on 1/6/18.
//  Copyright © 2018 Alex Speicher. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //'I made a change'
    var fileNames = [String]()
    var fileURLs = [URL]()
    var selectedFileUrls = [URL]()
    
    
    let fileManager = FileManager.default
    var documentDirecortyURL: URL?
    var currentDirectoryURL = [URL]()
    var template: URL?
    
  
    
    var nextDocumentName: String!
    var nextFolderName: String!
    
    var selectionEnabled = false {
        didSet {
            if selectionEnabled == false {
                toolbar.isHidden = true
                canMoveTo = false
            }
            else {
                toolbar.isHidden = false
            }
        }
    }
    
    var canMoveTo = false {
        didSet {
            if !canMoveTo {
                backButtonLabel.tintColor = #colorLiteral(red: 1, green: 0.5286996188, blue: 0.06793819693, alpha: 1)
            } else {
                backButtonLabel.tintColor = UIColor.blue
            }
        }
    }
    
    @IBOutlet weak var backButtonLabel: UIBarButtonItem!
    
    private var lastDocumentViewed: UINavigationController?
    private var _lastViewController: DocumentViewController?
    var createDocumentConfirmation: Bool!

    
    
    
    @IBAction func createNewDocument(_ sender: UIBarButtonItem) {
        createNewDocumnet()
    }
    
    @IBAction func openSchedule(_ sender: UIBarButtonItem) {
        
        let popOverVC = UIStoryboard(name: "scheduleView", bundle: nil).instantiateViewController(withIdentifier: "SVC") as! ScheduleViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        //  popOverVC.onScheduleClose = onScheduleClose
    }
    @IBAction func createFolder(_ sender: UIBarButtonItem) {
        createFolder()
    }
    
    @IBAction func returnToLastDocument(_ sender: UIBarButtonItem) {
        openCurrentDoc()
    }
    
    @IBAction func makeSelection(_ sender: UIBarButtonItem) {
        print(selectedFileUrls.count)
        selectionEnabled = !selectionEnabled
        if selectionEnabled == false{
            selectedFileUrls.removeAll()
        }
        emojiCollectionView.reloadData()
    }
    @IBAction func returnToPreviousFolder(_ sender: UIBarButtonItem) {
        if currentDirectoryURL.count > 1 {
            if canMoveTo  {
                for fileURL in selectedFileUrls {
                    let FileName = fileURL.lastPathComponent
                    print(currentDirectoryURL)
                    let secondToLastIndex = currentDirectoryURL.count - 2
                    let newFileURL =   currentDirectoryURL[secondToLastIndex].appendingPathComponent(FileName)
                    do {
                        try fileManager.moveItem(at: fileURL, to: newFileURL)
                    } catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                }
                selectionEnabled = !selectionEnabled
                selectedFileUrls.removeAll()
                loadDirectoryContents()
            } else {
                currentDirectoryURL.removeLast()
                loadDirectoryContents()
            }
        }
    }
    
    @IBAction func deleteObjects(_ sender: UIBarButtonItem) {
        var contentNeedsToBeReloaded = false
        for i in selectedFileUrls{
            contentNeedsToBeReloaded = true
            do {
                try fileManager.removeItem(at: i)
            } catch {
                print("Could not delete object: \(error)")
            }
        }
        if contentNeedsToBeReloaded {
            loadDirectoryContents()
        }
    }
    
    @IBAction func rename(_ sender: UIBarButtonItem) {
        if !selectedFileUrls.isEmpty {
            let sb = UIStoryboard(name: "RenameView", bundle: nil)
            let RenameView = sb.instantiateInitialViewController()! as! RenameViewController
            RenameView.selectedFileNames = selectedFileUrls
            self.present(RenameView, animated: true)
            RenameView.onRenameClose = onRenameClose
        }
    }
 
    @IBAction func MoveItems(_ sender: UIBarButtonItem) {
        canMoveTo = !canMoveTo
        print(canMoveTo)
        emojiCollectionView.reloadData()
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet{
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileURLs.count
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(20.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if fileURLs[indexPath.item].pathExtension == "json" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath)
            
            if let DocumentCell = cell as? DocumentCollectionViewCell {
                DocumentCell.delegate = self
                let text = NSAttributedString(string: fileURLs[indexPath.item].deletingPathExtension().lastPathComponent, attributes: [.font:font])
                DocumentCell.displayContent(name: text, mode: selectionEnabled, mode2: canMoveTo)
                DocumentCell.cellPosition = indexPath.item
                DocumentCell.thumbnail.image = UIImage(named: "DocThumb")
                /*
                do {
                    print("finding thumbnail")
                    var thumbnailDictionary: AnyObject?
                    let nsurl = fileURLs[indexPath.item] as NSURL
                    try nsurl.getPromisedItemResourceValue(&thumbnailDictionary, forKey: URLResourceKey.thumbnailDictionaryKey)
                    DocumentCell.thumbnail.image = thumbnailDictionary?[URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey] as? UIImage
                } catch {
                    print("couldn't find thumbnail")
                    DocumentCell.thumbnail.image = nil
                }
                */
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath)
            
            if let DocumentCell = cell as? DocumentCollectionViewCell {
                DocumentCell.delegate = self
                let text = NSAttributedString(string: fileNames[indexPath.item], attributes: [.font:font])
                DocumentCell.displayContent(name: text, mode: selectionEnabled, mode2: canMoveTo, isFolder: true)
                DocumentCell.cellPosition = indexPath.item
                DocumentCell.thumbnail.image = UIImage(named: "DocFolder")
            }
            return cell
        }
    }
    
    
    func openCurrentDoc(){
        if let cvc = lastDocumentViewed {
            print("last doc working")
            self.present(cvc, animated: true)
        }
        else {
            print("last doc not working")
        }
    }
    
    func onRenameClose(_ renamedFiles: [URL]) -> (){
        for (index, newURL) in renamedFiles.enumerated(){
            //print(URL)
            do {
                try fileManager.moveItem(at: selectedFileUrls[index], to: newURL)
            } catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
        selectionEnabled = !selectionEnabled
        selectedFileUrls.removeAll()
        loadDirectoryContents()
    }
    
    func presentDocument(at documentURL: URL){
        if lastDocumentViewed != nil {
            _lastViewController?.close()
        }
        let sb = UIStoryboard(name: "DocumentView", bundle: nil)
        let DocummentToBeViewed = sb.instantiateInitialViewController()! as! UINavigationController
        if let _DocumentViewController = DocummentToBeViewed.viewControllers.first as? DocumentViewController {
            _DocumentViewController.filenames = fileNames
            _DocumentViewController.document = CBDocument(fileURL: documentURL)
        }
        lastDocumentViewed = DocummentToBeViewed
        self.present(DocummentToBeViewed, animated: true)
    }

    func createNewDocumnet(){
        
        if lastDocumentViewed != nil {
            _lastViewController?.close()
        }
        let sb = UIStoryboard(name: "DocumentView", bundle: nil)
        let DocummentToBeViewed = sb.instantiateInitialViewController()! as! UINavigationController
        if let _DocumentViewController = DocummentToBeViewed.viewControllers.first as? DocumentViewController {
            _DocumentViewController.filenames = fileNames

            if let url = try? currentDirectoryURL.last!.appendingPathComponent(nextDocumentName) {
                fileManager.createFile(atPath: url.path, contents: Data())
                _DocumentViewController.document = CBDocument(fileURL: url)
            }
        }
        lastDocumentViewed = DocummentToBeViewed
        
        self.present(DocummentToBeViewed, animated: true)
    }
    
    func createFolder(){
        let folderPath = currentDirectoryURL.last!.appendingPathComponent(nextFolderName)
        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        loadDirectoryContents()
        
    }
    
    func loadDirectoryContents(){
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: currentDirectoryURL.last!, includingPropertiesForKeys: nil)
            //fileURLs = try fileManager.contentsOfDirectory(at: documentDirecortyURL!, includingPropertiesForKeys: nil) //change back to let later
            //print(fileURLs)
            //print(fileURLs.flatMap({[$0.pathExtension]}))
            fileNames = fileURLs.flatMap({[$0.deletingPathExtension().lastPathComponent]})
            //print(fileNames)
            // process files
        } catch {
            print("Error while enumerating files : \(error.localizedDescription)")
        }
        nextDocumentName = "Document".madeUnique(withRespectTo: fileNames) + ".json"
        nextFolderName = "Folder".madeUnique(withRespectTo: fileNames)
        emojiCollectionView.reloadData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentDirecortyURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        currentDirectoryURL.append(documentDirecortyURL!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toolbar.isHidden = true
        loadDirectoryContents()
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MainMenuViewController: DocumentCollectionViewCellDelegate {
    func returnObjectPosition(atIndex: Int, folderStatus: Bool) {
        let urlOfFile = fileURLs[atIndex]
        let isaFolder = folderStatus
        
        if !selectionEnabled {
            if urlOfFile.pathExtension == "json" {
                presentDocument(at: urlOfFile)
            } else if urlOfFile.pathExtension == "" {
                //print("is a folder")
                currentDirectoryURL.append(urlOfFile)
                loadDirectoryContents()
            }
        } else {
            if canMoveTo && isaFolder {
                for fileURL in selectedFileUrls {
                    let FileName = fileURL.lastPathComponent
                    let newFileURL = urlOfFile.appendingPathComponent(FileName)
                    
                    do {
                        try fileManager.moveItem(at: fileURL, to: newFileURL)
                    } catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                    //print(FileName)
                }
                loadDirectoryContents()
                selectedFileUrls.removeAll()
                selectionEnabled = !selectionEnabled
                //print(urlOfFile)
            } else if selectedFileUrls.contains(urlOfFile){
                if let index = selectedFileUrls.index(of: urlOfFile){
                    selectedFileUrls.remove(at: index)
                }
            } else {
                selectedFileUrls.append(urlOfFile)
            }
            //print(selectedFileUrls)
        }
        
    }
}
