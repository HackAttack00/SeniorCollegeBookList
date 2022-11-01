//
//  BookDetailViewModel.swift
//  SeniorCollegeBookApp
//
//  Created by Seungchul Lee on 2022/11/01.
//

import Foundation
import Combine

class BookDetailViewModel: ObservableObject {
    private var bookAPI:API = API()
    private var subscriptions = Set<AnyCancellable>()
    @Published var book = Book.placeHolder
    private var cancellable: AnyCancellable?
    
    init(bookCode: String) {
        fetchBookDetail(bookCode: bookCode)
    }

    private func fetchBookDetail(bookCode: String) {
        self.cancellable = bookAPI.fetchBookInfo(bookCode: bookCode)
            .receive(on: DispatchQueue.main)
            .map { book in
                Book(title: book.title,
                     subtitle: book.subtitle,
                     authors: book.authors,
                     publisher: book.publisher,
                     isbn10: book.isbn10,
                     isbn13: book.isbn13,
                     pages: book.pages,
                     years: book.years,
                     rating: book.rating,
                     desc: book.desc,
                     price: book.price,
                     image: book.image,
                     url: book.url)
            }.sink { _ in
            } receiveValue: {
                self.book = $0
            }
    }
}
