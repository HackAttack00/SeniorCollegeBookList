//
//  BookListViewModel.swift
//  SeniorCollegeBookApp
//
//  Created by Seungchul Lee on 2022/10/17.
//

import Foundation
import Combine

class NewBookListViewModel: ObservableObject {
    private var bookAPI:API = API()
    private var subscriptions = Set<AnyCancellable>()
    @Published var books = [BookViewModel]()
    
    init() {
        fetchNewBookList()
    }
    
    private func fetchNewBookList() {
        bookAPI.fetchNewBooks()
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty()}
            .map {
                return $0.books ?? []
            }
            .assign(to: \.books, on: self)
            .store(in: &subscriptions)
    }
}

class BookViewModel: ObservableObject {
    var book:Book? = nil
}


//func fetchNewBooks() {
//    bookAPI.fetchNewBooks()
//        .receive(on: DispatchQueue.main)
//        .catch { _ in Empty()}
//        .map {
//            return $0.books ?? []
//        }
//        .assign(to: \.moreBooks, on: self)
//        .store(in: &subscriptions)
//}
