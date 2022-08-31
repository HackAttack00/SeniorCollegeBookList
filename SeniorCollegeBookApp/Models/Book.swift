//
//  Book.swift
//  SeniorCollegeBookApp
//
//  Created by seungchul lee on 2022/08/13.
//

import Foundation

struct BookResponse: Codable {
    let total: String?
    let page: String?
    let books: [Book]?
}

struct Book: Codable {
    let title: String?
    let subtitle: String?
    let authors: String?
    let publisher: String?
    let isbn10: String?
    let isbn13: String?
    let pages: String?
    let years: String?
    let rating: String?
    let desc: String?
    let price: String?
    let image: String?
    let url: String?
    //let pdf: [PDF]?
    
    static var placeHolder: Book {
        return Book(title: nil,
                    subtitle: nil,
                    authors: nil,
                    publisher: nil,
                    isbn10: nil,
                    isbn13: nil,
                    pages: nil,
                    years: nil,
                    rating: nil,
                    desc: nil,
                    price: nil,
                    image: nil,
                    url: nil)
    }
}

//struct PDF: Codable {
//
//}
