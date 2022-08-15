//
//  ViewController.swift
//  SeniorCollegeBookApp
//
//  Created by seungchul lee on 2022/08/13.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var books = [Book]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var bookAPI:API = API()
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = self.books[indexPath.row].title ?? String(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
