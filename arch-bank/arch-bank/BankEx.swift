//
//  BankEx.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation
class Bank: BankSchema{
    var bankName: String
    var percentOnbalance: Double
    var isDependableLimit: Double
    var commission: Double
    var downLimit: Double
    var dateTill: Int
    var clients: [Client : clientsValues] = [:]
    
    init(bankName: String, percentOnbalance: Double, isDependableLimit: Double, commission: Double, downLimit: Double, dateTill: Int) {
        self.bankName = bankName
        self.percentOnbalance = percentOnbalance
        self.isDependableLimit = isDependableLimit
        self.commission = commission
        self.downLimit = downLimit
        self.dateTill = dateTill
    }
}
