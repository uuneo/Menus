//
//  DropDelegate+.swift
//  PeacockMenus
//
//  Created by He Cho on 2024/9/6.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct DropViewDelegate<Item: Equatable>: DropDelegate {
    let item: Item
    @Binding var items: [Item]
    @Binding var draggedItem: Item?

    func dropEntered(info: DropInfo) {
        guard let draggedItem = draggedItem else { return }
        if draggedItem != item {
            guard let fromIndex = items.firstIndex(of: draggedItem),
                  let toIndex = items.firstIndex(of: item) else { return }
            withAnimation {
                items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
}

struct DragAndDropModifier<Item: Equatable>: ViewModifier {
    let item: Item
    @Binding var items: [Item]
    @Binding var draggedItem: Item?
    let getDragItem: () -> NSItemProvider
    
    func body(content: Content) -> some View {
        content
            .onDrag {
                draggedItem = item
                return getDragItem()
            }
            .onDrop(of: [UTType.text], delegate: DropViewDelegate(item: item, items: $items, draggedItem: $draggedItem))
    }
}


extension View {
    func draggable<Item: Equatable>(
        item: Item,
        items: Binding<[Item]>,
        draggedItem: Binding<Item?>,
        getDragItem: @escaping () -> NSItemProvider
    ) -> some View {
        self.modifier(DragAndDropModifier(item: item, items: items, draggedItem: draggedItem, getDragItem: getDragItem))
    }
}
