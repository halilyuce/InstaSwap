//
//  NoDataView.swift
//  InstantMatch
//
//  Created by Halil Yuce on 10.01.2021.
//

import SwiftUI

struct NoDataView: View {
    var body: some View {
        VStack{
            LottieView(name: "sad", loop: true)
                .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
            Text("Sorry, there is nothing to show here.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top)
                .padding(.horizontal, 50)
                .multilineTextAlignment(.center)
        }.frame(maxWidth: .infinity).offset(y: -50)
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView()
    }
}
