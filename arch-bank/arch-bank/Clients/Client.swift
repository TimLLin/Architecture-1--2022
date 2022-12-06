//
//  Client.swift
//  arch-bank
//
//  Created by Тимур Калимуллин on 06.12.2022.
//

import Foundation

final class Client{
    private var clientData: [String: String]
    private var clientId: Int
    private var isDependable: Bool
    
    var account: AccountSchema
    
    init(clientData: [String:String], clientId: Int) {
        self.clientData = clientData
        self.clientId = clientId
        
        if (clientData["address"] != nil) || (clientData["passportNumber"] != nil){
            self.isDependable = true
        }
        else{
            self.isDependable = false
        }
    }
    
    func gertId() -> Int{
        return clientId
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
    private var clientData: [String:String] = [:]
    private var clientId: Int = -1
    
    func build() throws -> Client {
        if (clientData["fisrtName"] == nil) || (clientData["secondName"] == nil) || (clientId == -1){
            throw ClientCreationExceptions.missingData
        }else{
            let newClient = Client(clientData: self.clientData, clientId: self.clientId)
            //resetFields()
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
        self.clientData["clientId"] = String(clientId)
        return self
    }
    
    func setAddress(address: String?) -> ClientCreation {
        if let address = address {
            self.clientData["address"] = address
            return self
        }
    }
    
    func setPassport(passportNumber: String?) -> ClientCreation {
        if let passportNumber = passportNumber{
            self.clientData["passportNumber"] = passportNumber
            return self
        }
    }
    
}
