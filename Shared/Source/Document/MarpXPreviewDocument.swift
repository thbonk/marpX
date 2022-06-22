//
//  MarpXPreviewDocument.swift
//  marpX (macOS)
//
//  Created by Thomas Bonk on 07.06.22.
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

class MarpXPreviewDocument {

  // MARK: - Public Properties

  public var isRunning: Bool { marpProcess != nil && marpProcess!.isRunning }
  public var presentationUrl: URL?


  // MARK: - Initialization

  init(marpExecutableUrl url: URL) throws {
    marpExecutableUrl = url
    temporaryMarpXFileUrl = try TemporaryFile(creatingTempDirectoryForFilename: UUID().uuidString + ".md")

    NSLog("Temporary Marp file: \(self.temporaryMarpXFileUrl.fileURL.path)")
  }

  deinit {
    stopPreviewer()

    do {
      try temporaryMarpXFileUrl.deleteDirectory()
    } catch {
      NSLog("MarpXDocumentPreviewer: Error while deleting temporary files")
    }
  }

  // MARK: - Private Properties
  private let saveQueue = DispatchQueue(label: UUID().uuidString, qos: .background)
  private var marpExecutableUrl: URL
  private var marpProcess: Process?
  private var loggerTask: Task<Void, Never>?
  private var port: UInt16 = 0
  private var temporaryMarpXFileUrl: TemporaryFile


  // MARK: - Public Methods

  public func startPreviewer() throws {
    guard !isRunning else {
      return
    }

    let result = try Marp.startServer(for: temporaryMarpXFileUrl.directoryURL)
    marpProcess = result.process
    loggerTask = result.loggerTask
    port = result.port

    self.presentationUrl = URL(string: "http://localhost:\(port)/\(temporaryMarpXFileUrl.fileURL.lastPathComponent)")
    NSLog("Presentation URL: \(String(describing: self.presentationUrl))")
  }

  public func stopPreviewer() {
    guard isRunning else {
      return
    }

    marpProcess?.terminate()
    marpProcess = nil
    loggerTask?.cancel()
    loggerTask = nil
    port = 0
  }

  public func saveTemporary(text: String) {
    saveQueue.async {
      do {
        try text.write(to: self.temporaryMarpXFileUrl.fileURL, atomically: true, encoding: .utf8)
      } catch {
        NSLog("MarpXDocumentPreviewer: Error while writing temporary file")

        Alert.error(
          message: "Error while creating preview document.\nPreview might not be visible",
          document: self,
          error: error)
        .show()
      }
    }
  }
}
