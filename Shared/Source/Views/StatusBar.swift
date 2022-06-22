//
//  StatusBar.swift
//  marpX
//
//  Created by Thomas Bonk on 03.06.22.
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

import CodeEditorView
import SwiftUI

struct StatusBar: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    HStack {
      Text(
        String(format: "Line: %4u | Column: %4u",
               cursorPosition(for: position, in: document).y,
               cursorPosition(for: position, in: document).x))
      Text("|")
      Text(String(format: "Slide: %4u", document.slideNumber(for: position.cursor)))
      Text("|")
      Button {
        sourceMapVisible = !sourceMapVisible
      } label: {
        Image(systemName: sourceMapVisible ? "map.fill" : "map")
      }
      .help("Toggle Source Map")
      .keyboardShortcut("m", modifiers: .command)
      .buttonStyle(.plain)

      Spacer()
      
      Button {
        togglePreview()
      } label: {
        Image(systemName: previewVisible ? "tv.fill" : "tv")
      }
      .help("Toggle Preview")
      .keyboardShortcut("p", modifiers: .command)
      .buttonStyle(.plain)

      Text("|")
      
      Button {
        togglePresentation()
      } label: {
        Image(systemName: presentationVisible ? "play.tv.fill" : "play.tv")
      }
      .help("Show Presentation")
      .buttonStyle(.plain)
    }
    .padding([.leading, .trailing], 10)
    .padding(.bottom, 5)
    .padding(.top, -5)
  }
  
  @Binding
  var document: MarpXDocument
  
  @Binding
  var position: CodeEditor.Position
  
  @Binding
  var sourceMapVisible: Bool
  
  @Binding
  var previewVisible: Bool
  
  @Binding
  var speakerNotesVisible: Bool
  
  @Binding
  var presentationVisible: Bool


  // MARK: - Private Methods

  private func togglePreview() {
    previewVisible = !previewVisible
    if previewVisible {
      do {
        try document.startPreviewer()
      } catch {
        Alert.warning(
          message: "Error while creating preview document.\nPreview might not be visible",
          document: self.document,
          error: error)
        .show()
      }
    }
  }

  private func togglePresentation() {
    if !presentationVisible {
      do {
        try document.startPreviewer()
      } catch {
        Alert.warning(
          message: "Error while creating preview document.\nPreview might not be visible",
          document: self.document,
          error: error)
        .show()
      }
    }

    presentationVisible = !presentationVisible
  }
}
