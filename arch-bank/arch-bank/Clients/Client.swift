//
//  Client.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation

final class Client: Hashable{
    var clientId: Int
    var clientData: [String: String]
    var isDependable: Bool
    
    var account: AccountSchema?
    
    init(clientId: Int, clientData: [String:String]) {
        self.clientId = clientId
        self.clientData = clientData
        
        if (clientData["address"] != nil) || (clientData["passportNumber"] != nil){
            self.isDependable = true
        }
        else{
            self.isDependable = false
        }
    }
    func addAccount(account: AccountSchema){
        self.account = account
    }
    //hashable part
    static func == (lhs: Client, rhs: Client) -> Bool {
        lhs.clientId == rhs.clientId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(clientId)
    }
    
}
protocol ClientCreation{
    func build() throws -> Client
    func setFirstName(fisrtName: String) -> ClientCreation
    func setSecondName(secondName: String) -> ClientCreation
    func setId(clientId: Int) -> ClientCreation
    func setAddress(address: String?) -> ClientCreation
    func setPassport(passportNumber: String?) -> ClientCreation
}

final class ClientCreator: ClientCreation{
    private var clientId: Int = -1
    private var clientData: [String:String] = [:]
    
    func build() throws -> Client {
        if (clientData["fisrtName"] == nil) || (clientData["secondName"] == nil) || (clientId == -1){
            throw ClientCreationExceptions.missingData
        }else{
            let newClient = Client(clientId: self.clientId, clientData: self.clientData)
            return newClient
            
        }
    }
    
    func setFirstName(fisrtName: String) -> ClientCreation {
        self.clientData["fisrtName"] = fisrtName
        return self
    }
    
    func setSecondName(secondName: String) -> ClientCreation {
        self.clientData["secondName"] = secondName
        return self
    }
    
    func setId(clientId: Int) -> ClientCreation {
        self.clientId = clientId
        return self
    }
    
    func setAddress(address: String?) -> ClientCreation {
        if let address = address {
            self.clientData["address"] = address
        }
        return self
    }
    
    func setPassport(passportNumber: String?) -> ClientCreation {
        if let passportNumber = passportNumber{
            self.clientData["passportNumber"] = passportNumber
        }
        return self
    }
}
