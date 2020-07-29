//
//  TodoItem.swift
//  TodoList
//
//  Created by Blink22 on 7/27/20.
//  Copyright © 2020 Blink22. All rights reserved.
//

import Foundation

struct TodoItem {
    var id: String
    var title: String
    var isChecked: Bool
    var details: String?
    
    init(title: String, isChecked: Bool, detail: String?, id: String?) {
        self.id = id ?? UUID().uuidString
        self.title = title
        self.isChecked = isChecked
        self.details = detail
    }
}
