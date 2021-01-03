//
//  SwapCard.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI
import SDWebImageSwiftUI

struct SwapCard: View {
    
    @State var person: Card
    @ObservedObject var viewModel: ViewModel = .shared
    
    var body: some View {
        ZStack(alignment: .top){
            if person.images?.count ?? 0 > 0 {
            LazyImage(url: URL(string: person.images?[person.index ?? 0] ?? "")!)
                .equatable()
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
                }.padding().frame(maxWidth: UIScreen.main.bounds.width)
            }
            VStack(alignment: .leading){
                HStack {
                    Image("yes")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:150)
                        .opacity(Double((person.x ?? 0)/10 - 1))
                    Spacer()
                    Image("nope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:150)
                        .opacity(Double((person.x ?? 0)/10 * -1 - 1))
                }
                Spacer()
                HStack{
                    Text("\(person.name ?? ""), \(birth(date: person.birthDate ?? ""))")
                            .font(.title)
                            .fontWeight(.bold)
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "flag.fill")
                    })
                }.padding(20).foregroundColor(.white)
            }.frame(maxWidth: UIScreen.main.bounds.width)
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
            }.frame(maxWidth: UIScreen.main.bounds.width)
        }.onAppear(){
            person.index = 0
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
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
    }
    
    func birth(date: String) -> String{
        let ageComponents = Calendar.current.dateComponents([.year], from: date.toDateNodeTS(), to: Date())
        return String(ageComponents.year!)
    }
}

struct SwapCard_Previews: PreviewProvider {
    static var previews: some View {
        SwapCard(person: Card(images: ["https://i.pinimg.com/originals/95/86/bf/9586bfc989985ce947a687e43da3d419.jpg",
                                       "https://cf.girlsaskguys.com/a26913/276aa246-a97e-4a8f-b0fa-7ecc17f3185e.jpg",
                                       "https://placeimg.com/768/1024/people"], _id: "5fe8cf814ef1445812360b51", username: "rosie34", name: "Rosie", email: "torrey.heller98@hotmail.com", birthDate: "1999-08-03T04:48:14.714Z", gender: 1, lookingFor: 0))
            .previewDevice("iPhone 12 Pro")
    }
}
