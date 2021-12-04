//
//  File.swift
//  
//
//  Created by Alessio Moiso on 04.12.21.
//

import Foundation

/// A simple, fast and easy-to-use cache system for `Codable` values.
///
/// # Overview
/// A mutable collection you can use to store temporary key-value pairs that are usually
/// the result of a complex or long operation.
///
/// This class is always thread-safe, meaning that it can be shared among multiple threads
/// and different objects.
///
/// # Storage
/// By default, the collection of values is only stored in memory. You can opt-in for disk
/// storage as well, by providing an implementation of ``Storage``. The library already provides ``FileStorage``.
/// When storage is provided, values are immediately saved in memory and then
/// a background task is deferred to also save on the provided storage.
///
/// # Queues
/// If not otherwise specified, all read and write operation will happen synchronously on a concurrent
/// queue that is generated for each instance. You can specify your own queue, but you're then
/// responsible of managing it and its attributes.
/// - note: If a storage is provided, you must ensure that the provided queue has the `concurrent` attribute.
/// Using a serial queue will result in the storage write operation blocking reads and writes on the in memory cache, which
/// is usually an undesired side effect.
public final class PureCache<Key: Hashable & Codable, Value: Codable> {
  private let storage: Storage?
  private let queue: DispatchQueue
  
  private var content = [Key: Value]()
  
  /// Create a new instance.
  ///
  /// - parameters:
  ///   - storage: An additional storage, other than the default in memory one. If not provided, the cached values will be destroyed once this instance is deallocated.
  ///   - queue: A queue to run read and write operations on. By default, a new concurrent queue will be generated for this instance.
  init(storage: Storage? = nil, queue: DispatchQueue = .init(label: "io.github.mrasterisco.PureCache", attributes: .concurrent)) {
    self.storage = storage
    self.queue = queue
    readFromStorage()
  }
  
  /// Get the count of keys that are currently stored in the cache.
  var count: Int {
    content.keys.count
  }
  
  /// Get the value associated with the given key.
  ///
  /// - parameters:
  ///   - key: A key.
  /// - returns: The associated value (if any).
  func value(forKey key: Key) -> Value? {
    queue.sync {
      content[key]
    }
  }
  
  /// Set the value of the specified key in the cache.
  ///
  /// - parameters:
  ///   - value: A value.
  ///   - key: A key.
  func setValue(_ value: Value, forKey key: Key) {
    queue.sync(flags: .barrier) { [weak self] in
      self?.content[key] = value
    }
    writeToStorage()
  }
  
  /// Remove the value of the specified key from the cache.
  ///
  /// - parameters:
  ///   - key: A key.
  func removeValue(forKey key: Key) {
    queue.sync(flags: .barrier) { [weak self] in
      _ = self?.content.removeValue(forKey: key)
    }
    writeToStorage()
  }
}

// MARK: - Storage Management
private extension PureCache {
  func readFromStorage() {
    content = (try? storage?.read()) ?? [:]
  }
  
  func writeToStorage() {
    queue.async(flags: .barrier) { [storage, content] in
      do {
        try storage?.write(content)
      } catch { }
    }
  }
}
