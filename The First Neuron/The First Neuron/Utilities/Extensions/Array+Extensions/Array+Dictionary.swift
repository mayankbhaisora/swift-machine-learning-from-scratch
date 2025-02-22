//
//  String+Extensions.swift
//  The First Neuron
//
//  Created by Mayank Bhaisora on 19/03/21.
//

import Foundation

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
