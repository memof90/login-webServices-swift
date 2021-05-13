//
//  getToken.swift
//  Login
//
//  Created by Memo Figueredo on 11/5/21.
//

import Foundation


struct Token: Codable {
    let success: Bool
    let result: Result
}



struct Result: Codable {
    var token: String
    let serverTime: Int
    let expireTime: Int
}
