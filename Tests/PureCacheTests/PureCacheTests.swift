import XCTest
@testable import PureCache

final class PureCacheTests: XCTestCase {
  func testInit() throws {
    // WHEN
    let cache = PureCache<String, String>(storage: nil)
    
    // THEN
    XCTAssertEqual(0, cache.count)
  }
  
  func testStoreAndRetrieve() throws {
    // GIVEN
    let key = UUID()
    let value = "SomeValue"
    let queue = DispatchQueue(label: "test")
    let cache = PureCache<UUID, String>(queue: queue)
    
    // WHEN
    cache.setValue(value, forKey: key)
    let retrievedValue = cache.value(forKey: key)
    
    // THEN
    XCTAssertEqual(value, retrievedValue)
  }
  
  func testStoreAndRemove() throws {
    // GIVEN
    let key = UUID()
    let value = "SomeValue"
    let queue = DispatchQueue(label: "test")
    let cache = PureCache<UUID, String>(queue: queue)
    
    // WHEN
    cache.setValue(value, forKey: key)
    let tempRetrievedValue = cache.value(forKey: key)
    cache.removeValue(forKey: key)
    let afterDeletionRetrievedValue = cache.value(forKey: key)
    
    // THEN
    XCTAssertEqual(value, tempRetrievedValue)
    XCTAssertNil(afterDeletionRetrievedValue)
  }
  
  func testStorageAccess() throws {
    // GIVEN
    let existingKey = UUID()
    let existingValue = "SomeValue"
    
    let newKey = UUID()
    let newValue = "SomeOtherValue"
    
    let storage = StubStorage(content: [existingKey: existingValue])
    let queue = DispatchQueue(label: "test")
    let cache = PureCache<UUID, String>(storage: storage, queue: queue)
    
    // WHEN
    let retrievedExistingValue = cache.value(forKey: existingKey)
    cache.setValue(newValue, forKey: newKey)
    queue.flushAll()
    
    // THEN
    XCTAssertEqual(retrievedExistingValue, existingValue)
    XCTAssertEqual(storage.content[newKey], newValue)
  }
  
  func testConcurrentWrites() throws {
    // GIVEN
    let iterations = 1000
    let storage = StubStorage<Int, Int>()
    let queue = DispatchQueue(label: "test")
    let cache = PureCache<Int, Int>(storage: storage, queue: queue)
    
    let concurrentExpectation = XCTestExpectation()
    
    // WHEN
    DispatchQueue.concurrentPerform(iterations: iterations) { index in
      cache.setValue(index, forKey: index)
      guard index == iterations-1 else { return }
      concurrentExpectation.fulfill()
    }
    wait(for: [concurrentExpectation], timeout: 10)
    queue.flushAll()
    
    // THEN
    XCTAssertEqual(storage.content.keys.count, iterations)
    storage.content.forEach { (key, value) in
      XCTAssertEqual(key, value)
    }
  }
}

private extension PureCacheTests {
  class StubStorage<InnerKey: Codable & Hashable, InnerValue: Codable>: Storage {
    fileprivate var content: [InnerKey: InnerValue]
    
    init(content: [InnerKey: InnerValue] = [:]) {
      self.content = content
    }
    
    func read<Key: Codable & Hashable, Value: Codable>() throws -> [Key: Value] {
      content as! [Key: Value]
    }
    
    func write<Key: Codable & Hashable, Value: Codable>(_ content: [Key: Value]) throws {
      self.content = content as! [InnerKey: InnerValue]
    }
  }
}

private extension DispatchQueue {
  func flushAll() {
    sync { }
  }
}
