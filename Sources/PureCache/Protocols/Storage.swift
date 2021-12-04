//
//  File.swift
//  
//
//  Created by Alessio Moiso on 04.12.21.
//

import Foundation

/// A generic protocol to read and write key-value pairs.
///
/// # Overview
/// When using instances of ``PureCache``, you can provide an additional
/// storage method than the default in-memory one, by implementing this protocol.
/// Each implementation of this protocol should be responsible of a single storage destination, such
/// as a file (see ``FileStorage``).
///
/// # Implementation
/// You are responsible of managing your storage destination in the best way possible,
/// but you should always try to provide a quick implementation of ``read()``, so that clients
/// that are using ``PureCache`` with your storage implementation can start reading values
/// as fast as possible
///
/// Unless your storage destination requires it, you shouldn't worry about thread safety, as ``PureCache`` instances
/// are already taking care of synchronizing the read and write operations.
public protocol Storage {
  
  /// Get the storage destination content as a key-value pairs.
  ///
  /// - note: This function is allowed to throw, but you should not throw errors
  /// if your storage destination doesn't exist. Instead, you should fail gracefully and assume
  /// the cache is empty.
  ///
  /// - throws: Errors occurred while trying to read.
  /// - returns: A dictionary representing what is stored in the storage destination.
  func read<Key: Codable & Hashable, Value: Codable>() throws -> [Key: Value]
  
  /// Replace the content of the storage destination with the passed key-value pairs.
  ///
  /// - parameters:
  ///   - content: A dictionary.
  /// - throws: Errors occurred while trying to save the new content.
  func write<Key: Codable & Hashable, Value: Codable>(_ content: [Key: Value]) throws
  
}
