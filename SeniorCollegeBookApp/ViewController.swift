//
//  ViewController.swift
//  SeniorCollegeBookApp
//
//  Created by seungchul lee on 2022/08/13.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var page: Int = 0
    var searchText: String = ""
    var isLoading: Bool = false
    
    var books = [Book]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var moreBooks = [Book]() {
        didSet {
            self.books.append(contentsOf: moreBooks)
            
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
        

    }
}

extension ViewController {
    func fetchNewBooks() {
        bookAPI.fetchNewBooks()
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty()}
            .map {
                return $0.books ?? []
            }
            .assign(to: \.moreBooks, on: self)
            .store(in: &subscriptions)
    }
    
    func fetchSearchBooks(title:String, page:Int) {
        self.isLoading = true
        bookAPI.fetchSearchBooks(title: title, page: page)
            .receive(on: DispatchQueue.main)
            .catch { _ in Empty()}
            .map {
                self.isLoading = false
                self.page = self.page + 1
                return $0.books ?? []
            }
            .assign(to: \.moreBooks, on: self)
            .store(in: &subscriptions)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = self.books[indexPath.row].title ?? String(indexPath.row)
        
        print("indexPath.row = \(indexPath.row), self.books.count = \(self.books.count), self.page = \(self.page)")
        if indexPath.row == (self.books.count - 1) {
            if self.isLoading == false {
                fetchSearchBooks(title: self.searchText, page: self.page)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier:"DetailBookIdentifier" ,sender:indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "DetailBookIdentifier"
        {
            let destination = segue.destination as! BookDetailInfoViewController
            let index = sender as! Int

            if let imageStringOfURL = self.books[index].image {
                destination.downloadImage(from: URL(string: imageStringOfURL)!)
            }
            
            if let desc = self.books[index].subtitle {
                destination.setBookDescription(desc: desc)
            }
        }

    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked");
        
        self.books = []
        self.tableView.reloadData()
        
        guard let searchText = searchBar.text else {
            return
        }
        
        self.searchText = searchText
        self.fetchSearchBooks(title: self.searchText, page: 0)
    }
}

