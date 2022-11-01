//
//  BookListView.swift
//  SeniorCollegeBookApp
//
//  Created by seungchul lee on 2022/10/26.
//

import SwiftUI

struct BookListView: View {
    @ObservedObject private var newBookListVM = NewBookListViewModel()  
    
    var body: some View {
        NavigationView {
            List(self.newBookListVM.books, id: \.book.title) { bookVM in
                //Text("\(bookVM.book.url!)")
                if let isbn13 = bookVM.book.isbn13 {
                    NavigationLink(destination: BookDetailView(bookCode: isbn13)) {
                        BookRow(imageURL: URL(string:bookVM.book.image!), title: bookVM.book.title, description: bookVM.book.desc)
                    }
                }
            }
            .navigationTitle("노인대학")
        }
    }
}

struct BookListView_Previews: PreviewProvider {
    static var previews: some View {
        BookListView()
    }
}
 
