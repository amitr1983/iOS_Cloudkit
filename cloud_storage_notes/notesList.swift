//
//  notesList.swift
//  cloud_storage_notes
//
//  Created by amit kumar on 10/4/17.
//  Copyright © 2017 amit kumar. All rights reserved.
//

import UIKit
import CloudKit

class notesList: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var noteDetail: UITextView!
    
    let cellReuseIdentifier = "cell"
    
    var arrNotes: Array<CKRecord> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        noteDetail.isHidden = true

        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        fetchNotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotes.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        let noteRecord: CKRecord = arrNotes[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let createDate = dateFormatter.string(from: (noteRecord.value(forKey: "creationDate") as? NSDate)! as Date)
 
        cell.textLabel?.text = "Service Call - \(createDate)"
        cell.backgroundColor = UIColor(red: 205/255, green: 60/255, blue: 68/255, alpha: 0)
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        noteDetail.isHidden = false
        let borderColor = UIColor.white

        
        noteDetail.layer.borderColor = borderColor.cgColor
        noteDetail.layer.borderWidth = 1.0;
        
        let locationtext = arrNotes[indexPath.row].value(forKey: "location") as? String
        let reasontext = arrNotes[indexPath.row].value(forKey: "reason") as? String
        let descriptionText = arrNotes[indexPath.row].value(forKey: "description") as? String
        
        noteDetail.text = "Note Details: \nLocation: \(locationtext ?? "") \nReason: \(reasontext ?? "")\nDescription: \(descriptionText ?? "")"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    

    func fetchNotes() {
        let container = CKContainer.default()
        let publiDatabase = container.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "noteApp", predicate: predicate)
        query.sortDescriptors = [sort]
        
        publiDatabase.perform(query, inZoneWith: nil) { (results, error) -> Void in
            if error != nil {
                print(error)
            }
            else {
//                print(results)
                
                for result in results! {
                    self.arrNotes.append(result as! CKRecord)
                }
                
                OperationQueue.main.addOperation({ () -> Void in
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                })
            }
        }
    }

}
