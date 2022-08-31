//
//  APIList.swift
//  SeniorCollegeBookApp
//
//  Created by seungchul lee on 2022/08/13.
//

import Foundation
import Combine

struct API {
    enum Error: LocalizedError {
        case addressUnreachable(URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse: return "The server responded with garbage."
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            }
        }
    }
    
    enum EndPoint {
        static let baseURL = URL(string: "https://api.itbook.store/1.0/")!
        
        case newBook
        case searchBook(String, Int)
        case book(String)
        
        var url: URL {
            switch self {
            case .newBook:
                return EndPoint.baseURL.appendingPathComponent("new")
                
            case .searchBook(let title, let page):
                return EndPoint.baseURL.appendingPathComponent("search/\(title)/\(page)")
            
            case .book(let bookCode):
                return EndPoint.baseURL.appendingPathComponent("books/\(bookCode)")
            }
        }
    }
    
    private let decoder = JSONDecoder()
    
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
//    func fetchSearchBooks(title:String, page:Int) -> AnyPublisher<BookResponse, Error> {
//        var searchBookUrl:URL = EndPoint.searchBook.url
//        let urlComp = "\(title)/\(page)"
//        searchBookUrl = searchBookUrl.appendingPathComponent(urlComp)
//
//        URLSession.shared.dataTaskPublisher(for: searchBookUrl)
//            .receive(on: apiQueue)
//            .map { $0.data }
//            .decode(type: BookResponse.self, decoder: decoder)
//            .mapError { error -> API.Error in
//                switch error {
//                case is URLError:
//                    return Error.addressUnreachable(searchBookUrl)
//                default: return Error.invalidResponse
//                }
//            }
//            .map {
//                return $0
//            }
//            .eraseToAnyPublisher()
//    }
    
    func fetchSearchBooks(title:String, page:Int) -> AnyPublisher<BookResponse, Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.searchBook(title, page).url)
            .receive(on: apiQueue)
            .map { $0.data }
            .decode(type: BookResponse.self, decoder: decoder)
            .mapError { error -> API.Error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.searchBook(title, page).url)
                default: return Error.invalidResponse
                }
            }
            .map {
                return $0
            }
            .eraseToAnyPublisher()
    }
    
    
    func fetchNewBooks() -> AnyPublisher<BookResponse, Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.newBook.url)
            .receive(on: apiQueue)
            .map { $0.data }
            .decode(type: BookResponse.self, decoder: decoder)
            .mapError { error -> API.Error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.newBook.url)
                default: return Error.invalidResponse
                }
            }
            .map {
                return $0
            }
            .eraseToAnyPublisher()
    }
    
    func fetchBookInfo(bookCode:String) -> AnyPublisher<Book, Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.book(bookCode).url)
            .receive(on: apiQueue)
            .map { $0.data }
            .decode(type: Book.self, decoder: decoder)
            .mapError { error -> API.Error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.book(bookCode).url)
                default: return Error.invalidResponse
                }
            }
            .map {
                return $0
            }
            .eraseToAnyPublisher()
    }
}



