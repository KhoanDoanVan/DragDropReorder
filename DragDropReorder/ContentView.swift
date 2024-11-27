//
//  ContentView.swift
//  DragDropReorder
//
//  Created by Đoàn Văn Khoan on 27/11/24.
//

import SwiftUI
import Kingfisher
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var tasks: [TaskPlant] = taskData
    @State private var draggedTask: TaskPlant?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 5) {
                ForEach(tasks) { task in
                    HStack {
                        KFImage(URL(string: task.imageCoverUrl))
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .scaledToFit()
                        
                        Text(task.plantName)
                            .strikethrough(task.status == .completed, color: .black)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                handleActionTask(task)
                            }
                        } label: {
                            Image(systemName: task.status == .pending ? "circle" : "circle.inset.filled")
                                .font(.title)
                        }
                    }
                    .padding(5)
                    .onDrag {
                        self.draggedTask = task
                        return NSItemProvider()
                    }
                    .onDrop(
                        of: [.text],
                        delegate: DropViewDelegate(
                            destinationItem: task,
                            tasks: $tasks,
                            draggedTask: $draggedTask
                        )
                    )
                }
                .padding()
            }
            .navigationTitle("Tasks")
        }
    }
    
    func handleActionTask(_ task: TaskPlant) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            switch tasks[index].status {
            case .completed:
                tasks[index].status = .pending
            case .pending:
                tasks[index].status = .completed
            }
        }
        
        sortTask()
    }
    
    func sortTask() {
        tasks = tasks.filter { $0.status == .pending } + tasks.filter { $0.status == .completed }
    }
}

struct DropViewDelegate: DropDelegate {
    let destinationItem: TaskPlant
    @Binding var tasks: [TaskPlant]
    @Binding var draggedTask: TaskPlant?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedTask = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        /// Swap Item
        if let draggedTask {
            if let fromIndex = tasks.firstIndex(of: draggedTask) {
                if let toIndex = tasks.firstIndex(of: destinationItem),
                   fromIndex != toIndex
                {
                    withAnimation {
                        self.tasks.move(
                            fromOffsets: IndexSet(integer: fromIndex),
                            toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex)
                        )
                        sortTask()
                    }
                }
            }
        }
    }
    
    func sortTask() {
        tasks = tasks.filter { $0.status == .pending } + tasks.filter { $0.status == .completed }
    }
}

#Preview {
    ContentView()
}
