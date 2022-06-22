//
//  Marp.swift
//  marpX (macOS)
//
//  Created by Thomas Bonk on 11.06.22.
//  Copyright 2022 Thomas Bonk <thomas@meandmymac.de>
//
//  Licensed under the Apache License, Version 2.0 (the "License")
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

  public static func startServer(for directoryUrl: URL) throws -> (port: UInt16, process: Process?, loggerTask: Task<Void, Never>?) {
    let port = findFreePort()
    let process = Process()
    let pipe = Pipe()

    process.standardOutput = pipe
    process.standardError = pipe

    process.executableURL = URL(fileURLWithPath: "/usr/local/bin/marp")
    process.arguments = [
      directoryUrl.path,
      "--watch",
      "--server",
    ]
    process.environment = ["PORT" : "\(port)"]
    try process.run()

    var request = URLRequest(url: URL(string: "http://localhost:\(port)")!)
    request.httpMethod = "GET"
    var available = false
    var response: URLResponse?

    while !available {
      do {
        try NSURLConnection.sendSynchronousRequest(request, returning: &response)

        if let httpResponse = response as? HTTPURLResponse {
          available = httpResponse.statusCode < 300
        }
      } catch {
        available = false
      }
    }

    let loggerTask = Task {
      while process.isRunning {
        if let data = try? pipe.fileHandleForReading.readToEnd() {
          let output = String(data: data, encoding: .utf8)!

          NSLog("\(output)")
        }
      }
    }

    return (port: port, process: process, loggerTask: loggerTask)
  }

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


  // MARK: - Private Static Methods

  private static func findFreePort() -> UInt16 {
    var port = UInt16.random(in: 1025...65535)

    let socketFD = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    if socketFD == -1 {
      //print("Error creating socket: \(errno)")
      return port
    }

    var hints = addrinfo(
      ai_flags: AI_PASSIVE,
      ai_family: AF_INET,
      ai_socktype: SOCK_STREAM,
      ai_protocol: 0,
      ai_addrlen: 0,
      ai_canonname: nil,
      ai_addr: nil,
      ai_next: nil
    )

    var addressInfo: UnsafeMutablePointer<addrinfo>? = nil
    var result = getaddrinfo(nil, "0", &hints, &addressInfo)
    if result != 0 {
      //print("Error getting address info: \(errno)")
      close(socketFD)

      return port
    }

    result = Darwin.bind(socketFD, addressInfo!.pointee.ai_addr, socklen_t(addressInfo!.pointee.ai_addrlen))
    if result == -1 {
      //print("Error binding socket to an address: \(errno)")
      close(socketFD)

      return port
    }

    result = Darwin.listen(socketFD, 1)
    if result == -1 {
      //print("Error setting socket to listen: \(errno)")
      close(socketFD)

      return port
    }

    var addr_in = sockaddr_in()
    addr_in.sin_len = UInt8(MemoryLayout.size(ofValue: addr_in))
    addr_in.sin_family = sa_family_t(AF_INET)

    var len = socklen_t(addr_in.sin_len)
    result = withUnsafeMutablePointer(to: &addr_in, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        return Darwin.getsockname(socketFD, $0, &len)
      }
    })

    if result == 0 {
      port = addr_in.sin_port
    }

    Darwin.shutdown(socketFD, SHUT_RDWR)
    close(socketFD)

    return port
  }
}
