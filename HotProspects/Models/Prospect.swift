//
//  Prospect.swift
//  HotProspects
//
//  Created by Irakli Sokhaneishvili on 06.01.22.
//

import SwiftUI

//MARK: --> Model
class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

//MARK: --> ViewModel
@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    //let saveKey = "SavedData"
    let savepath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    init() {
        if let data = try? Data(contentsOf: savepath) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: savepath, options: [.atomic, .completeFileProtection])
        }
    }
    
    func add(_ prospet: Prospect) {
        people.append(prospet)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
