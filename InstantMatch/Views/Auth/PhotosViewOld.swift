//
//  PhotosViewOld.swift
//  InstantMatch
//
//  Created by Halil Yuce on 6.01.2021.
//

import SwiftUI
import SDWebImageSwiftUI

class ModelOld: ObservableObject {
    @Published var data = [GridData]()
}

struct PhotosViewOld: View {
    
    @Binding var user: User?
    @ObservedObject var model = ModelOld()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var dragging: GridData?
    @ObservedObject var imagePickerViewModel : ImagePickerViewModel = .shared
    @ObservedObject var authVM : AuthVM = .shared
    
    func convertImageToBase64(_ image: UIImage) -> String? {
        let imageData = image.jpegData(compressionQuality: 0.8)
        return imageData?.base64EncodedString(options:Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack(alignment: .leading){
                    UIGrid(columns: 3, list: model.data) { d in
                            ZStack(alignment:.bottomTrailing){
                                GridItemView(d: d)
                                if d.image != nil || d.system != nil{
                                    Button {
                                        if let index = model.data.firstIndex(where: {$0.id == d.id}){
                                            model.data.remove(at: index)
                                        }
                                        if (model.data.firstIndex(where: {$0.image == nil && $0.system == nil}) == nil){
                                            self.model.data.append(GridData(id: UUID().uuidString, image: nil, system: nil))
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(Color.red)
                                            .font(.system(size: 21))
                                            .padding(-5)
                                            .background(Color.white)
                                    }.opacity(dragging != nil ? 0 : 1)
                                }
                            }
                            .overlay(dragging?.id == d.id ? Color.white.opacity(0.8) : Color.clear)
                    }.animation(.default, value: model.data).padding(.top, UIScreen.main.bounds.height / 7)
                Spacer()
                Button(action: {
                    var photos = [UserImages]()
                    for photo in model.data {
                        if photo.system != nil{
                            photos.append(UserImages(imageUrl: nil, base64:convertImageToBase64(photo.system!)))
                        }else{
                            photos.append(UserImages(imageUrl: photo.image, base64:nil))
                        }
                    }
                    authVM.postPhotos(images: photos) { _ in
                        SDImageCache.shared.clearMemory()
                        SDImageCache.shared.clearDisk()
                        if authVM.showPhotoUpload {
                            self.authVM.showPhotoUpload = false
                            self.authVM.loggedIn = true
                        }else{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, label: {
                    if self.authVM.photoStatus == .loading{
                        ActivityIndicatorView(isAnimating: .constant(true), style: .medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                            .cornerRadius(6)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 25)
                            .opacity(0.5)
                            .disabled(true)
                    }else{
                        Text("Save Changes")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50, alignment: .center)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                            .cornerRadius(6)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 25)
                            .opacity(model.data.count == 0 ? 0.5 : 1.0)
                    }
                }).disabled(model.data.count == 0)
            }
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
        }.frame(width: UIScreen.main.bounds.width, alignment: .center).edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $imagePickerViewModel.isPresented) {
            ImagePickerView()
        }
        .onAppear(){
            if model.data.count == 0 {
                for photo in user?.images ?? [] {
                    self.model.data.append(GridData(id: UUID().uuidString, image: photo, system: nil))
                }
                if self.model.data.count < 6 {
                    self.model.data.append(GridData(id: UUID().uuidString, image: nil, system: nil))
                }
            }
        }
        .onReceive(imagePickerViewModel.pickedImagesSubject) { (images: [UIImage]) -> Void in
            withAnimation {
                if self.model.data.count < 7 {
                    for image in images {
                        if let index = model.data.firstIndex(where: {$0.image == nil && $0.system == nil}){
                            self.model.data.insert(GridData(id: UUID().uuidString, image: nil, system: image), at: index)
                        }
                    }
                    if self.model.data.count == 7 {
                        self.model.data.remove(at: self.model.data.count - 1)
                    }else{
                        if (model.data.firstIndex(where: {$0.image == nil && $0.system == nil}) == nil){
                            self.model.data.append(GridData(id: UUID().uuidString, image: nil, system: nil))
                        }
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}
