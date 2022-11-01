//
//  BookRow.swift
//  SeniorCollegeBookApp
//
//  Created by Seungchul Lee on 2022/11/01.
//

import Foundation
import Combine
import SwiftUI

struct BookRow: View {
    var imageURL: URL?
    var title: String?
    var description: String?
    
    init(imageURL: URL? = nil, title: String? = nil, description: String? = nil) {
        self.imageURL = imageURL
        self.title = title
        self.description = description
        
        print("\(imageURL?.absoluteString ?? "")")
    }
    
    var body: some View {
        HStack {
            if let imageURL = self.imageURL {
                AsyncImage(url: imageURL)
                    .scaledToFill()
                    .frame(width: 90, height: 120)
                    .clipped()
            }
            
            VStack(alignment: .leading) {
                if let title = self.title {
                    Text("\(title)")
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding(.bottom, 6)
                }
                
                if let desc = self.description {
                    Text("\(desc)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
