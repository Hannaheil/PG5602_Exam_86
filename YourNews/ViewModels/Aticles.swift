//
//  Aticles.swift
//  YourNews
//
//  Created by Hannah Eilertsen on 25/11/2024.

//Model and logic for fetching and managing articles


import Foundation

//Conforms to Decodable
struct Article: Decodable, Identifiable {
    let id = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct AlertMessage: Identifiable {
    let id = UUID()
    let message: String
}

//Source og a news article
struct Source: Decodable {
    let id: String?
    let name: String
}

//Represents the structure of the API's JSON response
struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

//Interfacing with the News API
class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var alertMessage: AlertMessage? = nil // Updated for alerts

    private let apiKey = "89df9d15236d4ae5bfa59f99cb60217f"

    func fetchNews() {
        let urlString = "https://newsapi.org/v2/everything?q=crypto&from=2024-11-01&to=2024-11-25&sources=wired,gizmodo,bbc-news&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            alertMessage = AlertMessage(message: "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.alertMessage = AlertMessage(message: "Request error: \(error.localizedDescription)")
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self?.alertMessage = AlertMessage(message: "No data returned")
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let newsResponse = try decoder.decode(NewsAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.articles = newsResponse.articles
                }
            } catch {
                DispatchQueue.main.async {
                    self?.alertMessage = AlertMessage(message: "Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

