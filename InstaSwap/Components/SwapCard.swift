//
//  SwapCard.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

struct SwapCard: View {
    
    @State var person: Card
    
    var body: some View {
        ZStack(alignment: .top){
            Image(person.images[person.index])
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width)
                .clipped()
            LinearGradient(gradient: Gradient(colors: [Color.pink,  Color.purple.opacity(0.5), Color.clear]), startPoint: .bottom, endPoint: .center)
            if person.images.count > 1{
                HStack{
                    ForEach(0..<person.images.count){ i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(person.index == i ? 1.0 : 0.5))
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
                        .opacity(Double(person.x/10 - 1))
                    Spacer()
                    Image("nope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:150)
                        .opacity(Double(person.x/10 * -1 - 1))
                }
                Spacer()
                HStack{
                    VStack(alignment: .leading, spacing: 5){
                        Text("\(person.name), \(person.age)")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(person.country)
                            .fontWeight(.bold)
                    }
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
                        if person.index > 0{
                            person.index -= 1
                        }
                    }
                Spacer()
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.01)]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 100)
                    .opacity(0.01)
                    .onTapGesture {
                        if person.index < person.images.count - 1{
                            person.index += 1
                        }
                    }
            }.frame(maxWidth: UIScreen.main.bounds.width)
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
        .offset(x: person.x, y: person.y)
        .rotationEffect(.init(degrees: person.degree))
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
                            person.x = (UIScreen.main.bounds.width * 2); person.degree = 12
                        case (-100)...(-1):
                            person.x = 0; person.degree = 0; person.y = 0
                        case let x where x < -100:
                            person.x  = -(UIScreen.main.bounds.width * 2); person.degree = -12
                        default:
                            person.x = 0; person.y = 0
                        }
                    }
                }
        )
    }
}

struct SwapCard_Previews: PreviewProvider {
    static var previews: some View {
        SwapCard(person: Card(id:1, name: "Rosie", country: "USA", images: ["gigi", "hadid", "gigihadid"], age: 21, bio: "Insta - roooox 💋"))
            .previewDevice("iPhone 12 Pro")
    }
}
