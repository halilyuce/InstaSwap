//
//  NotificationButtons.swift
//  InstantMatch
//
//  Created by Halil Yuce on 4.01.2021.
//

import SwiftUI

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
                            .padding(.horizontal, 35)
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
                            .padding(.horizontal, 40)
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


