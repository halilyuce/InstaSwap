//
//  RequestsTab.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

struct RequestsTab: View {
    @ObservedObject var viewModel: ViewModel = .shared
    var body: some View {
        NavigationView{
            List{
                ForEach(viewModel.data, id:\.id){ person in
                    HStack(alignment:.top){
                        Image(person.images.first!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 42, height: 42, alignment: .center)
                            .cornerRadius(21)
                            .padding(.trailing, 10)
                        VStack(alignment: .leading, spacing:3){
                            Text(person.name)
                                .fontWeight(.semibold)
                            Text("Here is my Insta! Follow me 😉")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                            Text("Yesterday")
                                .font(.system(size: 11))
                                .foregroundColor(Color(UIColor.systemGray3))
                            HStack{
                                Button(action: {}, label: {
                                    Text("No, Thanks")
                                        .font(.system(size: 15))
                                        .foregroundColor(.accentColor)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                    
                                })
                                Spacer(minLength: 20)
                                Button(action: {}, label: {
                                    ZStack(alignment:.trailing){
                                        Text("Follow")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(Color.pink)
                                            .cornerRadius(8)
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13, weight: .black))
                                            .foregroundColor(Color.white)
                                            .offset(x: -10)
                                    }
                                })
                            }.padding(.top, 10)
                        }
                    }.padding(.vertical, 8)
                }
            }
            .navigationBarTitle(Text("Requests"))
        }.phoneOnlyStackNavigationView()
    }
}

struct RequestsTab_Previews: PreviewProvider {
    static var previews: some View {
        RequestsTab()
    }
}
