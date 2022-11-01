//
//  BookDetailView.swift
//  SeniorCollegeBookApp
//
//  Created by Seungchul Lee on 2022/11/01.
//

import SwiftUI

struct BookDetailView: View {
    @ObservedObject private var bookDetailVM:BookDetailViewModel

    init(bookCode: String) {
        self.bookDetailVM = BookDetailViewModel(bookCode: bookCode)
        
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if let imageStr = self.bookDetailVM.book.image {
                if let imageURL = URL(string:imageStr) {
                    AsyncImage(url: imageURL)
                        .scaledToFill()
                        .frame(width: 300, height: 400)
                        .clipped()
                }
            }
            if let desc = self.bookDetailVM.book.desc {
                Text("\(desc)")
            }
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(bookCode: "")
    }
}
