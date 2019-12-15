//
//  save.swift
//  AudioMaker
//
//  Created by 兼子友花 on 12/15/19.
//  Copyright © 2019 兼子友花. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Save {
    
    var text: String!
    
    func save() {
        let db = Firestore.firestore()
        //        var ref: DocumentReference? = nil
        db.collection("mayuka").addDocument(data: [
            "text": "Tokyo"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
    }
}
