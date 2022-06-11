//
//  Marp.swift
//  marpX (macOS)
//
//  Created by Thomas Bonk on 11.06.22.
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
      // TODO Show error
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
      // TODO Show error
    }
  }
}
