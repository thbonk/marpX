//
//  Alert.swift
//  marpX (macOS)
//
//  Created by Thomas Bonk on 13.06.22.
//  Copyright 2022 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import SwiftUI

struct Alert {

  // MARK: - Public Static Constants

  static let NotificationName = Notification.Name("ALERT_NOTIFICATION")


  // MARK: - Public Typealiases

  typealias DismissCallback = () -> ()


  // MARK: - Public Enums

  enum AlertType {
    case none
    case information
    case warning
    case error
    case fatalError
  }


  // MARK: - Public Properties

  let alertType: AlertType
  let message: String
  let document: Any?
  let error: Error?
  private(set) var dismissCallback: DismissCallback = {}

  var title: LocalizedStringKey {
    switch alertType {
      case .none:
        return LocalizedStringKey("!!!NONE!!!")
      case .information:
        return LocalizedStringKey("Information")
      case .warning:
        return LocalizedStringKey("Warning")
      case .error:
        return LocalizedStringKey("Error")
      case .fatalError:
        return LocalizedStringKey("Fatal Error")
    }
  }


  // MARK: - Initialization

  init(
    alertType: AlertType = .none,
    message: String = "",
    document: Any? = nil,
    error: Error? = nil,
    dismissCallback: DismissCallback? = nil) {

    self.alertType = alertType
    self.message = message
    self.document = document
    self.error = error

    if dismissCallback != nil {
      self.dismissCallback = dismissCallback!
    }
  }


  // MARK: - Static Methods

  static func information(message: String, document: Any? = nil) -> Alert {
    return Alert(alertType: .information, message: message, document: document)
  }

  static func warning(message: String, document: Any? = nil, error: Error? = nil) -> Alert {
    return Alert(alertType: .warning, message: message, document: document)
  }

  static func error(message: String, document: Any? = nil, error: Error? = nil) -> Alert {
    return Alert(alertType: .error, message: message, document: document, error: error)
  }

  static func fatalError(message: String, document: Any? = nil, error: Error? = nil, dismissCallback: DismissCallback? = nil) -> Alert {
    return Alert(alertType: .fatalError, message: message, document: document, error: error, dismissCallback: dismissCallback)
  }


  // MARK: - Public Methods

  func show() {
    NotificationCenter.default.post(name: Alert.NotificationName, object: self)
  }

  func isAlert(forDocument other: MarpXDocument) -> Bool {
    if alertType == .none {
      return false
    }
    
    if document == nil {
      return true
    }

    if let doc = (document as? MarpXDocument) {
      return doc.hashValue == other.hashValue
    }

    return true
  }
}
