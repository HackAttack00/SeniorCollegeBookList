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
    private var cancellable: AnyCancellable?
    
    init() {
        fetchNewBookList()
    }

    private func fetchNewBookList() {
        self.cancellable = bookAPI.fetchNewBooks()
            .receive(on: DispatchQueue.main)
            .map { bookResponse in
                bookResponse.books.map { books in
                    books.map { book in
                        BookViewModel(book: book)
                    }
                }!
            }.sink { _ in
            } receiveValue: {
                self.books = $0
            }
    }
}

struct BookViewModel {
    let book: Book
}
