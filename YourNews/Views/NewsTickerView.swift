
//
// Top News
//
//  NewsTicker.swift
//  YourNews
//
//  Created by Hannah Eilertsen on 26/11/2024.
//

import SwiftUI

struct NewsTicker: View {
    @Binding var articles: [Article] // Bound to the articles in NewsViewModel
    @Binding var isTickerEnabled: Bool
    @Binding var tickerPosition: TickerPosition
    @Binding var fontSize: CGFloat
    @Binding var textColor: Color
    @Binding var darkMode: Bool
    @Binding var preferredCountry: String
    @Binding var preferredCategory: String
    @Binding var newsCount: Int
    
    enum TickerPosition {
        case top, bottom
    }
    
    var body: some View {
        VStack {
            if isTickerEnabled {
                if tickerPosition == .top {
                    tickerView
                }
                Spacer()
                if tickerPosition == .bottom {
                    tickerView
                }
            }
        }
        .background(darkMode ? Color.black : Color.white)
       // .edgesIgnoringSafeArea(.all)
    }
    
    private var tickerView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            //HStack(spacing: 40) {
            HStack() {
                ForEach(articles.prefix(newsCount)) { article in
                    Text(article.title)
                        .font(.system(size: fontSize).bold())
                        .foregroundColor(textColor)
                        .onTapGesture {
                            showDetail(for: article)
                        }
                        .padding(.horizontal, 10)
                }
            }
        }
        //.padding()
        .background(darkMode ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
        .frame(height: 50)
    
    }
    
    private func showDetail(for article: Article) {
        // Implement the enlargement and temporary display of the selected news article
        // Animations and a timer can be used here
    }
}
