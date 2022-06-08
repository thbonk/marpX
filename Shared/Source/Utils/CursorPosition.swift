//
//  CursorPosition.swift
//  marpX
//
//  Created by Thomas Bonk on 08.06.22.
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
import Foundation

extension CodeEditor.Position {
  var cursor: NSRange? { selections.first { $0.length == 0 } }
}

func insertionPoint(of position: CodeEditor.Position) -> NSRange? {
  return position.selections.first(where: { $0.length == 0 })
}

func cursorPosition(for position: CodeEditor.Position, in document: MarpXDocument) -> (x: Int, y: Int) {
  if let rng = insertionPoint(of: position) {
    return cursorPosition(for: rng, in: document)
  }

  return (x: 1, y: 1)
}

func cursorPosition(for range: NSRange, in document: MarpXDocument) -> (x: Int, y: Int) {
  let index = document.text.index(document.text.startIndex, offsetBy: range.location)
  let textBeforeCursor = document.text.endIndex < index ? document.text[...index] : document.text[..<index]
  let y = textBeforeCursor.reduce(0, { $1 == "\n" ? $0 + 1 : $0 }) + 1
  let lastLine = textBeforeCursor.components(separatedBy: "\n").last
  let x = (lastLine?.count ?? 0) + 1

  return (x: x, y: y)
}
