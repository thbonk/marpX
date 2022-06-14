//
//  Marp.swift
//  marpX (macOS)
//
//  Created by Thomas Bonk on 11.06.22.
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

struct Marp {

  // MARK: - Static Methods

  public static func export(document: MarpXDocument, toPdf url: URL) {
    do {
      let temporaryFile = try TemporaryFile(creatingTempDirectoryForFilename: url.lastPathComponent + ".md")
      let process = Process()

      try document.text.write(to: temporaryFile.fileURL, atomically: true, encoding: .utf8)

      process.executableURL = URL(fileURLWithPath: "/usr/local/bin/marp")
      process.arguments = [
        temporaryFile.fileURL.path,
        "--pdf-notes",
        "--pdf",
        "-o",
        url.path
      ]

      try process.run()

      while process.isRunning {}

      try temporaryFile.deleteDirectory()
    } catch {
      Alert.error(
        message: "Error while exporting presentation to PDF.",
        document: self,
        error: error)
      .show()
    }
  }

  public static func export(document: MarpXDocument, toPptx url: URL) {
    do {
      let temporaryFile = try TemporaryFile(creatingTempDirectoryForFilename: url.lastPathComponent + ".md")
      let process = Process()

      try document.text.write(to: temporaryFile.fileURL, atomically: true, encoding: .utf8)

      process.executableURL = URL(fileURLWithPath: "/usr/local/bin/marp")
      process.arguments = [
        temporaryFile.fileURL.path,
        "--pptx",
        "-o",
        url.path
      ]

      try process.run()

      while process.isRunning {}

      try temporaryFile.deleteDirectory()
    } catch {
      Alert.error(
        message: "Error while exporting presentation to PowerPoint.",
        document: self,
        error: error)
      .show()
    }
  }
}
