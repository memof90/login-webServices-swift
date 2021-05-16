//
//  ListContactController.swift
//  Login
//
//  Created by Memo Figueredo on 15/5/21.
//

import UIKit

class ListContactController: UIViewController{
 
    
    static let shared = ListContactController()
    var loginController : LoginController!
    
    @IBOutlet weak var todoContactTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        todoContactTable.delegate = self
//        todoContactTable.dataSource = self
//        todoContactTable.reloadData()

        todoContactTable.delegate = self
        todoContactTable.dataSource = self
        getAllTokens()
       

    }
    
    var token = ""
    var tokenMD5 = ""
    var sessionUser = ""
    
        
    func getAllTokens() {
        NetworkServices.shared.getToken { (tokens) in
            self.token = tokens.result.token
//            debugPrint(self.token)
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
//            debugPrint(sing.result.sessionName)
            self.sessionUser = sing.result.sessionName
//            debugPrint(self.sessionUser)
//            self.fetchingContact(sessionName: self.sessionUser)
            DispatchQueue.main.async {
                self.getAll(sessionName: self.sessionUser)
                debugPrint(self.sessionUser)
            }
           
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
          
               
    }
    
    
   public var allList = Array<ListContact>()
    
     func getAll(sessionName: String) {
        NetworkServices.shared.fetchAll(sessionName: sessionName) { (contact) in
            debugPrint(contact)
            self.allList = contact.result
            
            self.todoContactTable.reloadData()
            
            
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }
 }
}


    extension ListContactController: UITableViewDelegate, UITableViewDataSource {

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }


            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return allList.count
            }
        
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell") as? ListContactTableViewCell else {
                    return UITableViewCell()
                }

        
                cell.updateCell(listContact: allList[indexPath.row])
        
                return cell
        
        
        //        cell.configureCell(listContact: listcontact)
        //        return cell
            }

    }
