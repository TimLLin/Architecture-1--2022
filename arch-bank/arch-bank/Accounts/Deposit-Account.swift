//
//  Deposit-Account.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation

final class DepositAccount: AccountSchema{
    var id: String
    var balance: Double
    var date: Int
    var isDependable: Bool
    var isDependableLimit: Double
    var percentOnbalance: Double
    
    var commission: Double = 0
    var downLimit: Double = 0
    
    var dateTill: Int
    
    init(isDependable: Bool, percentOnbalance: Double, isDependableLimit: Double, dateTill: Int) {
        self.id = UUID().uuidString
        self.balance = 0
        self.date = 0
        self.isDependable = isDependable
        self.percentOnbalance = percentOnbalance
        self.isDependableLimit = isDependableLimit
        self.dateTill = dateTill
    }
    
    func topUp(money: Double) {
        self.balance += money
    }
    
    func withdrawMoney(money: Double) throws {
        if date < dateTill{
            throw AccountException.stilNotTillDate
        }
        
        if money > self.balance{
            throw AccountException.notEnoughMoney
        }
        
        if self.isDependable{
            self.balance -= money
        } else {
            if money > isDependableLimit{
                throw AccountException.isDependableError
            } else {
                self.balance -= money
            }
        }
    }
    
    func transferMoney(money: Double, accountToTransfer: inout AccountSchema) throws {
        if date < dateTill{
            throw AccountException.stilNotTillDate
        }
        if money > self.balance{
            throw AccountException.notEnoughMoney
        }
        
        if self.isDependable{
            self.balance -= money
            accountToTransfer.topUp(money: money)
        } else {
            if money > isDependableLimit{
                throw AccountException.isDependableError
            } else {
                self.balance -= money
                accountToTransfer.topUp(money: money)
            }
        }
    }
    
    func timeTravel() {
        print(1)
    }
    
    
}
