//
//  ViewModel.swift
//  InstantMatch
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
    @Published var reportStatus = Status.ready
    
    @Published var notifications = [Notification]()
    @Published var notificationStatus = Status.ready
    @Published var loadStatus = LoadMoreStatus.ready(nextPage: 0)
    @Published var lastPage:Int? = nil
    
    @Published var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                self.loadStatus = .ready(nextPage: 0)
                self.loadMore()
            }
        }
    }
    
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
                if self.cards.count == 0 {
                    self.loadCards()
                }
            case .failure(_):
                print("error")
                self.error.toggle()
                self.errorType = "Post Swipe"
            }
        }
    }
    
    func reportUser(id:String, completion: @escaping (Bool) -> Void){
        self.reportStatus = .loading
        ApiManager.shared.reportUser(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.reportStatus = .done
                DispatchQueue.main.async { completion(true) }
            case .failure(_):
                print("error report user")
                self.reportStatus = .parseError
                DispatchQueue.main.async { completion(false) }
                self.error.toggle()
                self.errorDesc = NSLocalizedString("Please try again.", comment: "")
                self.errorType = "Report"
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
                self.parseFromResponse(data: result.list, error: nil)
                self.loading = false
            case .failure(let err):
                print("error")
                self.notificationStatus = .parseError
                self.loading = false
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
        getNotifications(page: page)
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
                    }else{
                        self.notifications = self.notifications.map { (eachData) -> Notification in
                            var data = eachData
                            if data.id == notification.id {
                                data.notificationType = notification.notificationType
                                data.date = notification.date
                                data.isshowed = true
                                data.user = notification.user
                                return data
                            }else {
                                return eachData
                            }
                        }
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

