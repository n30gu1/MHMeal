//
//  ShowDetailsView.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/02/03.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import SwiftUI

struct ShowDetailsView: View {
    @ObservedObject var data = GetData()
    var meal: String = ""
    var kcal: String = ""
    
    init(date: Date, meal: String, kcal: String) {
        data.date = date
        data.getData(date: date, image: true)
        self.meal = meal
        self.kcal = kcal
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text(meal)
                    .font(.system(size: 21))
                Spacer()
                HStack(alignment: .bottom, spacing: 2) {
                    Spacer()
                    Text(kcal)
                        .font(.largeTitle)
                        .bold()
                    Text("kcal")
                        .padding(.bottom, 3)
                }
                if data.dataIsLoaded {
                    Image(uiImage: data.image!.rotate(radians: .pi * -0.5))
                        .resizable()
                        .cornerRadius(10)
                        .scaledToFit()
                }
            }
            .padding()
            .navigationBarTitle(data.date.format())
        }
    }
}

struct ShowDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDetailsView(
            date: Date().addingTimeInterval(-60*60*24*152), meal: "급식이 없습니다.", kcal: "1911"
        )
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
