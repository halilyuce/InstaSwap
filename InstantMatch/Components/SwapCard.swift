//
//  SwapCard.swift
//  InstantMatch
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI
import SDWebImageSwiftUI

struct SwapCard: View {
    
    @State var person: Card
    @State var showAlert: Bool = false
    @ObservedObject var viewModel: ViewModel = .shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ZStack(alignment: .top){
                    if person.images?.count ?? 0 > 0 {
                        if #available(iOS 14.0, *){
                            LazyVStack{
                                WebImage(url: URL(string: person.images?[person.index ?? 0] ?? "")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom) )
                                    .clipped()
                                    .contentShape(Rectangle())
                            }
                        }else{
                            LazyImage(url: URL(string: person.images?[person.index ?? 0] ?? "")!)
                                .equatable()
                        }
                    }
                    LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.5),  Color.purple.opacity(0.25), Color.clear]), startPoint: .bottom, endPoint: .center)
                    if person.images?.count ?? 0 > 1{
                        HStack{
                            ForEach(0..<person.images!.count){ i in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(person.index ?? 0 == i ? 1.0 : 0.5))
                                    .frame(height:3)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 3)
                            }
                        }.padding().frame(maxWidth: .infinity)
                    }
                    HStack{
                        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.01), Color.clear]), startPoint: .leading, endPoint: .trailing)
                            .frame(width: 100)
                            .onTapGesture {
                                if person.index ?? 0 > 0{
                                    person.index! -= 1
                                }
                            }
                        Spacer()
                        LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.01)]), startPoint: .leading, endPoint: .trailing)
                            .frame(width: 100)
                            .opacity(0.01)
                            .onTapGesture {
                                if person.index ?? 0 < (person.images?.count ?? 0) - 1{
                                    person.index! += 1
                                }
                            }
                    }
                }
                
                Group{
                    Text("😍")
                        .opacity(Double((person.x ?? 0)/10 - 1))
                    Text("😢")
                        .opacity(Double((person.x ?? 0)/10 * -1 - 1))
                }.font(.system(size: 56))
                
                
                VStack(alignment: .leading){
                    Spacer()
                    
                    Button(action: {
                        self.showAlert.toggle()
                    }, label: {
                        HStack{
                            Text("\(person.name ?? ""), \(birth(date: person.birthDate ?? ""))")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                                Image(systemName: "flag.fill")
                        }.padding(20).foregroundColor(.white)
                    })
                }.frame(maxWidth: .infinity)
                
                
            }.onAppear(){
                person.index = 0
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height - (geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom))
            .clipped()
            .clipShape(Rectangle())
            .offset(x: person.x ?? 0, y: person.y ?? 0)
            .rotationEffect(.init(degrees: person.degree ?? 0))
            .gesture (
                DragGesture()
                    .onChanged { value in
                        withAnimation(.default) {
                            person.x = value.translation.width
                            person.y = value.translation.height
                            person.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                        }
                    }
                    .onEnded { (value) in
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                            switch value.translation.width {
                            case 0...100:
                                person.x = 0; person.degree = 0; person.y = 0
                            case let x where x > 100:
                                print("Swipe Right")
                                self.viewModel.postSwipe(id: person._id ?? "", liked: true)
                                person.x = (UIScreen.main.bounds.width * 2); person.degree = 12
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.viewModel.cards.remove(at: 0)
                                }
                            case (-100)...(-1):
                                person.x = 0; person.degree = 0; person.y = 0
                            case let x where x < -100:
                                print("Swipe Left")
                                self.viewModel.postSwipe(id: person._id ?? "", liked: false)
                                person.x  = -(UIScreen.main.bounds.width * 2); person.degree = -12
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.viewModel.cards.remove(at: 0)
                                }
                            default:
                                person.x = 0; person.y = 0
                            }
                        }
                    }
            )
            .actionSheet(isPresented: self.$showAlert) {
                ActionSheet(title: Text("Report user or content"), message: Text("If there is a disturbing situation in these images or user, you can apply the following ways to complain."), buttons: [.destructive(Text("Report this user/content"), action: {self.viewModel.reportUser(id: person._id ?? "") { (success) in
                    print(success)
                }}), .cancel(Text("Cancel"))])
            }
            
        }
    }
    
    func birth(date: String) -> String{
        let ageComponents = Calendar.current.dateComponents([.year], from: date.toDateNodeTS(), to: Date())
        return String(ageComponents.year!)
    }
}
