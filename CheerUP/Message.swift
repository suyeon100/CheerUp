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
    guard let url = Bundle.main.url(forResource: "NotificationMassege", withExtension: "json") else {
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
func getMessageForToday(startDate: Date, messages: [Message]) -> String? {
    let calendar = Calendar.current
    let today = Date()
    guard let daysPassed = calendar.dateComponents([.day], from: startDate, to: today).day else {
        return nil
    }

    let currentDay = daysPassed + 1 // 1일부터 시작
    print("currentDay == \(currentDay)")
    return messages.first { $0.day == currentDay }?.message
}
