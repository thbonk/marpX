//
//  MarpXApp.swift
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

import Combine
import SwiftUI

@main
struct MarpXApp: App {
  
  // MARK: - Public Properties
  
  var body: some Scene {
    DocumentGroup(newDocument: MarpXDocument()) { file in
      DocumentView(document: file.$document)
        .focusedSceneValue(\.marpDocument, file.$document)
    }.commands {
      CommandGroup(after: CommandGroupPlacement.saveItem) {
        Divider()
        Button("Export to PowerPoint (pptx)...") {
          if let doc = marpDocument {
            export(
              title: "Export to PowerPoint",
              message: "Export this presentation to PowerPoint (pptx)",
              pathExtension: "pptx",
              action: doc.exportPPTX(url:))
          }
        }
        .disabled(!marpDocumentSelected)
        .onAppear {
          marpDocumentSelected = (marpDocument != nil)
        }
        Button("Export to PDF...") {
          if let doc = marpDocument {
            export(
              title: "Export to PDF",
              message: "Export this presentation to PDF",
              pathExtension: "pdf",
              action: doc.exportPDF(url:))
          }
        }
        .disabled(!marpDocumentSelected)
        .onAppear {
          marpDocumentSelected = (marpDocument != nil)
        }
      }
    }
  }

  @FocusedBinding(\.marpDocument)
  var marpDocument: MarpXDocument?

  @State
  var marpDocumentSelected: Bool = false


  // MARK: - Private Methods

  private func export(title: String, message: String, pathExtension: String, action: (URL) -> ()) {
    let savePanel = NSSavePanel()
    savePanel.title = title
    savePanel.message = message
    savePanel.allowsOtherFileTypes = false

    savePanel.canCreateDirectories = true
    let response = savePanel.runModal()

    if response == .OK, let url = savePanel.url {
      action(url.appendingPathExtension(pathExtension))
    }
  }
}

struct MarpDocumentFocusedValueKey: FocusedValueKey {
  typealias Value = Binding<MarpXDocument>
}

extension FocusedValues {
  var marpDocument: MarpDocumentFocusedValueKey.Value? {
    get {
      return self[MarpDocumentFocusedValueKey.self]
    }

    set {
      self[MarpDocumentFocusedValueKey.self] = newValue
    }
  }
}
