//
//  TaskPlant.swift
//  DragDropReorder
//
//  Created by Đoàn Văn Khoan on 27/11/24.
//

import Foundation

enum StatusTask {
    case completed, pending
}

struct TaskPlant: Identifiable, Equatable {
    var id = UUID()
    var plantName: String
    var imageCoverUrl: String
    var status: StatusTask = .pending
}
