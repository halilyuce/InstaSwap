//
//  RegisterView.swift
//  InstaMatch
//
//  Created by Halil Yuce on 22.11.2020.
//

import SwiftUI

struct RegisterView: View{
    
    @ObservedObject var authVM: AuthVM = .shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                Text("Welcome to InstaMatch!")
                    .fontWeight(.bold)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                TextField("Instagram Username", text: self.$authVM.register_username)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                TextField("Full Name", text: self.$authVM.register_name)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                TextField("E-mail", text: self.$authVM.register_email)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                SecureField("Password", text: self.$authVM.register_password)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                DatePicker(selection: self.$authVM.register_birthday, in: ...Date(), displayedComponents: .date) {
                    Text("Select Birthday:")
                        .foregroundColor(.gray)
                }.padding(.horizontal, 30).padding(.top, 10)
                HStack{
                    Text("Gender:")
                        .foregroundColor(.gray)
                        .frame(width:90, alignment: .leading)
                    Spacer()
                    Picker(selection: self.$authVM.register_gender, label: Text("Gender:")) {
                        ForEach(0 ..< self.authVM.genders.count) {
                            Text(self.authVM.genders[$0]).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }.padding(.horizontal, 30).padding(.vertical, 10)
                HStack{
                    Text("Lookin for:")
                        .foregroundColor(.gray)
                        .frame(width:90, alignment: .leading)
                    Spacer()
                    Picker(selection: self.$authVM.register_lookingfor, label: Text("Lookin for:")) {
                        ForEach(0 ..< self.authVM.lookingfor.count) {
                            Text(self.authVM.lookingfor[$0]).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }.padding(.horizontal, 30).padding(.top, 10).padding(.bottom, 30)
                Button(action: {
                    let instagram = URL(string: "instagram://user?username=halilyc")!
                        if UIApplication.shared.canOpenURL(instagram) {
                                UIApplication.shared.open(instagram, completionHandler: nil)
                            } else {
                                print("Instagram not installed")
                        }
                }, label: {
                    Text("Register Now")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50, alignment: .center)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                        .cornerRadius(6)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 25)
                })
                NavigationLink(destination: LoginView()){
                    HStack{
                        Text("Don't you have an account?")
                            .foregroundColor(.gray)
                        Text("Login here")
                            .foregroundColor(.pink)
                            .underline()
                        
                    }
                }.padding(.bottom)
            }.frame(maxHeight: .infinity).padding(.top, UIScreen.main.bounds.height / 8)
            ZStack(alignment: .topLeading){
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                    .clipShape(CustomShape())
                    .frame(height: UIScreen.main.bounds.height / 8, alignment: .center)
                    .scaleEffect(CGSize(width: 1.0, height: -1.0))
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(spacing:0){
                        Image(systemName: "chevron.left")
                            .font(.system(size: 21, weight: .medium))
                            .padding(.trailing, 8)
                        Text("Back")
                    }
                    .padding()
                    .padding(.top, UIScreen.main.bounds.width < 400 ? 20 : 40)
                }
            }
        }.edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}
