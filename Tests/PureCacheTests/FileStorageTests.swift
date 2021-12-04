//
//  File.swift
//  
//
//  Created by Alessio Moiso on 04.12.21.
//

import XCTest
@testable import PureCache

final class FileStorageTests: XCTestCase {
  private static let temporaryURL = FileManager.default.temporaryDirectory.appendingPathComponent("Cache.db")
  
  override func tearDown() {
    do {
      try FileManager.default.removeItem(at: Self.temporaryURL)
    } catch { }
  }
  
  func testInitShouldNotCreateFile() {
    // GIVEN
    let url = Self.temporaryURL
    
    // WHEN
    _ = FileStorage(url: url)
    
    // THEN
    XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
  }
  
  func testReadUnexistingFile() {
    // GIVEN
    let url = Self.temporaryURL
    let storage = FileStorage(url: url)
    
    // WHEN
    let content: [Int: Int] = try! storage.read()
    
    // THEN
    XCTAssertTrue(content.isEmpty)
  }
  
  func testReadExistingFile() {
    // GIVEN
    let existingContent = [0: "Value0", 1: "Value1", 2: "Value2"]
    let url = Self.temporaryURL
    let storage = FileStorage(url: url)
    
    let existingData = try! PropertyListEncoder().encode(existingContent)
    try! existingData.write(to: Self.temporaryURL)
    
    // WHEN
    let retrievedContent: [Int: String] = try! storage.read()
    
    // THEN
    XCTAssertEqual(existingContent, retrievedContent)
  }
  
  func testWrite() {
    // GIVEN
    let contentToWrite = [UUID(): "Value0", UUID(): "Value1", UUID(): "Value2"]
    let url = Self.temporaryURL
    let storage = FileStorage(url: url)
    
    // WHEN
    try! storage.write(contentToWrite)
    
    // THEN
    guard let data = FileManager.default.contents(atPath: url.path) else { return XCTFail("File not found") }
    let writtenContent = try! PropertyListDecoder().decode([UUID: String].self, from: data)
    XCTAssertEqual(contentToWrite, writtenContent)
  }
}
