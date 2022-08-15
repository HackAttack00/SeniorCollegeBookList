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
        case searchBook
        
        var url: URL {
            switch self {
            case .newBook:
                return EndPoint.baseURL.appendingPathComponent("new")
                
            case .searchBook:
                return EndPoint.baseURL.appendingPathComponent("search")
            }
        }
    }
    
    private let decoder = JSONDecoder()
    
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
    
    func fetchNewBooks() -> AnyPublisher<BookResponse, Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.newBook.url)
            .receive(on: apiQueue)
            .map { $0.data }
            .decode(type: BookResponse.self, decoder: decoder)
            .mapError { error in
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
}


