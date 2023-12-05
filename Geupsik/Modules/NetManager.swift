//
//  NetManager.swift
//  NetManager
//
//  Created by 박성헌 on 2021/07/16.
//  Copyright © 2021 n30gu1. All rights reserved.
//

import Foundation
import Combine

final class NetManager {
    let API_KEY = "0c78f44ac03648f49ce553a199fc0389"
    
    func fetch(from: Date, to: Date) -> AnyPublisher<Any, URLError> {
        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "yyyyMMdd"
            return f
        }()
        
        let uri = "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=\(API_KEY)&Type=json&ATPT_OFCDC_SC_CODE=R10&SD_SCHUL_CODE=8750594&MLSV_FROM_YMD=\(dateFormatter.string(from: from))&MLSV_TO_YMD=\(dateFormatter.string(from: to))"

        return URLSession.shared.dataTaskPublisher(for: URL(string: uri)!)
            .receive(on: DispatchQueue.main)
            .map { return try! JSONSerialization.jsonObject(with: $0.data, options: []) }
            .eraseToAnyPublisher()
    }
}
