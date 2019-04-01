//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program

func printArgs() {
    for i in args {
        print(i, terminator: " ")
    }
    print("")
}

let acceptableCharacters = ["x", "/", "%", "(", ")", "+", "-"]

for i in args {
    if Int(i) == nil {
        if !acceptableCharacters.contains(i) {
            print("You have entered an invalid character")
            exit(1)
        }
    }
}

for i in 0..<args.count - 1 {
    let num1 = Int(args[i])
    if num1 != nil {
        let num2 = Int(args[i+1])
        if num2 != nil {
            exit(1)
        }
    }
}


for i in 0..<args.count {
    if args[i] == "x" || args[i] == "/" || args[i] == "%" {
        if args[i+1] == "x" || args[i+1] == "/" || args[i+1] == "%" {
            exit(1)
        }
        let prev = Int(args[i-1])
        let next = Int(args[i+1])
        var total = prev
        switch args[i] {
            case "x":
                if let prev = prev, let next = next {
                    let result = prev.multipliedReportingOverflow(by: next)
                    if result.overflow {
                        print("Multiplication error")
                        exit(1)
                    }
                    total = prev * next
                }
            case "/":
                if let prev = prev, let next = next {
                    let result = prev.dividedReportingOverflow(by: next)
                    if result.overflow {
                        print("Division error")
                        exit(1)
                    }
                    total = prev / next
                }
            case "%":
                if let prev = prev, let next = next {
                    let result = prev.remainderReportingOverflow(dividingBy: next)
                    if result.overflow {
                        print("Modulos error")
                        exit(1)
                    }
                    total = prev % next
                }
            default:
                exit(1);
        }
        if let total = total {
            args[i+1] = String(total)
            args[i] = "+"
            args[i-1] = "0"
        }
    }
}


for i in 0..<args.count {
    if args[i] == "+" || args[i] == "-" {
        let prev = Int(args[i-1])
        let next = Int(args[i+1])
        var total = prev
        switch args[i] {
        case "+":
            if let prev = prev, let next = next {
                let result = prev.addingReportingOverflow(next)
                if result.overflow {
                    print("Addition error")
                    exit(1)
                }
                total = prev + next
            }
        case "-":
            if let prev = prev, let next = next {
                let result = prev.subtractingReportingOverflow(next)
                if result.overflow {
                    print("Substraction error")
                    exit(1)
                }
                total = prev - next
            }
        default:
            exit(1)
        }
        if let total = total {
            args[i+1] = String(total)
            args[i] = "+"
            args[i-1] = "0"
        }
    }
}


let result = Int(args[args.count-1])!
print(result)
