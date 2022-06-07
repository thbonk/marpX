//
//  ContentView.swift
//  Shared
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

import CodeEditorView
import SwiftUI

struct ContentView: View {

  // MARK: - Public Properties

  var body: some View {
    VStack {
      if presentationVisible {
        WebView(url: document.previewUrl!)
          .keyboardShortcut(<#T##key: KeyEquivalent##KeyEquivalent#>)
      } else if previewVisible {
        GeometryReader { geo in
          ZStack {
            editor()
            PreviewView(url: document.previewUrl, size: $previewSize)
              .position(x: geo.size.width - previewSize.width / 2, y: geo.size.height - previewSize.height / 2)
          }
        }
      } else {
        editor()
      }

      StatusBar(
        document: $document,
        position: $position,
        sourceMapVisible: $sourceMapVisible,
        previewVisible: $previewVisible,
        speakerNotesVisible: $speakerNotesVisible,
        presentationVisible: $presentationVisible)
    }
  }

  @Binding
  var document: MarpXDocument


  // MARK: - Private Properties

  @State
  private var position = CodeEditor.Position()
  
  @State
  private var sourceMapVisible: Bool = true
  
  @State
  private var previewVisible: Bool = false
  
  @State
  private var speakerNotesVisible: Bool = false
  
  @State
  private var presentationVisible: Bool = false
  
  @State
  private var previewSize = CGSize(width: 480, height: 360)

  @State
  private var messages: Set<Located<Message>> = []

  @Environment(\.colorScheme)
  private var colorScheme: ColorScheme
  
  private let marpLanguage = LanguageConfiguration(
    stringRegexp: LanguageConfiguration.swift.stringRegexp,
    characterRegexp: nil,
    numberRegexp: LanguageConfiguration.swift.numberRegexp,
    singleLineComment: nil,
    nestedComment: (open: "<!--", close: "-->"),
    identifierRegexp: nil,
    reservedIdentifiers: [
      "---", "marp", "title", "description", "author", "keywords", "size", "url", "image", "theme", "paginate",
      "backgroundColor", "backgroundImage", "backgroundPosition", "backgroundrepeat", "backgroundSize",
      "color", "style", "header", "footer", "class", "w", "h", "width", "height",
      "blur", "brightness", "contrast", "drop-shadow", "grayscale", "hue-rotate", "invert", "opacity", "saturate",
      "sepia", "bg", "cover", "contain", "fit", "auto", "left", "right",
      "true", "false", "marpX"
    ])
  
  
  // MARK: - Private Methods
  
  private func editor() -> some View {
    CodeEditor(
      text: $document.text,
      position: $position,
      messages: $messages,
      language: marpLanguage,
      layout: CodeEditor.LayoutConfiguration(showMinimap: sourceMapVisible))
    .environment(\.codeEditorTheme, colorScheme == .dark ? Theme.defaultDark : Theme.defaultLight)
  }
}
