//
//  RequestsTab.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI
import SDWebImageSwiftUI

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
                                    .padding(.trailing, 10)
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
                                }
                            }.padding(.vertical, 8)
                            .onAppear(){
                                self.viewModel.loadMore(currentItem: notification)
                            }
                        }
                    }.listStyle(PlainListStyle())
                }else{
                    EmptyView()
                }
                
                if self.viewModel.notificationStatus == .loading{
                    VStack{
                        ActivityIndicatorView(isAnimating: .constant(true), style: .large)
                    }.frame(maxHeight: .infinity)
                }
                
                if self.viewModel.notificationStatus == .parseError {
                    Text("An Error Occured!")
                }
            }.onAppear(){
                self.viewModel.loadMore()
            }
            .navigationBarTitle(Text("Requests"))
        }.phoneOnlyStackNavigationView()
    }
    
    func desc(type:Int) -> String {
        if type == 0 {
            return "Here is my Insta! Follow me 😉"
        }else  if type == 1 {
            return "Hey! May I have your insta? 😉"
        }else if type == 2 {
            return "You've accepted this request."
        }else{
            return "You've declined this request."
        }
    }
    
}

@available(iOS 14.0, *)
struct StalkButtonNewer : View{
    
    @Binding var notification: Notification?
    @Environment(\.openURL) var openURL
    @Environment(\.viewController) private var viewControllerHolder: ViewControllerHolder
    private var viewController: UIViewController? {
        self.viewControllerHolder.value
    }
    
    var body: some View{
        Group{
            if notification?.notificationType ?? 0 == 0{
                Button(action: {
                    let instagram = URL(string: "instagram://user?username=\(notification?.user?.username ?? "")")!
                    openURL(instagram, completion: { (success) in
                        if !success {
                            self.viewController?.present(style: .pageSheet) {
                                SafariView(url:URL(string: "https://instagram.com/\(notification?.user?.username ?? "")")!)
                            }
                        }
                    })
                }, label: {
                    ZStack(alignment:.trailing){
                        Text("Follow")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.pink)
                            .cornerRadius(8)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(Color.white)
                            .offset(x: -10)
                    }
                }).buttonStyle(PlainButtonStyle())
            }else{
                Button(action: {
                    let instagram = URL(string: "instagram://user?username=\(notification?.user?.username ?? "")")!
                    openURL(instagram, completion: { (success) in
                        if !success {
                            self.viewController?.present(style: .pageSheet) {
                                SafariView(url:URL(string: "https://instagram.com/\(notification?.user?.username ?? "")")!)
                            }
                        }
                    })
                }, label: {
                    Text("Stalk")
                        .font(.system(size: 15))
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }).buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct StalkButtonOld: View {
    
    @Binding var notification: Notification?
    @Environment(\.viewController) private var viewControllerHolder: ViewControllerHolder
    private var viewController: UIViewController? {
        self.viewControllerHolder.value
    }
    
    var body: some View {
        Group{
            if notification?.notificationType ?? 0 == 0{
                Button(action: {
                    let instagram = URL(string: "instagram://user?username=\(notification?.user?.username ?? "")")!
                    if UIApplication.shared.canOpenURL(instagram) {
                        UIApplication.shared.open(instagram, completionHandler: nil)
                    } else {
                        self.viewController?.present(style: .pageSheet) {
                            SafariView(url:URL(string: "https://instagram.com/\(notification?.user?.username ?? "")")!)
                        }
                    }
                }, label: {
                    ZStack(alignment:.trailing){
                        Text("Follow")
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color.pink)
                            .cornerRadius(8)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(Color.white)
                            .offset(x: -10)
                    }
                }).buttonStyle(PlainButtonStyle())
            }else{
                Button(action: {
                    let instagram = URL(string: "instagram://user?username=\(notification?.user?.username ?? "")")!
                    if UIApplication.shared.canOpenURL(instagram) {
                        UIApplication.shared.open(instagram, completionHandler: nil)
                    } else {
                        self.viewController?.present(style: .pageSheet) {
                            SafariView(url:URL(string: "https://instagram.com/\(notification?.user?.username ?? "")")!)
                        }
                    }
                }, label: {
                    Text("Stalk")
                        .font(.system(size: 15))
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }).buttonStyle(PlainButtonStyle())
            }
        }
    }
}

