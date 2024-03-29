//
//  UIGrid.swift
//  InstantMatch
//
//  Created by Halil Yuce on 10.01.2021.
//

import SwiftUI

// 'Content' here is used to store the View you defined in the Block
// 'T' is the object type of your list.
struct UIGrid<Content: View, T: Hashable>: View {
    
    private let columns: Int
    
    // Multi-dimensional array of your list. Modified as per rendering needs.
    private var list: [[T]] = []
    
    // This block you specify in 'UIGrid' is stored here
    private let content: (T) -> Content
    
    init(columns: Int, list: [T], @ViewBuilder content:@escaping (T) -> Content) {
        self.columns = columns
        self.content = content
        self.setupList(list)
    }

    // setupList(_:) Converts your array into multi-dimensional array.
    private mutating func setupList(_ list: [T]) {
        var column = 0
        var columnIndex = 0
        
        for object in list {
            if columnIndex < self.columns {
                if columnIndex == 0 {
                    self.list.insert([object], at: column)
                    columnIndex += 1
                }else {
                    self.list[column].append(object)
                    columnIndex += 1
                }
            }else {
                column += 1
                self.list.insert([object], at: column)
                columnIndex = 1
            }
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0 ..< self.list.count, id: \.self) { i  in
                HStack {
                    Spacer(minLength: 0)
                    ForEach(self.list[i], id: \.self) { object in
                        
                        // Your UI defined in the block is called from here.
                        self.content(object)
                            .frame(width: (UIScreen.main.bounds.size.width - 30)/CGFloat(self.columns))
                    }
                    Spacer(minLength: 0)
                }.padding(.bottom)
            }
        }
    }
    
}
