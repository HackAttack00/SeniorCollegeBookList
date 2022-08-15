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
    let isbn13: String?
    let price: String?
    let image: String?
    let url: String?
    
    static var placeHolder: Book {
        return Book(title: nil, subtitle: nil, isbn13: nil, price: nil, image: nil, url: nil)
    }
}
