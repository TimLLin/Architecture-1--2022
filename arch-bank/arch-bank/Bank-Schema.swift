//
//  Bank-Schema.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation

protocol BankSchema{
    var bankName: String {get set}
    var percentOnbalance: Double {get set}
    var isDependableLimit: Double {get set}
    var commission: Double {get set}
    var downLimit: Double {get set}
    var dateTill: Int {get set}
    
    
    var clients: [Client: [String : clientsValues]] {get set}
    
    mutating func addClient(client: Client, typeAccount: AccountsType)
    mutating func topUp(client: Client, money: Double) throws
    mutating func withdrawMoney(client: Client, money: Double) throws
    mutating func transferMoney(money: Double, from client1: Client, to client2: Client) throws
    mutating func printInfo()
}

extension BankSchema{
    mutating func addClient(client: Client, typeAccount: AccountsType){
        var idx: String = UUID().uuidString
        clients[client] = clientsValues(client: client)
        
        switch typeAccount{
        case .debitAccount: self.clients[client]?.clientData.addAccount(account: DebitAccount(isDependable: client.isDependable, percentOnbalance: percentOnbalance, isDependableLimit: isDependableLimit))
            
        case .depositAccount: self.clients[client]?.clientData.addAccount(account: DepositAccount(isDependable: client.isDependable, percentOnbalance: percentOnbalance, isDependableLimit: isDependableLimit, dateTill: dateTill))
            
        case .creditAccount: self.clients[client]?.clientData.addAccount(account: CreditAccount(isDependable: client.isDependable, isDependableLimit: isDependableLimit, commission: commission, downLimit: downLimit))
        }
    }
    
    mutating func topUp(client: Client, money: Double) throws{
        if clients[client] != nil {
            clients[client]?.clientData.account!.topUp(money: money)
        } else{
            throw bankException.clientNotFound
        }
    }
    
    mutating func withdrawMoney(client: Client, money: Double) throws{
        if clients[client] != nil {
            try clients[client]?.clientData.account!.withdrawMoney(money: money)
        } else{
            throw bankException.clientNotFound
        }
    }
    
    mutating func transferMoney(money: Double, from client1: Client, to client2: Client) throws{
        if clients[client1] != nil && clients[client2] != nil{
            try clients[client1]!.clientData.account!.transferMoney(money: money, accountToTransfer: &(clients[client2]!.clientData.account!))
        } else{
            throw bankException.clientNotFound
        }
    }
    
    
    mutating func printInfo(){
        print("Info about bank - \(self.bankName)")
        for (_, value) in self.clients{
            let name = String(value.clientData.clientData["fisrtName"] ?? "None")
            let secoundName = String(value.clientData.clientData["secondName"] ?? "None")
            let adress = String(value.clientData.clientData["address"] ?? "None")
            let passport = String(value.clientData.clientData["passportNumber"] ?? "None")
            let balance = value.clientData.account!.balance
                
            print("Client name: \(name),  Client Secound Name: \(secoundName)")
            print("Client adress: \(adress), Client Passport: \(passport)")
            print("\t balance on account: \(String(describing: balance)) руб.")
            }
        print("---------------------------------------------------------\n")
        }
}
enum AccountsType{
    case debitAccount
    case depositAccount
    case creditAccount
}


struct clientsValues {
    //var commands: [String]
    var clientData: Client
    
    init(client: Client) {
        self.clientData = client
        //self.commands = commands
    }
}
