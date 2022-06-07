//
//  MarpXDocument.swift
//  marpX
//
//  Created by Thomas Bonk on 02.06.22.
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

import SwiftShell
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
  static var exampleText: UTType {
    UTType(importedAs: "net.daringfireball.markdown", conformingTo: .plainText)
  }
}

struct MarpXDocument: FileDocument {
  
  // MARK: - Static Properties
  
  static var readableContentTypes: [UTType] { [.exampleText] }
  
  
  // MARK: - Public Properties
  
  var text: String {
    didSet {
      self.previewer?.saveTemporary(text: text)
    }
  }

  var previewUrl: URL? { self.previewer?.previewUrl }


  // MARK: - Private Properties

  private var previewer: MarpXDocumentPreviewer?
  
  
  // MARK: - Initialization
  
  init(text: String = "---\nmarpX<:\n\nmarp: true\n\nmarpX>:\n---\n\n") {
    self.text = text

    do {
      self.previewer = try MarpXDocumentPreviewer(marpExecutableUrl: URL(fileURLWithPath: "/usr/local/bin/marp"))
      self.previewer?.saveTemporary(text: self.text)
      try self.previewer?.startPreviewer()
    } catch {
      NSLog("MarpXDocument: Error while creating previewer; preview not available.")
      // TODO: Show error toast
    }
  }
  
  
  // MARK: - FileDocument
  
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents,
          let string = String(data: data, encoding: .utf8)
    else {
      throw CocoaError(.fileReadCorruptFile)
    }

    text = string

    do {
      self.previewer = try MarpXDocumentPreviewer(marpExecutableUrl: URL(fileURLWithPath: "/usr/local/bin/marp"))
      self.previewer?.saveTemporary(text: self.text)
      try self.previewer?.startPreviewer()
    } catch {
      NSLog("MarpXDocument: Error while creating previewer; preview not available.")
      // TODO: Show error toast
    }
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let data = text.data(using: .utf8)!
    return .init(regularFileWithContents: data)
  }
}
