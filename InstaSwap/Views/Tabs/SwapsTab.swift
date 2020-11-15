//
//  SwapsTab.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

struct SwapsTab: View {
    
    @ObservedObject var viewModel: ViewModel = .shared
    
    var body: some View {
        ZStack{
            ForEach(viewModel.data.reversed()){ person in
                SwapCard(person: person)
            }
        }
        .zIndex(1.0)
    }
}

struct SwapsTab_Previews: PreviewProvider {
    static var previews: some View {
        SwapsTab()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}
