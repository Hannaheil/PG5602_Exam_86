//
//  Aticles.swift
//  YourNews
//
//  Created by Hannah Eilertsen on 25/11/2024.
//
import Foundation

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


struct Source: Decodable {
    let id: String?
    let name: String
}

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

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



//{
//    "meals": [
//        {
//            "idMeal": "52888",
//            "strMeal": "Eccles Cakes",
//            "strDrinkAlternate": null,
//            "strCategory": "Dessert",
//            "strArea": "British",
//            "strInstructions": "To make the pastry, dice the butter and put it in the freezer to go really hard. Tip flour into the bowl of a food processor with half the butter and pulse to the texture of breadcrumbs. Pour in the lemon juice and 100ml iced water, and pulse to a dough. Tip in the rest of the butter and pulse a few times until the dough is heavily flecked with butter. It is important that you don\u2019t overdo this as the flecks of butter are what makes the pastry flaky.\r\nOn a floured surface roll the pastry out to a neat rectangle about 20 x 30cm. Fold the two ends of the pastry into the middle (See picture 1), then fold in half (pic 2). Roll the pastry out again and refold the same way 3 more times resting the pastry for at least 15 mins each time between roll and fold, then leave to rest in the fridge for at least 30 mins before using.\r\nTo make the filling, melt the butter in a large saucepan. Take it off the heat and stir in all the other ingredients until completely mixed, then set aside.\r\nTo make the cakes, roll the pastry out until it\u2019s just a little thicker than a \u00a31 coin and cut out 8 rounds about 12cm across. Re-roll the trimming if needed. Place a good heaped tablespoon of mixture in the middle of each round, brush the edges of the rounds with water, then gather the pastry around the filling and squeeze it together (pic 3). Flip them over so the smooth top is upwards and pat them into a smooth round. Flatten each round with a rolling pin to an oval until the fruit just starts to poke through, then place on a baking tray. Cut 2 little slits in each Eccles cakes, brush generously with egg white and sprinkle with the sugar (pic 4).\r\nHeat the oven to 220C\/200C fan\/gas 8. Bake the Eccles cakes for 15-20 mins until just past golden brown and sticky. Leave to cool on a rack and enjoy while still warm or cold with a cup of tea. If you prefer, Eccles cakes also go really well served with a wedge of hard, tangy British cheese such as Lancashire or cheddar.",
//            "strMealThumb": "https:\/\/www.themealdb.com\/images\/media\/meals\/wtqrqw1511639627.jpg",
//            "strTags": "Snack,Treat",
//            "strYoutube": "https:\/\/www.youtube.com\/watch?v=xV0QCJ0GD5w",
//            "strIngredient1": "Butter",
//            "strIngredient2": "Plain Flour",
//            "strIngredient3": "Lemon",
//            "strIngredient4": "Butter",
//            "strIngredient5": "Currants",
//            "strIngredient6": "Mixed Peel",
//            "strIngredient7": "Muscovado Sugar",
//            "strIngredient8": "Cinnamon",
//            "strIngredient9": "Ginger",
//            "strIngredient10": "Allspice",
//            "strIngredient11": "Lemon",
//            "strIngredient12": "Eggs",
//            "strIngredient13": "Sugar",
//            "strIngredient14": "",
//            "strIngredient15": "",
//            "strIngredient16": "",
//            "strIngredient17": "",
//            "strIngredient18": "",
//            "strIngredient19": "
