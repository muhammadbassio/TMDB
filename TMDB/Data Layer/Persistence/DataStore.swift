//
// TMDB
// Copyright © 2018 Muhammad Bassio. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataSource {
  
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
