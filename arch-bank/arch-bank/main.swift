import Foundation

let builderForClient = ClientCreator()

//создадим клиентов
let client =  try builderForClient
    .setId(clientId: 1)
    .setFirstName(fisrtName: "David")
    .setSecondName(secondName: "Adams")
    .build()
    
let client1 =  try builderForClient
    .setId(clientId: 2)
    .setFirstName(fisrtName: "John")
    .setSecondName(secondName: "Walker")
    .build()

let client2 =  try builderForClient
    .setId(clientId: 3)
    .setFirstName(fisrtName: "Amanda")
    .setSecondName(secondName: "Syfer")
    .setAddress(address: "Moscow")
    .setPassport(passportNumber: "44440-4443")
    .build()

var bank = Bank(bankName: "Timur's Bank", percentOnbalance: 0.03, isDependableLimit: 3000, commission: 30, downLimit: 20000, dateTill: 500)

//добавим данные клиентов в банк
bank.addClient(client: client, typeAccount: .debitAccount)
bank.addClient(client: client1, typeAccount: .depositAccount)
bank.addClient(client: client2, typeAccount: .creditAccount)
bank.printInfo()
 
var users = [String: Client]()
var idx = [String]()
for (key, value) in bank.clients{
    idx.append(key)
    for (kk, _) in value{
        users[key] = kk
    }
}

try bank.topUp(client: users[idx[0]]!, money: 50000, id: String(idx[0]))
try bank.withdrawMoney(client: users[idx[0]]!, money: 3000, id: String(idx[0]))
try bank.topUp(client: users[idx[2]]!, money: 60000, id: String(idx[2]))
bank.printInfo()

try bank.transferMoney(money: 3000, from: users[idx[0]]!, accountIdFrom:  String(idx[0]), to: users[idx[2]]!, accountIdTo: String(idx[2]))
bank.printInfo()

try bank.undo(client: users[idx[0]]!, id:  String(idx[0]))
bank.printInfo()

try bank.timeTravel(client: users[idx[0]]!, id: String(idx[0]), timeTravelPeriod: 1500)
