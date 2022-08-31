//
//  BookDetailInfoViewController.swift
//  SeniorCollegeBookApp
//
//  Created by seungchul lee on 2022/09/01.
//

import Foundation
import UIKit
import Combine


class BookDetailInfoViewController: UIViewController {
    @IBOutlet var bookImageView: UIImageView?
    @IBOutlet var bookDescription: UITextView?
    
    var bookCode: String? = nil {
        didSet {
            if let bookCode = bookCode {
                self.fetchBookInfo(bookCode: bookCode)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url:URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.bookImageView?.image = UIImage(data: data)
            }
        }
    }
    
    private func setBookDescription(desc: String) {
        self.bookDescription?.text = desc
    }
    
    var book = Book(title: nil, subtitle: nil, authors: nil, publisher: nil, isbn10: nil, isbn13: nil, pages: nil, years: nil, rating: nil, desc: nil, price: nil, image: nil, url: nil) {
        didSet {
            if let image = book.image {
                self.downloadImage(from: URL(string: image)!)
            }
            
            if let desc = book.desc {
                self.setBookDescription(desc: desc)
            }
        }
    }
    
    private var bookAPI:API = API()
    private var subscriptions = Set<AnyCancellable>()
}

extension BookDetailInfoViewController {
    func fetchBookInfo(bookCode: String) {
        bookAPI.fetchBookInfo(bookCode: bookCode)
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty()}
            .map {
                return $0
            }
            .assign(to: \.book, on: self)
            .store(in: &subscriptions)
    }
}
