//
//  LoginView.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var sign: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack(alignment: .top){
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height / 2, alignment: .center)
                    LottieView(name: "people", loop: true)
                        .frame(height: UIScreen.main.bounds.height / 2, alignment: .center)
                        .padding(.horizontal)
                        .offset(y: 20)
                        .scaleEffect(CGSize(width: 1.0, height: -1.0))
                }
                .clipShape(CustomShape())
                .scaleEffect(CGSize(width: 1.0, height: -1.0))
                VStack{
                    Text("InstantMatch")
                        .fontWeight(.bold)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 20)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Share your Instagram username with other people that you want")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    NavigationLink(destination: RegisterView()){
                        Text("Register")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
                            .frame(height: 50, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                            .cornerRadius(6)
                            .padding(25)
                    }
                    NavigationLink(destination: LoginView()){
                        HStack{
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Text("Login here")
                                .foregroundColor(.pink)
                                .underline()
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 2.5, alignment: .center)
                Spacer()
            }.edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }.accentColor(Color(UIColor(named: "Light")!))
    }
}

struct CustomShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            let pt1 = CGPoint(x: 0, y: 0)
            let pt2 = CGPoint(x: 0, y: rect.height)
            let pt3 = CGPoint(x: rect.width, y: rect.height)
            let pt4 = CGPoint(x: rect.width, y: 40)
            
            path.move(to: pt4)
            
            path.addArc(tangent1End: pt1, tangent2End: pt2, radius: 30)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 0)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 0)
            path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 25)
        }
    }
}
