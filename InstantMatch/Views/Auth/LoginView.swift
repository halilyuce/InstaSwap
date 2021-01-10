//
//  LoginView.swift
//  InstantMatch
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
                    TextField("E-mail", text: self.$authVM.email)
                        .padding(12)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
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
                    Button(action: {
                        self.authVM.login()
                    }, label: {
                        if self.authVM.status == .loading{
                            ActivityIndicatorView(isAnimating: .constant(true), style: .medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50, alignment: .center)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                                .cornerRadius(6)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 25)
                        }else{
                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50, alignment: .center)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                                .cornerRadius(6)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 25)
                                .opacity(checkForm() ? 0.5 : 1.0)
                        }
                    }).disabled(checkForm())
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
            .alert(isPresented: .constant(authVM.error && authVM.errorType == "Login")) {
                Alert(title: Text("An Error Occurred"), message: Text(authVM.errorDesc), dismissButton: Alert.Button.default(
                    Text("I got it"), action: { self.authVM.error = false }
                ))
            }
    }
    
    func checkForm() -> Bool {
        if self.authVM.email.isEmpty || self.authVM.password.isEmpty {
            return true
        }else{
            return false
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12 Pro")
    }
}
