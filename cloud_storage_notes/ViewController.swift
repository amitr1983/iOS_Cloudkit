//
//  ViewController.swift
//  cloud_storage_notes
//
//  Created by amit kumar on 10/4/17.
//  Copyright © 2017 amit kumar. All rights reserved.
//

import UIKit
import Foundation
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var reason: UITextField!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var successLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func disMiss() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        let container = CKContainer.default()
        let privateDatabase = container.publicCloudDatabase
        let timestampAsString = String(format: "%f", NSDate.timeIntervalSinceReferenceDate)
        let timestampParts = timestampAsString.components(separatedBy: ".")
        let noteID = CKRecordID(recordName: timestampParts[0])
        print(noteID)
        let noteRecord = CKRecord(recordType: "noteApp", recordID: noteID)
        noteRecord.setObject(location.text as CKRecordValue?, forKey: "location")
        noteRecord.setObject(reason.text! as CKRecordValue, forKey: "reason")
        noteRecord.setObject(descriptionText.text! as CKRecordValue, forKey: "description")
        privateDatabase.save(noteRecord, completionHandler: { (record, error) -> Void in
            if (error != nil) {
                print("amit")
                print(error ?? "Got an error")
                DispatchQueue.main.async {
                    self.successLabel.text = "Oops!! We got an error"
                }
            } else {
                DispatchQueue.main.async {
                    self.successLabel.text = "YO!! Successfully Saved"
                }
                print("Successfully saved")
            }
        })
    }
    
    @IBAction func cancel(_ sender: Any) {

    }

    

}

