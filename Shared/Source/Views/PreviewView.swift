//
//  PreviewView.swift
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

import SwiftUI

struct PreviewView: View {
  
  // MARK: - Public Properties
  
  var body: some View {
    Group {
      if url == nil {
        Text("No Preview URL available!")
          .zIndex(0)
      } else {
        WebView(url: url!)
          .zIndex(0)
      }
    }
    .frame(width: size.width, height: size.height)
    .background(.white)
    .foregroundColor(.black)
  }
  
  var url: URL?
  
  @Binding
  var size: CGSize
  
  
  // MARK: - Private Properties
  
  @State
  private var width: CGFloat = 320
  
  @State
  private var height: CGFloat = 240
}

