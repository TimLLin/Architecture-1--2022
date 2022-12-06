//
//  Account-Schema.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation

protocol AccountSchema{
    var id: String {get set}
    var balance: Double { get set }
    var date: Int { get set }
    var isDependable: Bool { get set }
    var isDependableLimit: Double { get set }
    var percentOnbalance: Double { get set }
    
    var commission: Double { get set }
    var downLimit: Double { get set }
    
    func topUp(money: Double)
    func withdrawMoney(money: Double) throws
    func transferMoney(money: Double, accountToTransfer: inout AccountSchema) throws
    func timeTravel()
}
