//
//  UpdateViewController.swift
//  AudioMaker
//
//  Created by 兼子友花 on 12/15/19.
//  Copyright © 2019 兼子友花. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UpdateViewController: UIViewController {
    
    var ref: DatabaseReference!
    var save: Save!
    var storage = Storage.storage()
    var audioURL: URL?
    
    @IBOutlet var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupTextView() {
        let toolBar = UIToolbar()
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolBar.items = [flexibleSpaceBarButton, doneButton]
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
    }

    @objc func dismissKeyboard() {
       textView.resignFirstResponder()
    }
    
    @IBAction func update() {
        let comment = textView.text!
        let db = Firestore.firestore()
        db.collection("music").addDocument(data: [
            "comment": comment])
        { err in
            if let err = err {
                print(err)
            }
        }
    }
}
