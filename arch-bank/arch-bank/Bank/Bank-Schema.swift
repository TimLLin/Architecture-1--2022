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
    
    var clients: [String: [Client : clientsValues]] {get set}
    
    mutating func addClient(client: Client, typeAccount: AccountsType)
    mutating func topUp(client: Client, money: Double, id: String) throws
    mutating func withdrawMoney(client: Client, money: Double, id: String) throws
    mutating func transferMoney(money: Double, from client1: Client, accountIdFrom id1: String, to client2: Client, accountIdTo id2: String) throws
    mutating func undo(client: Client, id: String) throws
    mutating func timeTravel(client: Client, id: String, timeTravelPeriod: Int) throws
    mutating func printInfo()
}

extension BankSchema{
    mutating func addClient(client: Client, typeAccount: AccountsType){
        let idx: String = UUID().uuidString
        var operations = Opeartion()
        clients[idx] = [client: clientsValues(client: client, operation: operations)]
        
        switch typeAccount{
        case .debitAccount: self.clients[idx]?[client]?.clientData.addAccount(account: DebitAccount(isDependable: client.isDependable, percentOnbalance: percentOnbalance, isDependableLimit: isDependableLimit))
            
        case .depositAccount: self.clients[idx]?[client]?.clientData.addAccount(account: DepositAccount(isDependable: client.isDependable, percentOnbalance: percentOnbalance, isDependableLimit: isDependableLimit, dateTill: dateTill))
            
        case .creditAccount: self.clients[idx]?[client]?.clientData.addAccount(account: CreditAccount(isDependable: client.isDependable, isDependableLimit: isDependableLimit, commission: commission, downLimit: downLimit))
        }
    }
    
    mutating func topUp(client: Client, money: Double, id: String) throws{
        if clients[id]?[client] != nil {
            clients[id]?[client]?.clientData.account!.topUp(money: money)
            clients[id]?[client]?.operation.clientIdTo = id
            clients[id]?[client]?.operation.clientIdFrom = id
            clients[id]?[client]?.operation.moneu = money
            clients[id]?[client]?.operation.operationType = .topUp
        } else{
            throw bankException.clientNotFound
        }
    }
    
    mutating func withdrawMoney(client: Client, money: Double, id: String) throws{
        if clients[id]?[client] != nil {
            try clients[id]?[client]?.clientData.account!.withdrawMoney(money: money)
            clients[id]?[client]?.operation.clientIdTo = id
            clients[id]?[client]?.operation.clientIdFrom = id
            clients[id]?[client]?.operation.moneu = money
            clients[id]?[client]?.operation.operationType = .withdrawMoney
        } else{
            throw bankException.clientNotFound
        }
    }
    
    mutating func transferMoney(money: Double, from client1: Client, accountIdFrom id1: String, to client2: Client, accountIdTo id2: String) throws{
        if clients[id1]?[client1] != nil && clients[id2]?[client2] != nil{
            try clients[id1]![client1]!.clientData.account!.transferMoney(money: money, accountToTransfer: &(clients[id2]![client2]!.clientData.account!))
            //cохроняем информацию об операции
            clients[id1]?[client1]?.operation.clientIdFrom = id1
            clients[id1]?[client1]?.operation.clientIdTo = id2
            clients[id1]?[client1]?.operation.moneu = money
            clients[id1]?[client1]?.operation.operationType = .transferMoney
            clients[id1]?[client1]?.operation.clientTo = client2
            
        } else{
            throw bankException.clientNotFound
        }
    }
    
    mutating func undo(client: Client, id: String) throws{
        if clients[id]?[client] != nil{
            if let idx = clients[id]?[client]?.operation.clientIdFrom, let idxTo = clients[id]?[client]?.operation.clientIdTo, let typeOfOperation = clients[id]?[client]?.operation.operationType, let money = clients[id]?[client]?.operation.moneu, let clientTo = clients[id]?[client]?.operation.clientTo {
                    switch typeOfOperation{
                    case .topUp: try clients[idx]?[client]?.clientData.account!.withdrawMoney(money: money)
                    case .withdrawMoney: clients[idx]?[client]?.clientData.account!.topUp(money: money)
                    case .transferMoney: try clients[idxTo]![clientTo]!.clientData.account!.transferMoney(money: money, accountToTransfer: &(clients[idx]![client]!.clientData.account!))
                }
            }
        } else{
            throw bankException.clientNotFound
        }
    }
    
    mutating func timeTravel(client: Client, id: String, timeTravelPeriod: Int) throws{
        if clients[id]?[client] != nil{
            print("Состояне счета через \(timeTravelPeriod) дней")
            let timeTravelBalance = (clients[id]?[client]?.clientData.account!.timeTravel(timeTravelPeriod: timeTravelPeriod))!
            let name = String(clients[id]?[client]?.clientData.clientData["fisrtName"] ?? "None")
            let secoundName = String(clients[id]?[client]?.clientData.clientData["secondName"] ?? "None")
            let adress = String(clients[id]?[client]?.clientData.clientData["address"] ?? "None")
            let passport = String(clients[id]?[client]?.clientData.clientData["passportNumber"] ?? "None")
            let balance = String(clients[id]?[client]?.clientData.account!.balance ?? 0.0)
            print("Client name: \(name),  Client Secound Name: \(secoundName)")
            print("Client adress: \(adress), Client Passport: \(passport)")
            print("Account id: \(id)")
            print("\t balance on account BEFORE time travel: \(String(describing: balance)) руб.")
            print("\t balance on account AFTER time travel: \(String(round(timeTravelBalance))) руб.")
            print("-----------")
        } else {
            throw bankException.clientNotFound
        }
    }
    
    mutating func printInfo(){
        print("Info about bank - \(self.bankName)")
        for (key, value) in self.clients{
            for (_, vv) in value{
                let idx = key
                let name = String(vv.clientData.clientData["fisrtName"] ?? "None")
                let secoundName = String(vv.clientData.clientData["secondName"] ?? "None")
                let adress = String(vv.clientData.clientData["address"] ?? "None")
                let passport = String(vv.clientData.clientData["passportNumber"] ?? "None")
                let balance = vv.clientData.account!.balance
                
                print("Client name: \(name),  Client Secound Name: \(secoundName)")
                print("Client adress: \(adress), Client Passport: \(passport)")
                print("Account id: \(idx)")
                print("\t balance on account: \(String(describing: balance)) руб.")
                print("-----------")
            }
        }
        print("---------------------------------------------------------\n")
        }
}
enum AccountsType{
    case debitAccount
    case depositAccount
    case creditAccount
}

enum OperationsType{
    case topUp
    case withdrawMoney
    case transferMoney
}

struct Opeartion{
    var clientIdFrom: String?
    var clientIdTo: String?
    var moneu: Double?
    var operationType: OperationsType?
    var clientTo: Client?
    
    init(clientIdFrom: String? = nil, clientIdTo: String? = nil, moneu: Double? = nil, operationType: OperationsType? = nil, clientTo: Client? = nil) {
        self.clientIdFrom = clientIdFrom
        self.clientIdTo = clientIdTo
        self.moneu = moneu
        self.operationType = operationType
        self.clientTo = clientTo
    }
    
}

struct clientsValues {
    var clientData: Client
    var operation: Opeartion
    
    init(client: Client, operation: Opeartion) {
        self.clientData = client
        self.operation = operation
    }
}
