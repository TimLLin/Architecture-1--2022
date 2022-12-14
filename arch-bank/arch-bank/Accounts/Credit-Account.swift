//
//  Credit-Account.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation

final class CreditAccount: AccountSchema{
    var balance: Double
    var date: Int
    var isDependable: Bool
    var isDependableLimit: Double
    var percentOnbalance: Double = 0
    var commission: Double
    var downLimit: Double
    
    init(isDependable: Bool, isDependableLimit: Double, commission: Double, downLimit: Double) {
        self.balance = 0
        self.date = 0
        self.isDependable = isDependable
        self.isDependableLimit = isDependableLimit
        self.commission = commission
        self.downLimit = downLimit
    }
    
    func topUp(money: Double) {
        self.balance += money
    }
    
    func withdrawMoney(money: Double) throws {
        if money > self.balance + self.downLimit{
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
        if money > self.balance + self.downLimit{
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
    
    func timeTravel(timeTravelPeriod: Int) -> Double{
        var timeTravelBalance = self.balance
        var timeTravelDate = self.date
        while timeTravelDate != timeTravelPeriod{
            timeTravelBalance -= self.commission
            timeTravelDate += 1
        }
        return timeTravelBalance
    }
    
    
}
