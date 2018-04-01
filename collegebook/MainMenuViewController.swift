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
    let fileManager = FileManager.default
    var documentDirecortyURL: URL?
    var template: URL?
    
    var nextDocumentName: String!
    var selectionEnabled = false
    
    
    private var lastDocumentViewed: UINavigationController?
    private var _lastViewController: DocumentViewController?
    var createDocumentConfirmation: Bool!

    
    @IBAction func createNewDocument(_ sender: UIBarButtonItem) {
        createNewDocumnet()
    }
    
    @IBAction func createFolder(_ sender: UIBarButtonItem) {
        createFolder()
    }
    
    @IBAction func returnToLastDocument(_ sender: UIBarButtonItem) {
        openCurrentDoc()
    }
    
    @IBAction func makeSelection(_ sender: UIBarButtonItem) {
        selectionEnabled = !selectionEnabled
        emojiCollectionView.reloadData()
    }
    
    @IBAction func deleteObjects(_ sender: UIBarButtonItem) {
        /*
        do {
            
            let lastfile = fileURLs.remove(at: fileURLs.count - 1 )
            fileNames.remove(at: fileNames.count - 1 )
            
            try fileManager.removeItem(at: lastfile)
            
            
            emojiCollectionView.reloadData()
        } catch {
            print("Could not delete object: \(error)")
        }
        */
    }
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet{
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileNames.count
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
                DocumentCell.displayContent(name: text, mode: selectionEnabled)
                DocumentCell.cellPosition = indexPath.item
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath)
            
            if let DocumentCell = cell as? DocumentCollectionViewCell {
                DocumentCell.delegate = self
                let text = NSAttributedString(string: fileURLs[indexPath.item].deletingPathExtension().lastPathComponent, attributes: [.font:font])
                DocumentCell.displayContent(name: text, mode: selectionEnabled)
                DocumentCell.cellPosition = indexPath.item
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
        
        /*
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent(nextDocumentName) {
            document = CBDocument(fileURL: url)
        }
        */
        
        if lastDocumentViewed != nil {
            _lastViewController?.close()
        }
        let sb = UIStoryboard(name: "DocumentView", bundle: nil)
        let DocummentToBeViewed = sb.instantiateInitialViewController()! as! UINavigationController
        if let _DocumentViewController = DocummentToBeViewed.viewControllers.first as? DocumentViewController {
            _DocumentViewController.filenames = fileNames
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
                ).appendingPathComponent(nextDocumentName) {
                _DocumentViewController.document = CBDocument(fileURL: url)
            }
        }
        lastDocumentViewed = DocummentToBeViewed
        
        self.present(DocummentToBeViewed, animated: true)
    }
    
    func createFolder(){
        let folderPath = documentDirecortyURL!.appendingPathComponent("Untitled Folder")
        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        
    }
    
    func loadDirectoryContents(){
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: documentDirecortyURL!, includingPropertiesForKeys: nil) //change back to let later
            print(fileURLs)
            print(fileURLs.flatMap({[$0.pathExtension]}))
            fileNames = fileURLs.flatMap({[$0.deletingPathExtension().lastPathComponent]})
            print(fileNames)
            // process files
        } catch {
            print("Error while enumerating files : \(error.localizedDescription)")
        }
        nextDocumentName = "Untitled".madeUnique(withRespectTo: fileNames) + ".json"
        emojiCollectionView.reloadData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentDirecortyURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        /*
        template = try? fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("Untitled.json")
        if template != nil {
            var templateFile = fileManager.createFile(atPath: template!.path, contents: Data())
        }
        */
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDirectoryContents()
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MainMenuViewController: DocumentCollectionViewCellDelegate {
    func returnObjectPosition(atIndex: Int) {
        if !selectionEnabled {
            presentDocument(at: fileURLs[atIndex])
        } else {
            print(atIndex)
            print(fileNames[atIndex])
        }
    }
}
