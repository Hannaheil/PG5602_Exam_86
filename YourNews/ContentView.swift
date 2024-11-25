//
//  ContentView.swift
//  YourNews
//
//  Created by Hannah Eilertsen on 25/11/2024.
//

//
//  ContentView.swift
//  RatatouilleExamPractice
//
//  Created by Håkon Bogen on 30/10/2024.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var hasSeenSplash = false

    var body: some View {
           if hasSeenSplash == false {
               Text("Animation")
                   .rotationEffect(.degrees(360))
                   .animation(.bouncy.speed(0.5), value: 360)
                   .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                           hasSeenSplash = true
                           viewModel.fetchNews()
                       }
                   }
           } else {
               TabView {
                   ArticlesListView(articles: viewModel.articles)
                       .tabItem {
                           Label("Home", systemImage: "house")
                       }
                   Text("Other Tab")
                       .tabItem {
                           Label("Other", systemImage: "square.grid.2x2")
                       }
               }
               .onAppear {
                   viewModel.fetchNews()
               }
               .alert(item: $viewModel.alertMessage) { alert in
                   Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
               }
           }
       }
   }

struct ArticlesListView: View {
    let articles: [Article]

    var body: some View {
        NavigationView {
            List(articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    HStack {
                        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.source.name)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Articles")
        }
    }
}

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text(article.title)
                    .font(.title)
                    .bold()
                Text("By \(article.author ?? "Unknown Author")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(article.publishedAt)
                    .font(.footnote)
                    .foregroundColor(.gray)

                Divider()

                Text(article.description ?? "No description available.")
                    .font(.body)

                Button("Read More") {
                    if let url = URL(string: article.url) {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 16)
            }
            .padding()
        }
        .navigationTitle(article.source.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
