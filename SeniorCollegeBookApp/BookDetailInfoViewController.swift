//
//  BookDetailInfoViewController.swift
//  SeniorCollegeBookApp
//
//  Created by seungchul lee on 2022/09/01.
//

import Foundation
import UIKit


class BookDetailInfoViewController: UIViewController {
    @IBOutlet var bookImageView: UIImageView?
    @IBOutlet var bookDescription: UITextView?
    

}

extension BookDetailInfoViewController {
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
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
    
    func setBookDescription(desc: String) {
        self.bookDescription?.text = desc
    }
}
