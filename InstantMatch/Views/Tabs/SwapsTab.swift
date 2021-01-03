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
            if self.viewModel.status == .loading{
                VStack{
                    ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                }.frame(maxHeight: .infinity)
            }else if self.viewModel.status == .parseError {
                Text("An Error Occured!")
            }else{
                if self.viewModel.cards.count > 0 {
                    ForEach(viewModel.cards.reversed(), id: \._id){ person in
                        SwapCard(person: person)
                    }
                }else{
                    Text("It's done!")
                }
            }
        }
        .zIndex(1.0)
        .onAppear(){
            self.viewModel.loadCards()
        }
    }
}

struct SwapsTab_Previews: PreviewProvider {
    static var previews: some View {
        SwapsTab()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}
