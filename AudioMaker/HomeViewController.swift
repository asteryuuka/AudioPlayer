//
//  HomeViewController.swift
//  AudioMaker
//
//  Created by 兼子友花 on 12/15/19.
//  Copyright © 2019 兼子友花. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase


class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Post {
        let comment: String
        //  let postID: String
        let musicfile: String
        let createdAt: Timestamp
        // let updatedAt: Timestamp
        
        init(data: [String: Any]) {
            comment = data["comment"] as! String
            //   postID = data["postID"] as! String
            musicfile = data["musicfile"] as! String
            createdAt = data["createdAt"] as! Timestamp
            // updatedAt = data["updatedAt"] as! Timestamp
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    var database: Firestore!
    var musicArray: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = (musicArray[indexPath.row] as AnyObject).comment
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        db.collection("music").getDocuments() { (querySnapshot, err) in
        //            if let err = err {
        //                print("Error getting documents: \(err)")
        //            } else {
        //                for document in querySnapshot!.documents {
        //                    print("\(document.documentID) => \(document.data())")
        //                }
        //            }
        //        }
        
        
        database.collection("music").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.musicArray = []
                for document in snapshot.documents {
                    let data = document.data()
                    let post = Post(data: data)
                    self.musicArray.append(post)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func add() {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
