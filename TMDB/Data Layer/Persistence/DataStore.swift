//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataSource {
  
  static func saveQuery(query: String) {
    let history = DataSource.getHistory()
    var filteredHistory = history.filter { $0.lowercased() != query.lowercased() }
    filteredHistory.insert(query, at: 0)
    DataSource.save(history: filteredHistory)
  }
  
  static func getTopTen() -> [String] {
    let history = DataSource.getHistory()
    if history.count > 10 {
      return Array(history.prefix(10))
    }
    return history
  }
  
  static func save(history: [String]) {
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
      let fileURL = documentDirectory.appendingPathComponent("history.json")
      let json = JSON(history)
      let data = try json.rawData()
      try data.write(to: fileURL, options: .atomic)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  static func getHistory() -> [String] {
    var returnValue:[String] = []
    do {
      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
      let fileURL = documentDirectory.appendingPathComponent("history.json")
      let data = try Data(contentsOf: fileURL, options: .alwaysMapped)
      let json = try JSON(data: data)
      for item in json.arrayValue {
        returnValue.append(item.stringValue)
      }
      return returnValue
    } catch {
      print(error.localizedDescription)
      return returnValue
    }
  }
  
}
