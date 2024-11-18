//
//  Notification.swift
//  CheerUP
//
//  Created by 박수연 on 11/18/24.
//

import Foundation

struct Message: Decodable {
    let day: Int
    let message: String
}

struct Messages: Decodable {
    let messages: [Message]
}

func loadMessages() -> [Message]? {
    guard let url = Bundle.main.url(forResource: "messages", withExtension: "json") else {
        print("JSON 파일을 찾을 수 없습니다.")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let decodedData = try JSONDecoder().decode(Messages.self, from: data)
        return decodedData.messages
    } catch {
        print("JSON 파싱 에러: \(error)")
        return nil
    }
}
