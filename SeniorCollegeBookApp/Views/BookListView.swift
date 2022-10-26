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
                Text("\(bookVM.book.title)")
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
 
