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
    
//    init(date: Date, meal: String, kcal: String) {
//        data.date = date
//        data.getData(date: date, image: true)
//        self.meal = meal
//        self.kcal = kcal
//    }
    
    init(data: GetData) {
        self.data = data
        self.meal = data.meal ?? "에러"
        self.kcal = data.kcal ?? "에러"
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 2) {
                Text("Meals")
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                Text(meal)
                    .font(.system(size: 21))
                    .lineSpacing(2)
                Spacer()
                HStack {
                    Spacer()
                    Text("Calories")
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                HStack(alignment: .bottom, spacing: 2) {
                    Spacer()
                    Text(kcal)
                        .font(.largeTitle)
                        .bold()
                    Text("kcal")
                        .padding(.bottom, 4)
                }
                if data.dataIsLoaded {
                    if data.image!.size.width * data.image!.scale > 960 {
                        Image(uiImage: data.image!.rotate(radians: .pi * -0.5))
                            .resizable()
                            .cornerRadius(10)
                            .scaledToFit()
                            .padding(.top, 6)
                    } else {
                        Image(uiImage: data.image!)
                            .resizable()
                            .cornerRadius(10)
                            .scaledToFit()
                            .padding(.top, 6)
                    }
                } else if data.imageExists {
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                        Text("사진 로딩 중...")
                        Spacer()
                    }
                }
            }
            .padding()
            .navigationBarTitle(data.date.format())
        }
        .onAppear() {
            self.data.getData(date: self.data.date, image: true)
        }
    }
}

struct ShowDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowDetailsView(
            data: GetData()
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
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
