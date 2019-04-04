//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

// Gets all the arguments passed
var args = ProcessInfo.processInfo.arguments
// Remove the name of the program
args.removeFirst()

// Calls the functions to perform the calculation (Checking the equation and calculating)
func calculate(equation: inout [String]) throws {
    try inputHandler().checkEquation(equation: equation)
    try calculator().calculateHighOperators(equation: &equation)
    try calculator().calculateLowOperators(equation: &equation)
    let result = Int(equation[equation.count-1])!
    print(result)
}

// Calls the above function and catch all errors thrown in this project
do {
    try calculate(equation: &args)
} catch calculatorError.invalidInput(let position) {
    print("Invalid input entered at position: \(position)")
    exit(2)
} catch calculatorError.invalidOperator(let position) {
    print("Invalid operator entered at position: \(position)")
    exit(3)
} catch calculatorError.consecutiveNumbers(let position) {
    print("Consecutive numbers entered at position: \(position)")
    exit(2)
} catch calculatorError.consecutiveOperators(let position) {
    print("Consecutive operators entered at position: \(position)")
    exit(2)
} catch calculatorError.overflow {
    print("Overflow error (result exceeds the limits of Int)")
    exit(3)
}
