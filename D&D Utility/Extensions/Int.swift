//
//  Int.swift
//  DNDUtility
//
//  Created by Caleb Chervenka on 11/14/22.
//

import Foundation


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^: PowerPrecedence
public func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

public extension Int {
    mutating func apply(_ mods: [Mod]) {
        for mod in mods {
            mod.applyTo(&self)
        }
    }
    func applying(_ mods: [Mod]) -> Int {
        var tmp = self
        for mod in mods {
            tmp.apply(mod)
        }
        return tmp
    }
    
    mutating func apply(_ mod: Mod) {
        mod.applyTo(&self)
    }
    func applying(_ mod: Mod) -> Int {
        var tmp = self
        mod.applyTo(&tmp)
        return tmp
    }
    
    enum Mod: Codable, Hashable, CaseIterable {
        public static var allCases: [Int.Mod] = [
            .add(0),
            .subtract(0),
            .subtractFrom(0),
            .multiply(0),
            .divideBy(0),
            .divideInto(0),
            .exponent(0),
            .exponentFor(0)
        ]
        
        public func getDescription(_ x: String) -> String {
            switch self {
            case .add(let n): return "\(n) + \(x)"
            case .divideBy(let n): return "\(x) / \(n)"
            case .divideInto(let n): return "\(n) / \(x)"
            case .exponent(let n): return "\(x)^\(n)"
            case .exponentFor(let n): return "\(n)^\(x)"
            case .multiply(let n): return "\(x)*\(n)"
            case .subtract(let n): return "\(x)-\(n)"
            case .subtractFrom(let n): return "\(n)-\(x)"
            }
        }
        
        /// Adds `n` to the value
        /// - Parameter n: The number to add
        case add(_ n: Int)
        
        /// Subtacts `n` from the value
        /// - Parameter n: The number to subtract
        case subtract(_ n: Int)
        
        /// Subtracts the value from `n`
        /// - Parameter n: The number to subtract _from
        case subtractFrom(_ n: Int)
        
        /// Multiplies the value by `n`
        /// - Parameter n: The number to multiply by
        case multiply(_ n: Int)
        
        /// Divides the value by `n`. Rounds down.
        /// - Parameter n: The number to divide into the value
        case divideBy(_ n: Int)
        
        /// Divides `n` by the value. Rounds down.
        /// - Parameter n: The number which the value will be divided by
        case divideInto(_ n: Int)
        
        /// Puts the value to the `n` power
        /// - Parameter n: The
        case exponent(_ n: Int)
        
        /// Puts `n` to the power of the value.
        case exponentFor(_ n: Int)
        
        public func applyTo(_ x: inout Int) {
            switch self {
            case .add(let n): x = (x + n)
            case .divideBy(let n): x = (x / n)
            case .divideInto(let n): x = (n / x)
            case .exponent(let n): x = (x ^^ n)
            case .exponentFor(let n): x = (n ^^ x)
            case .multiply(let n): x = (x * n)
            case .subtract(let n): x = (x - n)
            case .subtractFrom(let n): x = (n - x)
            }
        }
    }
}
