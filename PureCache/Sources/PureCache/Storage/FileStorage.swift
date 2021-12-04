//
//  File.swift
//  
//
//  Created by Alessio Moiso on 04.12.21.
//

import Foundation

final class FileStorage<Key: Codable & Hashable, Value: Codable>: Storage {
  private let url: URL
  private let queue = DispatchQueue(label: "io.github.mrasterisco.PureCache.fileStorage")
  
  init(url: URL) {
    self.url = url
  }
  
  func read() -> [Key: Value] {
    queue.sync {
      guard
        let content = FileManager.default.contents(atPath: url.path)
      else { return [:] }
      
      return (try? PropertyListDecoder().decode(
        [Key: Value].self,
        from: content
      )) ?? [:]
    }
  }
  
  func write(_ content: [Key: Value]) {
    queue.async(flags: .barrier) { [url] in
      (content as NSDictionary).write(to: url, atomically: true)
    }
  }
}

private extension FileStorage {
  func createFileIfNeeded() {
    queue.async(flags: .barrier) {
      
    }
  }
}
