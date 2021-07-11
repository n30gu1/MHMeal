//
//  DateSelBoxView.swift
//  Geupsik
//
//  Created by 박성헌 on 2021/07/11.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import SwiftUI

struct DateSelBoxView: View {
    @State private var location: CGPoint = CGPoint(x: 0, y: 50)
    @State private var isOpened = false
    @GestureState private var fingerLocation: CGPoint? = nil
    @GestureState private var startLocation: CGPoint? = nil // 1
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location // 3
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location // 2
            }
    }
    
    var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.init(white: 0.8))
                    .frame(width: isOpened ? geometry.size.width * 0.96 : geometry.size.width * 0.9, height: 400)
                    .position(x: geometry.size.width / 2, y: location.y)
                    .gesture(
                        simpleDrag.simultaneously(with: fingerDrag)
                            .onEnded{ _ in
                                if location.y < geometry.size.height * 0.9 {
                                    withAnimation(.spring()) {
                                        location = CGPoint(x: 0, y: geometry.size.height / 2)
                                        isOpened = true
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        location = CGPoint(x: 0, y: geometry.size.height * 1.2)
                                        isOpened = false
                                    }
                                }
                            }
                    )
            }
            .onAppear {
                location = CGPoint(x: 0, y: geometry.size.height * 1.2)
            }
        }
    }
}

struct DateSelBoxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DateSelBoxView()
            DateSelBoxView()
                .previewDevice("iPhone SE (2nd generation)")
                .previewDisplayName("iPhone SE")
        }
    }
}
