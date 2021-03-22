//
//  Helpers.swift
//  The First Neuron
//
//  Created by Mayank Bhaisora on 19/03/21.
//

import Foundation

class Helper {
    
    static func getArray(from range: Range<Int>) -> [Int] {
        return range.map { $0 }
    }
    
    static func getArray(from range: ClosedRange<Int>) -> [Int] {
        return range.map { $0 }
    }
    
    static func getRandomNumber(between min: Double, and max: Double) -> Double {
        let range = min...max
        return Double.random(in: range)
        
    }

    
}
