//
//  ViewModel.swift
//  InstaSwap
//
//  Created by Halil Yuce on 15.11.2020.
//

import SwiftUI

enum LoadMoreStatus {
    case ready (nextPage: Int)
    case loading (page: Int)
    case parseError
    case done
}

class ViewModel: ObservableObject {
    
    @Published var error = false
    @Published var errorDesc = ""
    @Published var errorType = ""
    
    @Published var cards = [Card]()
    @Published var status = Status.ready
    
    @Published var notifications = [Notification]()
    @Published var notificationStatus = Status.ready
    @Published var loadStatus = LoadMoreStatus.ready(nextPage: 0)
    @Published var lastPage:Int? = nil
    
    private init() { }
    
    static let shared = ViewModel()
    
    func loadCards(){
        self.status = .loading
        ApiManager.shared.doubleTake() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.status = .done
                self.cards = result.list ?? []
            case .failure(_):
                print("error")
                self.status = .parseError
                self.error.toggle()
                self.errorType = "Load Cards"
            }
        }
    }
    
    func postSwipe(id:String, liked: Bool){
        ApiManager.shared.postSwipe(userId: id, isLiked: liked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                print("post swipe")
            case .failure(_):
                print("error")
                self.error.toggle()
                self.errorType = "Post Swipe"
            }
        }
    }
    
    func postNotification(id:String, type:Int){
        ApiManager.shared.patchNotification(id: id, type: type) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                print(result)
            case .failure(let err):
                print("error")
                self.notificationStatus = .parseError
                self.error.toggle()
                self.errorDesc = err.localizedDescription
            }
        }
    }
    
    func getNotifications(page: Int){
        ApiManager.shared.getNotifications(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                if result.list.count == 0 {
                    self.lastPage = page
                }
                self.parseFromResponse(data: result.list, error: nil)
            case .failure(let err):
                print("error")
                self.notificationStatus = .parseError
                self.error.toggle()
                self.errorDesc = err.localizedDescription
            }
        }
    }
    
    func shouldLoadMoreData(currentItem: Notification? = nil) -> Bool {
        guard let currentItem = currentItem else {
            return true
        }
        for n in (notifications.count - 3)...(notifications.count-1) {
            if n >= 0 && currentItem.id == notifications[n].id {
                return true
            }
        }
        return false
    }
    
    func loadMore(currentItem: Notification? = nil) {
        
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        guard case let .ready(page) = loadStatus else {
            return
        }
        if notifications.count == 0{
            notificationStatus = .loading
        }
        loadStatus = .loading(page: page)
        if (lastPage != nil){
            if self.lastPage! >= page{
                getNotifications(page: page)
            }else{
                loadStatus = .done
                self.notificationStatus = .done
            }
        }else{
            getNotifications(page: page)
        }
    }
    
    func parseFromResponse(data: [Notification]?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            loadStatus = .parseError
            self.notificationStatus = .parseError
            return
        }
        guard data != nil else {
            print("No data found")
            loadStatus = .parseError
            self.notificationStatus = .parseError
            return
        }
        
        DispatchQueue.main.async {
            if self.notifications.count > 9{
                for notification in data! {
                    if !self.notifications.contains(where: { $0.id == notification.id }){
                        if notification.isshowed!{
                            self.notifications.append(notification)
                        }else{
                            self.notifications.insert(notification, at: 0)
                        }
                    }
                }
            }else{
                for notification in data!.reversed() {
                    if !self.notifications.contains(where: { $0.id == notification.id }){
                        self.notifications.insert(notification, at: 0)
                    }
                }
            }
            if data?.count == 0 {
                self.loadStatus = .done
                self.notificationStatus = .done
            } else {
                guard case let .loading(page) = self.loadStatus else {
                    fatalError("loadSatus is in a bad state")
                }
                self.loadStatus = .ready(nextPage: page + 1)
                self.notificationStatus = .ready
            }
        }
    }
}

