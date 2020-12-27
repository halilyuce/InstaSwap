//
//  PhotosView.swift
//  InstantMatch
//
//  Created by Halil Yuce on 22.11.2020.
//


import SwiftUI
import UniformTypeIdentifiers

struct GridData: Identifiable, Equatable {
    let id: String
    let image: String?
    var system: Image
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
struct PhotosView: View {
    
    @StateObject private var model = Model()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var dragging: GridData?
    @State var imagePickerViewModel = ImagePickerViewModel()
    
    var body: some View {
        
        ZStack(alignment: .top){
            VStack{
                LazyVGrid(columns: model.columns, spacing: 15) {
                    ForEach(model.data) { d in
                        ZStack(alignment:.bottomTrailing){
                            GridItemView(d: d)
                            Button {
                                model.data.remove(at: 0)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 21))
                                    .padding(-5)
                                    .background(Color.white)
                            }.opacity(dragging != nil ? 0 : 1)

                        }
                        .overlay(dragging?.id == d.id ? Color.white.opacity(0.8) : Color.clear)
                        .onDrag {
                            self.dragging = d
                            return NSItemProvider(object: String(d.id) as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging))
                    }
                    if model.data.count < 6 {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray6))
                            Button {
                                self.imagePickerViewModel.isPresented.toggle()
                            } label: {
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .font(.title)
                                    .foregroundColor(Color(UIColor.systemGray3))
                            }

                        }.frame(height: 150)
                    }
                }.animation(.default, value: model.data).padding(.top, UIScreen.main.bounds.height / 7)
                Spacer()
                Button(action: {
                }, label: {
                    Text("Save Changes")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50, alignment: .center)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(UIColor(hexString: "#fa7e1e")), Color(UIColor(hexString: "#d62976")), Color(UIColor(hexString: "#962fbf")), Color(UIColor(hexString: "#4f5bd5"))]), startPoint: .bottomTrailing, endPoint: .topLeading))
                        .cornerRadius(6)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 25)
                })
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
                    .padding(.top, UIScreen.main.bounds.width < 400 ? 20 : 40)
                }
            }
        }.edgesIgnoringSafeArea(.top)
        .sheet(isPresented: $imagePickerViewModel.isPresented) {
                        ImagePickerView(model: self.$imagePickerViewModel)
                    }
        .onReceive(imagePickerViewModel.pickedImagesSubject) { (images: [Image]) -> Void in
                        withAnimation {
                            for image in images {
                                self.model.data.append(GridData(id: UUID().uuidString, image: nil, system: image))
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
    
    var body: some View {
        if d.image != nil{
            Image(d.image!)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width / 3.6, height: 150, alignment: .center)
                .cornerRadius(10)
        }else{
            d.system
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width / 3.6, height: 150, alignment: .center)
                .cornerRadius(10)
        }
    }
}
