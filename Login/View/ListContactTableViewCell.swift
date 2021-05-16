//
//  ListContactTableViewCell.swift
//  Login
//
//  Created by Memo Figueredo on 15/5/21.
//

import UIKit

class ListContactTableViewCell: UITableViewCell {
    


    @IBOutlet weak var contact_NoLbl: UILabel!
    
    
    @IBOutlet weak var lastNameLbl: UILabel!
    
    @IBOutlet weak var Created_TimeLbl: UILabel!
    

    
    func updateCell(listContact: ListContact) {
        contact_NoLbl.text = listContact.contact_no
        lastNameLbl.text = listContact.lastname
        Created_TimeLbl.text =  listContact.createdtime
    }
    
}
