//
//  RegisterView.swift
//  InstantMatch
//
//  Created by Halil Yuce on 22.11.2020.
//

import SwiftUI

struct RegisterView: View{
    
    @State var showsDatePicker = false
    @ObservedObject var authVM: AuthVM = .shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let max = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
    
    let dateFormatter: DateFormatter = {
          let df = DateFormatter()
          df.dateStyle = .medium
          return df
      }()
    
    var body: some View {
        ZStack(alignment: .top){
            ScrollView{
                Text("Welcome to InstaMatch!")
                    .fontWeight(.bold)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                    .font(.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                TextField("Instagram Username", text: self.$authVM.register_username)
                    .padding(12)
                    .autocapitalization(.none)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                TextField("Name", text: self.$authVM.register_name)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                TextField("E-mail", text: self.$authVM.register_email)
                    .padding(12)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                SecureField("Password", text: self.$authVM.register_password)
                    .padding(12)
                    .background(Color(UIColor.systemGray6))
                    .mask(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 30)
                if #available(iOS 14.0, *){
                    DatePicker(selection: self.$authVM.register_birthday, in: ...max, displayedComponents: .date) {
                        Text("Birthday:")
                            .foregroundColor(.gray)
                    }.padding(.horizontal, 30).padding(.top, 10)
                }else{
                    HStack {
                        Text("Birthday:")
                            .foregroundColor(.gray)
                            .frame(width:90, alignment: .leading)
                        Spacer()
                        Text("\(dateFormatter.string(from: self.authVM.register_birthday))")
                            .onTapGesture {
                                self.showsDatePicker.toggle()
                            }
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .background(showsDatePicker
                                            ? Color.clear
                                            : Color(UIColor.systemGray6))
                            .cornerRadius(6)
                    }.padding(.horizontal, 30).padding(.top, 10)
                    if showsDatePicker {
                        DatePicker("", selection: self.$authVM.register_birthday, in: ...max, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle()).labelsHidden()
                    }
                }
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
                    Text("Looking For:")
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                        .frame(width:90, alignment: .leading)
                    Spacer()
                    Picker(selection: self.$authVM.register_lookingfor, label: Text("Looking For:")) {
                        ForEach(0 ..< self.authVM.lookingfor.count) {
                            Text(self.authVM.lookingfor[$0]).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }.padding(.horizontal, 30).padding(.top, 10).padding(.bottom, 30)
                Button(action: {
                    self.authVM.register()
                }, label: {
                    if self.authVM.registerStatus == .loading{
                        ActivityIndicatorView(isAnimating: .constant(true), style: .medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                            .cornerRadius(6)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 25)
                    }else{
                        Text("Register Now")
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
            ZStack(alignment: .bottomLeading){
                GeometryReader{ geo in
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                        .clipShape(CustomShape())
                        .frame(height: UIScreen.main.bounds.height / 8, alignment: .center)
                        .scaleEffect(CGSize(width: 1.0, height: -1.0))
                    if !authVM.showPhotoUpload{
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            VStack{
                                Spacer()
                                HStack(spacing:0){
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 21, weight: .medium))
                                        .padding(.trailing, 8)
                                    Text("Back")
                                }
                            }
                            .foregroundColor(Color(UIColor(named: "Light")!))
                            .padding()
                            .padding(.bottom)
                        }
                    }
                }
            }.frame(height: UIScreen.main.bounds.height / 8, alignment: .center)
        }.edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
        .alert(isPresented: .constant(authVM.error && authVM.errorType == "Register")) {
            Alert(title: Text("An error occured!"), message: Text(authVM.errorDesc), dismissButton: Alert.Button.default(
                Text("I got it"), action: { self.authVM.error = false }
            ))
        }
    }
    
    func checkForm() -> Bool {
        if self.authVM.register_name.isEmpty || self.authVM.register_email.isEmpty || self.authVM.register_username.isEmpty || self.authVM.register_password.isEmpty {
            return true
        }else{
            return false
        }
    }
    
}
