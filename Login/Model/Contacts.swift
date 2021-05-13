//
//  Contacts.swift
//  Login
//
//  Created by Memo Figueredo on 13/5/21.
//

import Foundation


struct Contact: Codable {
    let success: Bool
    let result: [ListContact]
}

struct ListContact: Codable {
    let id: String
    let contact_no: String
    let lastname: String
    let createdtime: String
}
