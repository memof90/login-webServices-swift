//
//  ViewController.swift
//  Login
//
//  Created by Memo Figueredo on 11/5/21.
//

import UIKit

class ViewController: UIViewController {
//    Var to save token an use in controller
    
    var token = ""
    var tokenMD5 = ""
    var sessionUser = ""
  
 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAllTokens()

    }

//    Fuction to obtain token in controller
    
    func getAllTokens() {
        NetworkServices.shared.getToken { (tokens) in
            self.token = tokens.result.token
            debugPrint(self.token)
            self.tokenMD5 = self.token.md5()
//            print(self.tokenMD5)
            
//    MARK: fuction to obtain session user in controller
            self.singInUser(token: self.token)
            
        } onError: {  (errorMessage) in
            debugPrint(errorMessage)
        }


    }
    
//    fuction to obtain session user in controller
    
    func singInUser (token: String) {
        NetworkServices.shared.singIn(token: token) { (sing) in
            debugPrint(sing.result.sessionName)
            self.sessionUser = sing.result.sessionName
            debugPrint(self.sessionUser)
            
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }
    



}

