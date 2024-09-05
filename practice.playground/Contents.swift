import UIKit


// the sorted method
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames 的值為 ["Ewa", "Daniella", "Chris", "Barry", "Alex"]


// Closure expression syntax 閉包表達式語法
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 })
// Inferring Type From Context 從上下文推斷類型
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 })
// Implicit Returns from Single-Expression Closures 單表達式閉包的隱式返回
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })
// Shorthand Argument Names 簡寫參數名稱
reversedNames = names.sorted(by: { $0 > $1 } )
// Operator Methods **操作符方法**
reversedNames = names.sorted(by: >)

// Trailing Closures 尾隨閉包//
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函數體
}

// 以下是未使用尾隨閉包調用該函數的方法：
someFunctionThatTakesAClosure(closure: {
    // 閉包體
})

// 以下是使用尾隨閉包調用該函數的方法：
someFunctionThatTakesAClosure() {
    // 尾隨閉包體
}
reversedNames = names.sorted() { $0 > $1 }
reversedNames = names.sorted { $0 > $1 }

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
// strings 被推斷為 [String] 類型
// 它的值為 ["OneSix", "FiveEight", "FiveOneZero"]

struct Picture {
    // 定義 Picture 的屬性和方法
}

struct Server {
    // 定義 Server 的屬性和方法
}

struct View {
    var currentPicture: Picture?
}

let someServer = Server()
var someView = View()

func download(_ imageName: String, from server: Server) -> Picture? {
    // 實現下載邏輯，這裡簡單返回一個 Picture 或 nil
    return Picture()
}

func loadPicture(from server: Server, completion: (Picture) -> Void, onFailure: () -> Void) {
    if let picture = download("photo.jpg", from: server) {
        completion(picture)
    } else {
        onFailure()
    }
}

loadPicture(from: someServer) { picture in
    someView.currentPicture = picture
} onFailure: {
    print("無法下載下一張圖片。")
}


// Capturing Values 捕獲值//
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)

incrementByTen()
// 返回值為 10

incrementByTen()
// 返回值為 20

incrementByTen()
// 返回值為 30

let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven()
// 返回值為 7

incrementByTen()
// 返回值為 40


// Closures Are Reference Types 閉包是引用類型//
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
// 返回值為 50

incrementByTen()
// 返回值為 60


// Escaping Closures 逃逸閉包//
var completionHandlers: [() -> Void] = []

func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// 打印 "200"

completionHandlers.first?()
print(instance.x)
// 打印 "100"

class SomeOtherClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { [self] in x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

struct SomeStruct {
    var x = 10
    mutating func doSomething() {
        someFunctionWithNonescapingClosure { x = 200 }  // 可以
        someFunctionWithEscapingClosure { x = 100 }     // 錯誤
    }
}


// Autoclosures 自動閉包
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// 打印 "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// 打印 "5"

print("正在為 \(customerProvider()) 提供服務!")
// 打印 "正在為 Chris 提供服務!"
print(customersInLine.count)
// 打印 "4"

// customersInLine 是 ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("正在為 \(customerProvider()) 提供服務!")
}
serve(customer: { customersInLine.remove(at: 0) })
// 打印 "正在為 Alex 提供服務!"

// customersInLine 是 ["Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("正在為 \(customerProvider()) 提供服務!")
}
serve(customer: customersInLine.remove(at: 0))
// 打印 "正在為 Ewa 提供服務!"

// customersInLine 是 ["Barry", "Daniella"]
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customersInLine.remove(at: 0))
collectCustomerProviders(customersInLine.remove(at: 0))

print("已收集 \(customerProviders.count) 個閉包。")
// 打印 "已收集 2 個閉包。"
for customerProvider in customerProviders {
    print("正在為 \(customerProvider()) 提供服務!")
}
// 打印 "正在為 Barry 提供服務!"
// 打印 "正在為 Daniella 提供服務!"














