import Foundation
let builderForClient = ClientCreator()
        
let client =  try builderForClient
    .setId(clientId: 1)
    .setSecondName(secondName: "mm")
    .setFirstName(fisrtName: "ee")
    .build()
    
let client1 =  try builderForClient
    .setId(clientId: 2)
    .setSecondName(secondName: "22")
    .setFirstName(fisrtName: "e222e")
    .build()
    
var bank = Bank(bankName: "tt", percentOnbalance: 0.5, isDependableLimit: 3000, commission: 30, downLimit: 20000, dateTill: 500)

bank.addClient(client: client, typeAccount: .debitAccount)
bank.addClient(client: client1, typeAccount: .debitAccount)
bank.printInfo()

let i: String = UUID().uuidString
print(i)

try bank.topUp(client: client1, money: 50000)
bank.printInfo()

try bank.transferMoney(money: 2000, from: client1, to: client)
bank.printInfo()
