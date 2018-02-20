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
    let fileManager = FileManager.default
    var documentsURL: URL?
    
    
    private var lastDocumentViewed: UINavigationController?
    private var _lastViewController: DocumentViewController?
    var createDocumentConfirmation: Bool!

    
    @IBAction func createNewDocument(_ sender: UIBarButtonItem) {
        createNewDoc()
    }
    
    @IBAction func returnToLastDocument(_ sender: UIBarButtonItem) {
        openCurrentDoc()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath)
        
        if let DocumentCell = cell as? DocumentCollectionViewCell {
            DocumentCell.delegate = self
            let text = NSAttributedString(string: fileNames[indexPath.item], attributes: [.font:font])
            DocumentCell.displayContent(name: text)
            DocumentCell.cellPosition = indexPath.item
            //DocumentCell.label.attributedText = text
        }
        return cell
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

    func createNewDoc(){
        if lastDocumentViewed != nil {
            _lastViewController?.close()
        }
        let sb = UIStoryboard(name: "DocumentView", bundle: nil)
        let DocummentToBeViewed = sb.instantiateInitialViewController()! as! UINavigationController
        
        _lastViewController = DocummentToBeViewed.viewControllers.first as? DocumentViewController
        _lastViewController?.filenames = fileNames
        lastDocumentViewed = DocummentToBeViewed
        
        self.present(DocummentToBeViewed, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL!, includingPropertiesForKeys: nil) //change back to let later
            print(fileURLs)
            fileNames = fileURLs.flatMap({[$0.deletingPathExtension().lastPathComponent]})
            // process files
        } catch {
            print("Error while enumerating files : \(error.localizedDescription)")
        }
        emojiCollectionView.reloadData() //should only reload when file array changes 
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MainMenuViewController: DocumentCollectionViewCellDelegate {
    func openDocument(atIndex: Int) {
        print(atIndex)
    }
}
