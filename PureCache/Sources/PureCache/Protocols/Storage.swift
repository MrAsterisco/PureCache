//
//  File.swift
//  
//
//  Created by Alessio Moiso on 04.12.21.
//

import Foundation

public protocol Storage {
  func read<Key: Codable & Hashable, Value: Codable>() -> [Key: Value]
  func write<Key: Codable & Hashable, Value: Codable>(_ content: [Key: Value])
}
