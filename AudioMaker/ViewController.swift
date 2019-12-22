//
//  ViewController.swift
//  AudioMaker
//
//  Created by 兼子友花 on 11/9/19.
//  Copyright © 2019 兼子友花. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var audioURL: URL?
    
    @IBOutlet var label: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    var ref: DatabaseReference!
    var save: Save!
    var storage = Storage.storage()
    //音楽ファイルとコメントを入れる配列の
    var musicArray: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        //        ref = Database.database().reference()
        //        FirebaseApp.configure()
        
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    
    
    @IBAction func record(){
        if !isRecording {
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.overrideOutputAudioPort(.speaker) //外部のスピーカー
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            isRecording = true
            
            label.text = "録音中..."
            recordButton.setTitle("STOP", for: .normal)
            playButton.isEnabled = false
            
        }else{
            
            audioRecorder.stop()
            isRecording = false
            
            label.text = " "
            recordButton.setTitle("RECORD", for: .normal)
            playButton.isEnabled = true
            
        }
    }
    
    @IBAction func play(){
        if !isPlaying {
            
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
            audioPlayer.play()
            
            isPlaying = true
            
            label.text = "再生中..."
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false
            
        }else{
            
            audioPlayer.stop()
            isPlaying = false
            
            label.text = " "
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true
            
        }
    }
    
    //    @IBAction func readyToUpdate() {
    //        //録音したファイルも受け渡す
    //        self.performSegue(withIdentifier: "Update", sender: nil)
    //
    //
    //
    //
    //    }
    
    //       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //           // ②Segueの識別子確認
    //           if segue.identifier == "Update" {
    //               // ③遷移先ViewCntrollerの取得
    //               let nextView = segue.destination as! View2ViewController
    //               // ④値の設定
    ////               nextView.argString =  textfield.text!
    //           }
    //       }
    
    @IBAction func add(_ sender: AnyObject) {
        let db = Firestore.firestore()
        let ref = db.collection("music").addDocument(data: [
           "musicfile": "Tokyo",
           "createdAt":  FieldValue.serverTimestamp()
            //ここいらないかきく！！！！！！！！！！！
        ]) { err in
            if let err = err {
                print(err)
            }
        }
        
        
        print (ref.documentID)
        
        //  Create a storage reference from our storage service
        let storageRef = storage.reference()
        //getURLでとってきてもらったデータをlocalFileに代入
        let localFile = getURL()
        //storageRefにm4aのファイルを入れる
        let audioRef = storageRef.child("audio/\(ref.documentID).m4a")
        // Upload the file to the path "audio/new.m4a"
        let uploadTask = audioRef.putFile(from: localFile, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                return
            }
            let size = metadata.size
            audioRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                    
                    let db = Firestore.firestore()
                    db.collection("music").addDocument(data: [
                        "musicfile": "audio/\(ref.documentID).m4a"])
                    { err in
                        if let err = err {
                            print(error)
                        }
                    }
                }
                
            }
        }
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "Update" {
                let nextView = segue.destination as! UpdateViewController
                nextView.audioURL = audioURL
         
            }
        }
    }
    
    
}
