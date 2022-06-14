//
//  AlertView.swift
//  marpX (macOS)
//
//  Created by Thomas Bonk on 14.06.22.
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

import SwiftUI

struct AlertView: View {

  // MARK: - Public Properties

  var body: some View {
    VStack {
      HStack {
        Spacer()
        Text(alert.title).font(.title)
        Spacer()
      }

      HStack {
        AlertImage(size: 64)
          .padding(.all, 20)

        VStack {
          Text(alert.message).multilineTextAlignment(.center)
            .padding(.vertical, 15)

          if let err = alert.error {
            Text(err.localizedDescription)
          }
        }
      }
    }
    .padding(.vertical, 20)
  }

  var alert: Alert


  // MARK: - Private Methods

  private func AlertImage(size: CGFloat) -> some View {
    switch alert.alertType {
      case .none:
        return Image(systemName: "questionmark.square.dashed")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(.gray)
      case .information:
        return Image(systemName: "info.circle.fill")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(.green)
      case .warning:
        return Image(systemName: "exclamationmark.triangle.fill")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(.yellow)
      case .error:
        return Image(systemName: "exclamationmark.octagon.fill")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(.red)
      case .fatalError:
        return Image(systemName: "xmark.shield.fill")
          .resizable()
          .frame(width: size, height: size)
          .foregroundColor(.red)
    }
  }
}

