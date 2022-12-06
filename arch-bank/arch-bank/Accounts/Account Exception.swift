//
//  Account Exception.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation

enum AccountException: Error {
        case notEnoughMoney
        case isDependableError
    
        case stilNotTillDate
    }
