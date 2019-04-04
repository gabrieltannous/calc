//
//  calculator.swift
//  calc
//
//  Created by Gabriel Tannous on 1/4/19.
//  Copyright © 2019 UTS. All rights reserved.
//

import Foundation

//List of errors to be thrown in this project
enum calculatorError: Error {
    case invalidInput(position: Int)
    case invalidOperator(position: Int)
    case consecutiveNumbers(position: Int)
    case consecutiveOperators(position: Int)
    case overflow
}

// Calculator class with the components
class calculator {
    let parantheses = ["(", ")"]
    let addition = "+", substraction = "-"
    let multiplication = "x", division = "/", remainder = "%"
    let zero = "0"
    
    //Returns only high operators (x, /, %)
    func getHighOperators() -> [String] {
        return [multiplication, division, remainder]
    }
    
    //Return only low operators (+, -)
    func getLowOperators() -> [String] {
        return [addition, substraction]
    }
    
    //Return high and low operators
    func getOperators() -> [String] {
        return getLowOperators() + getHighOperators()
    }
    
    //Call the calculate function to only calculate high operations
    func calculateHighOperators(equation: inout [String]) throws {
        for i in 0..<equation.count {
            if getHighOperators().contains(equation[i]) {
                try calculate(equation: &equation, index: i)
            }
        }
    }
    
    //Call the calculate function to only calculate low operations
    func calculateLowOperators(equation: inout [String]) throws {
        for i in 0..<equation.count {
            if getLowOperators().contains(equation[i]) {
                try calculate(equation: &equation, index: i)
            }
        }
    }
    
    //Parameters are equation with index of operator and calculate the numbers around this operator
    func calculate(equation: inout [String], index: Int) throws {
        let prev = Int(equation[index-1]) //previous number (as number on the left of the operator) at position index-1
        let next = Int(equation[index+1]) //next number (as number on the right of the operator) at position index+1
        if let prev = prev, let next = next {
            var total = Int()
            switch equation[index] {
                case multiplication:
                    let result = prev.multipliedReportingOverflow(by: next)
                    if result.overflow {
                        throw calculatorError.overflow
                    }
                    total = result.partialValue
                case division:
                    let result = prev.dividedReportingOverflow(by: next)
                    if result.overflow {
                        throw calculatorError.overflow
                    }
                    total = result.partialValue
                case remainder:
                    let result = prev.remainderReportingOverflow(dividingBy: next)
                    if result.overflow {
                        throw calculatorError.overflow
                    }
                    total = result.partialValue
                case addition:
                    let result = prev.addingReportingOverflow(next)
                    if result.overflow {
                        throw calculatorError.overflow
                    }
                    total = result.partialValue
                case substraction:
                    let result = prev.subtractingReportingOverflow(next)
                    if result.overflow {
                        throw calculatorError.overflow
                    }
                    total = result.partialValue
                default:
                    break;
            }
            // Set the total at the index+1 position to be usable in case it is needed for the next calculation
            equation[index+1] = String(total)
            equation[index] = addition
            equation[index-1] = zero
        }
    }
}
