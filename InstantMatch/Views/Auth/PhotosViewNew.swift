//
//  PhotosView.swift
//  InstantMatch
//
//  Created by Halil Yuce on 22.11.2020.
//


import SwiftUI
import UniformTypeIdentifiers
import SDWebImageSwiftUI

struct GridData: Identifiable, Equatable, Hashable {
    let id: String
    let image: String?
    var system: UIImage?
}

//MARK: - Model
@available(iOS 14.0, *)
class Model: ObservableObject {
    @Published var data = [GridData]()
    
    let columns = [
        GridItem(.fixed(120)),
        GridItem(.fixed(120)),
        GridItem(.fixed(120))
    ]
}

//MARK: - Grid

@available(iOS 14.0, *)
struct PhotosViewNew: View {
    
    @Binding var user: User?
    @StateObject private var model = Model()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var dragging: GridData?
    @ObservedObject var imagePickerViewModel : ImagePickerViewModel = .shared
    @ObservedObject var authVM : AuthVM = .shared
    
    func convertImageToBase64(_ image: UIImage) -> String? {
        let imageData = image.jpegData(compressionQuality: 0.8)
        return imageData?.base64EncodedString(options:Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack{
                LazyVGrid(columns: model.columns, spacing: 15) {
                    ForEach(model.data) { d in
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
                        .onDrag {
                            self.dragging = d
                            return NSItemProvider(object: String(d.id) as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging))
                    }
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
                    authVM.postPhotos(images: photos) { photos in
                        self.user?.images = photos
                        try? UserDefaults.standard.setCustomObject(user, forKey: "user")
                        SDImageCache.shared.clearMemory()
                        SDImageCache.shared.clearDisk()
                        self.presentationMode.wrappedValue.dismiss()
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
                    .foregroundColor(Color(UIColor(named: "Light")!))
                    .padding()
                    .padding(.top, UIScreen.main.bounds.width < 375 ? 20 : 40)
                }
            }
        }.edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $imagePickerViewModel.isPresented) {
            ImagePickerView()
        }
        .onAppear(){
            for photo in user?.images ?? [] {
                self.model.data.append(GridData(id: UUID().uuidString, image: photo, system: nil))
            }
            if self.model.data.count < 6 {
                self.model.data.append(GridData(id: UUID().uuidString, image: nil, system: nil))
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
        .navigationBarHidden(true)
    }
}

@available(iOS 14.0, *)
struct DragRelocateDelegate: DropDelegate {
    let item: GridData
    @Binding var listData: [GridData]
    @Binding var current: GridData?
    
    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                              toOffset: to > from ? to + 1 : to)
            }
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}

//MARK: - GridItem

struct GridItemView: View {
    var d: GridData
    @ObservedObject var imagePickerViewModel : ImagePickerViewModel = .shared
    
    var body: some View {
        if d.image == nil && d.system == nil{
            Button {
                self.imagePickerViewModel.isPresented.toggle()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemGray6))
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .font(.title)
                        .foregroundColor(Color(UIColor.systemGray3))
                }.frame(width: UIScreen.main.bounds.width / 3.6, height: 150, alignment: .center)
            }
        }else if d.image != nil{
            WebImage(url: URL(string: d.image!)!)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width / 3.6, height: 150, alignment: .center)
                .clipped()
                .cornerRadius(10)
        }else{
            Image(uiImage: d.system!)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width / 3.6, height: 150, alignment: .center)
                .clipped()
                .cornerRadius(10)
        }
    }
}
