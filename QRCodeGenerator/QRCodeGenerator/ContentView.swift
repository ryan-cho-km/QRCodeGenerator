//
/******************************************************************************
 * Copyright (c) 2022 KineMaster Corp. All rights reserved.
 * https://www.kinemastercorp.com/
 *
 * THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
 * KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
 * PURPOSE.
 ******************************************************************************/

import SwiftUI

struct ContentView: View {
    @State var link = ""
    @State var qrImage: UIImage?
    
    var body: some View {
        VStack {
            Text("QRCodeGenerator")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
            
            HStack {
                TextField(
                    "weblink",
                    text: $link
                )
                .textFieldStyle(.roundedBorder)
                
                Button("Generate") {
                    qrImage = QRCodeGeneator.generate(text: link)
                }
                .buttonStyle(.bordered)
            }
            
            Divider()
            
            if let qrImage = qrImage {
                GeometryReader { proxy in
                    Image(uiImage: qrImage)
                        .resizable()
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.width
                        )
                        .overlay(
                            Image(systemName: "person.fill")
                        )
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .frame(height: 600, alignment: .top)
    }
}

import CoreImage.CIFilterBuiltins

struct QRCodeGeneator {
    static func generate(
        text: String
    ) -> UIImage? {
        let context = CIContext()
        let data = Data(text.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 20, y: 20)
        guard let outputImage = filter.outputImage?.transformed(by: transform) else {
            return nil
        }
        guard let cgImage = context.createCGImage(
            outputImage,
            from: outputImage.extent
        ) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
