//
//  SwapsTab.swift
//  InstantMatch
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

struct SwapsTab: View {
    
    @ObservedObject var viewModel: ViewModel = .shared
    
    var body: some View {
        ZStack{
            if self.viewModel.status != .loading && self.viewModel.cards.count > 0 {
                ForEach(viewModel.cards.reversed(), id: \._id){ person in
                    SwapCard(person: person)
                }
            }
            
            if self.viewModel.status == .done && viewModel.cards.count == 0{
                NoDataView()
            }
            
            if self.viewModel.status == .loading{
                VStack{
                    ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                }.frame(maxHeight: .infinity)
            }
        }
        .zIndex(1.0)
        .onAppear(){
            if viewModel.cards.count == 0 {
                self.viewModel.loadCards()
            }
        }
        .alert(isPresented: .constant(self.viewModel.status == .parseError)) {
            Alert(title: Text("An error occured!"), message: Text(viewModel.errorDesc), dismissButton: Alert.Button.default(
                    Text("I got it")))
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
