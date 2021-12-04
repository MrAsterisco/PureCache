//
//  File.swift
//  
//
//  Created by Alessio Moiso on 04.12.21.
//

import Foundation

@available(macOS 10.15, *)
extension PureCache where Value: Identifiable, Key == Value.ID {
  
  /// Set the value using its `id` property as key.
  ///
  /// - parameters:
  ///   - value: An `Identifiable` value.
  func setValue(_ value: Value) {
    setValue(value, forKey: value.id)
  }
  
}
