//
//  LoginView.swift
//  InstaSwap
//
//  Created by Halil Yuce on 21.11.2020.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var authVM: AuthVM = .shared
    
    var body: some View {
            VStack{
                ZStack(alignment: .top){
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height / 3, alignment: .center)
                    LottieView(name: "login", loop: true)
                        .frame(height: UIScreen.main.bounds.height / 3, alignment: .center)
                        .padding(.horizontal)
                        .offset(y: 20)
                        .scaleEffect(CGSize(width: 1.0, height: -1.0))
                }
                .clipShape(CustomShape())
                .scaleEffect(CGSize(width: 1.0, height: -1.0))
                VStack{
                    Text("Hello Again!")
                        .fontWeight(.bold)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 20)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    TextField("Username", text: self.$authVM.username)
                        .padding(12)
                        .background(Color(UIColor.systemGray6))
                        .mask(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 30)
                        .padding(.bottom, 10)
                    SecureField("Password", text: self.$authVM.password)
                        .padding(12)
                        .background(Color(UIColor.systemGray6))
                        .mask(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 30)
                        .padding(.bottom, 25)
                    Button(action: {}, label: {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                            .cornerRadius(6)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 25)
                    })
                    NavigationLink(destination: RegisterView()){
                        HStack{
                            Text("Don't you have an account?")
                                .foregroundColor(.gray)
                            Text("Register here")
                                .foregroundColor(.pink)
                                .underline()
                            
                        }
                    }
                    
                }
                .frame(height: UIScreen.main.bounds.height / 2.5, alignment: .center)
                Spacer()
            }.edgesIgnoringSafeArea(.top)
            .keyboardAwarePadding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}
