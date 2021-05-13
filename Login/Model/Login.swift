//
//  Login.swift
//  Login
//
//  Created by Memo Figueredo on 11/5/21.
//

import Foundation

struct LogIn: Codable {
    let success: Bool
    let result: Results
}

struct Results: Codable {
    let sessionName : String
    let userId: String
    let version: String
    let vtigerVersion: String
}
