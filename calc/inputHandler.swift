//
//  inputHandler.swift
//  calc
//
//  Created by Gabriel Tannous on 1/4/19.
//  Copyright © 2019 UTS. All rights reserved.
//

import Foundation

class inputHandler {
    //Returns acceptable operators
    func getAcceptableOperators() -> [String] {
        return calculator().getHighOperators() + calculator().getLowOperators() + calculator().parantheses
    }
    
    //Perform all input checks on the equation by calling all functions
    func checkEquation(equation: [String]) throws {
        try checkInvalidCharaters(equation: equation)
        try checkConsecutiveOperators(equation: equation)
        try checkConsecutiveNumbers(equation: equation)
        try checkFirstInput(equation: equation)
        try checkLastInput(equation: equation)
    }

    //Check for unacceptable characters entered
    func checkInvalidCharaters(equation: [String]) throws {
        for i in equation {
            if Int(i) == nil {
                if !getAcceptableOperators().contains(i) {
                    throw calculatorError.invalidInput(position: equation.firstIndex(of: i)! + 1)
                }
            }
        }
    }

    //Check for consecutive high operators entered with no numbers in between
    func checkConsecutiveOperators(equation: [String]) throws {
        let operators = calculator().getOperators()
        for i in 0..<equation.count - 1 {
            if operators.contains(equation[i]) {
                if operators.contains(equation[i+1]) {
                    throw calculatorError.consecutiveOperators(position: i+1)
                }
            }
        }
    }
    
    //Check for consecutive numbers entered with no operator in between
    func checkConsecutiveNumbers(equation: [String]) throws {
        for i in 0..<equation.count - 1 {
            let num1 = Int(equation[i])
            if num1 != nil {
                let num2 = Int(equation[i+1])
                if num2 != nil {
                    throw calculatorError.consecutiveOperators(position: i+1)
                }
            }
        }
    }
    
    //Check that first input is not a high operator
    func checkFirstInput(equation: [String]) throws {
        if calculator().getHighOperators().contains(equation[0]) {
            throw calculatorError.invalidOperator(position: 1)
        }
    }
    
    //Check that last input is not a high operator
    func checkLastInput(equation: [String]) throws {
        if calculator().getHighOperators().contains(equation[equation.count-1]) {
            throw calculatorError.invalidOperator(position: equation.count)
        }
    }
}
