//
//  LoginViewController.swift
//  AudioMaker
//
//  Created by 兼子友花 on 12/15/19.
//  Copyright © 2019 兼子友花. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAnalytics


class LoginViewController: UIViewController {
    
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         auth = Auth.auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           if auth.currentUser != nil {
               performSegue(withIdentifier: "gohome", sender: auth.currentUser!)
           }
       }

//       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//           let nextViewController = segue.destination as! HomeViewController
//           let user = sender as! User
//           nextViewController.me = AppUser(data: ["userID": user.uid])
//       }
    
    
    @IBAction func doNewRegister() {
        // 各TextFieldからメールアドレスとパスワードを取得
        let email = emailTextField.text
        let password = passwordTextField.text
        
        // FirebaseSDK 新規ユーザーとしてログイン
        Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
            
            // ログイン出来ていたら
            if (result?.user) != nil{
                
                // 次の画面へ遷移
                self.performSegue(withIdentifier: "welcome", sender: nil)
            }else if let error = error {
                print(error)
                //                if let errorCode = AuthErrorCode(rawValue: (error as NSError).code) {
                //
                //                    switch errorCode {
                //
                //                    case .wrongPassword:
                //                        errorMessage = "入力したパスワードでサインインできません"
                //                    case .emailAlreadyInUse:
                //                        errorMessage = "このメールアドレスは既に使われています"
                //                    default:
                //                        errorMessage = "通信に失敗しました"
                //
                //                    }
                //
                //                    let loginAlert = UIAlertController(title: "ログインエラー", message: errorMessage, preferredStyle: .alert)
                //                    loginAlert.addAction(UIAlertAction(title: "OK", style: .default))
                //                    self.present(loginAlert, animated: true)
                //
            }
        }
    }
    
    
    
    @IBAction func doLogin() {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        //FirebaseSDK 既存ユーザーのログイン
        Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
            if (result?.user) != nil {
                // 次の画面へ遷移
                self.performSegue(withIdentifier: "gohome", sender: nil)
            } else if let error = error {
                print("performError")
                
            }
        }
    }
}






