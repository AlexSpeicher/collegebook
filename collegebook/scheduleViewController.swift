//
//  ScheduleViewController.swift
//  collegebook
//
//  Created by Steven Premus on 3/4/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
     /*   didSet {
            myTableView.dataSource = self
        }
    */
    //var ClassNameList: [String] = []
    var onScheduleClose: ((_ ClassNameList: [String]) -> ())?
    var ClassNameList = ["CSC15","CSC14","MATH71"]

    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.showAnimate()
        
        //myTableView.reloadData()
        //ClassNameList = ["CSC15", "CSC14"]
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectonsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(ClassNameList.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = ClassNameList[indexPath.row]

        return cell
     }
    
  /*
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
        {
            if editingStyle == UITableViewCellEditingStyle.delete
            {
                ClassNameList.remove(at: indexPath.row)
                myTableView.reloadData()
            }
     } */
    
    @IBAction func addClassBTN(_ sender: AnyObject) {
        print("add class BTN")
        self.newPopUp()
    }
    
    @IBAction func closeSchedule(_ sender: AnyObject) {
        if !ClassNameList.isEmpty{
            onScheduleClose?(ClassNameList)
        }
        self.removeAnimate()
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
    
    func newPopUp()
    {
        //  self.view.removeFromSuperview()
        /*      let popOverVC = UIStoryboard(name: "AddClassView", bundle: nil).instantiateViewController(withIdentifier: "AVC") as! AddClassViewController
         self.addChildViewController(popOverVC)
         popOverVC.view.frame = self.view.frame
         self.view.addSubview(popOverVC.view)
         popOverVC.didMove(toParentViewController: self)
         */
        
        let popOverVC = UIStoryboard(name: "addClassView", bundle: nil).instantiateViewController(withIdentifier: "AVC") as! AddClassViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        popOverVC.onSave = onSave
        
    }
    
    func onSave(_ className: String?) -> (){
        ClassNameList.append(className!)
        print(ClassNameList)
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
