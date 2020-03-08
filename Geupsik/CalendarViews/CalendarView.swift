//
//  CalendarView.swift
//  Geupsik
//
//  Created by 박성헌 on 2020/03/04.
//  Copyright © 2020 n30gu1. All rights reserved.
//

import UIKit
import SwiftUI

struct CalendarView: UIViewControllerRepresentable {
    @Binding var date: Date
    func makeUIViewController(context: Context) -> CalendarViewController {
        let vc = UIStoryboard(name: "Calendar", bundle: nil)
            .instantiateInitialViewController() as! CalendarViewController
        vc.date = self.date
        return vc
    }
    
    func updateUIViewController(_ vc: CalendarViewController, context: Context) {
        self.date = vc.date
    }
}
