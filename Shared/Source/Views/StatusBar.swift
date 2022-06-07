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
      Text("Line: \(cursorPosition.y) | Column: \(cursorPosition.x)")
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
        previewVisible = !previewVisible
      } label: {
        Image(systemName: previewVisible ? "tv.fill" : "tv")
      }
      .help("Toggle Preview")
      .keyboardShortcut("p", modifiers: .command)
      .buttonStyle(.plain)
      
      /*
      Text("|")
      
      Button {
        speakerNotesVisible = !speakerNotesVisible
      } label: {
        Image(systemName: speakerNotesVisible ? "note.text" : "note")
      }
      .help("Show Speaker Notes")
      .buttonStyle(.plain)
      
      Button {
        presentationVisible = !presentationVisible
      } label: {
        Image(systemName: presentationVisible ? "play.tv.fill" : "play.tv")
      }
      .help("Show Presentation")
      .buttonStyle(.plain)
       */
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
  
  
  // MARK: - Private Properties
  
  private var cursorPosition: (x: Int, y: Int) {
    if let rng = position.selections.first(where: { $0.length == 0 }) {
      let index = document.text.index(document.text.startIndex, offsetBy: rng.location)
      let textBeforeCursor = document.text.endIndex < index ? document.text[...index] : document.text[..<index]
      let y = textBeforeCursor.reduce(0, { $1 == "\n" ? $0 + 1 : $0 }) + 1
      let lastLine = textBeforeCursor.components(separatedBy: "\n").last
      let x = (lastLine?.count ?? 0) + 1
      
      return (x: x, y: y)
    }
    
    return (x: 1, y: 1)
  }
}
