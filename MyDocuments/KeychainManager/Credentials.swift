//
//  Credentials.swift
//  MyDocuments
//
//  Created by Руслан Магомедов on 10.07.2022.
//

import Foundation
import Security

struct Credentials {

    let user: String 
    let service: String
    var password: String

}

struct CredentialsGet {
    let user: String
    let service: String

}

