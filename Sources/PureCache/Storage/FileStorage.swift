//
//  File.swift
//  
//
//  Created by Alessio Moiso on 04.12.21.
//

import Foundation

/// A basic implementation of ``Storage`` that reads and writes from
/// and to a file on the disk.
///
/// # Overview
/// You can use this class with instances of ``PureCache`` to store
/// the cached values on the disk.
///
/// This class is **not** thread-safe and should not be shared
/// among multiple threads, unless properly synchronized.
///
/// # File Management
/// This implementation tries to avoid creating the file on the disk
/// until it's actually needed. Once the file is created, it is always replaced
/// completely when the `write` function is called.
public final class FileStorage: Storage {
  private let url: URL
  
  /// Create a new instance for the file at the specified URL.
  ///
  /// - note: You can default to the recommend folder for storing
  /// cache data that the system provides by passing `nil` in `url`.
  /// If you decide to do so, this class will attempt to get the cache directory URL
  /// of the current user; if this fails, it will default to the temporary directory URL.
  /// `Cache.db` will be used as default file name.
  ///
  /// - parameters:
  ///   - url: A file URL.
  public init(url: URL? = nil) {
    self.url = url ?? Self.defaultDirectoryURL.appendingPathComponent(Self.defaultCacheFileName)
  }
  
  public func read<Key: Codable & Hashable, Value: Codable>() throws -> [Key : Value] {
    guard
      let content = FileManager.default.contents(atPath: url.path)
    else { return [:] }
    
    return try PropertyListDecoder().decode(
      [Key: Value].self,
      from: content
    )
  }
  
  public func write<Key: Codable & Hashable, Value: Codable>(_ content: [Key : Value]) throws {
    let data = try PropertyListEncoder().encode(content)
    try data.write(to: url, options: .atomic)
  }
}

private extension FileStorage {
  static var defaultCacheFileName: String {
    "Cache.db"
  }
  
  static var defaultDirectoryURL: URL {
    (try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)) ?? Self.temporaryDirectoryURL
  }
  
  static var temporaryDirectoryURL: URL {
    FileManager.default.temporaryDirectory
  }
}
