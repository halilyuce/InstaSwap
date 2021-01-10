//
//  RequestsTab.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUIRefresh

struct RequestsTab: View {
    
    @ObservedObject var viewModel: ViewModel = .shared
    
    var body: some View {
        NavigationView{
            ZStack{
                if viewModel.notifications.count > 0 {
                    List{
                        ForEach(viewModel.notifications, id:\.id){ notification in
                            HStack(alignment:.top){
                                WebImage(url: URL(string: notification.user?.images?.first! ?? "")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 42, height: 42, alignment: .center)
                                    .cornerRadius(21)
                                VStack(alignment: .leading, spacing:3){
                                    Text(notification.user?.name ?? "")
                                        .fontWeight(.semibold)
                                    Text(desc(type: notification.notificationType ?? 0))
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                    Text((notification.date ?? "").toDateNodeTS().timeAgoDisplay())
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(UIColor.systemGray3))
                                    HStack{
                                        if notification.notificationType ?? 0 == 1{
                                            Button(action: {
                                                viewModel.postNotification(id: notification.id, type: 3)
                                                if let index = viewModel.notifications.firstIndex(where: {$0.id == notification.id}){
                                                    viewModel.notifications[index].notificationType = 3
                                                }
                                            }, label: {
                                                Text("No, thanks")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.accentColor)
                                                    .fontWeight(.bold)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 8)
                                                    .background(Color(UIColor.systemGray6))
                                                    .cornerRadius(8)
                                                
                                            }).buttonStyle(PlainButtonStyle())
                                            Spacer(minLength: 20)
                                            Button(action: {
                                                viewModel.postNotification(id: notification.id, type: 2)
                                                if let index = viewModel.notifications.firstIndex(where: {$0.id == notification.id}){
                                                    viewModel.notifications[index].notificationType = 2
                                                }
                                            }, label: {
                                                Text("Yes, sure")
                                                    .font(.system(size: 15))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 8)
                                                    .background(Color.pink)
                                                    .cornerRadius(8)
                                            }).buttonStyle(PlainButtonStyle())
                                        }else if notification.notificationType ?? 0 == 3{
                                            EmptyView()
                                        }else{
                                            if #available(iOS 14, *) {
                                                StalkButtonNewer(notification: .constant(notification))
                                            }else{
                                                StalkButtonOld(notification: .constant(notification))
                                            }
                                        }
                                    }.padding(.top, 10)
                                }.padding(.leading, 8)
                            }.padding(.vertical, 8)
                            .onAppear(){
                                self.viewModel.loadMore(currentItem: notification)
                            }
                        }
                    }.listStyle(PlainListStyle())
                    .pullToRefresh(isShowing: self.$viewModel.loading) {
                        self.viewModel.loadMore()
                    }
                }else{
                    Text("Nothing to show!")
                }
                
                if self.viewModel.notificationStatus == .loading{
                    VStack{
                        ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                    }.frame(maxHeight: .infinity)
                }
                
            }.onAppear(){
                if viewModel.notifications.count == 0 {
                    self.viewModel.loadMore()
                }
            }
            .navigationBarTitle(Text("Requests"))
        }.phoneOnlyStackNavigationView()
        .alert(isPresented: .constant(self.viewModel.notificationStatus == .parseError)) {
            Alert(title: Text("An error occured!"), message: Text(viewModel.errorDesc), dismissButton: Alert.Button.default(
                    Text("I got it")))
        }
    }
    
    func desc(type:Int) -> String {
        if type == 0 {
            return "Here is my Insta! Follow me 😉".localized
        }else  if type == 1 {
            return "Hey! May I have your insta? 😉".localized
        }else if type == 2 {
            return "You've accepted this request.".localized
        }else{
            return "You've declined this request.".localized
        }
    }
    
}
