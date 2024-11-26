
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    // @State private var hasSeenSplash = false
    // @State private var isPulsing = false
    
    // Ticker and Settings States
    @State private var isTickerEnabled = true
    @State private var tickerPosition = NewsTicker.TickerPosition.top
    @State private var fontSize: CGFloat = 16
    @State private var textColor: Color = .black
    @State private var darkMode = false
    @State private var preferredCountry = "All Countries"
    @State private var preferredCategory = "All Categories"
    @State private var newsCount = 10
    
    var body: some View {
            mainView
        /* if !hasSeenSplash {
         splashView
         } else {
         mainView
         }*/
        //.prefferdColorScheme(.dark)
    }
    
    /* private var splashView: some View {
     ZStack {
     Color.black.ignoresSafeArea()
     Image("newspaper")
     .resizable()
     .scaledToFit()
     .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.5)
     .scaleEffect(isPulsing ? 1.2 : 1.0) // Pulsing effect
     .rotationEffect(.degrees(360))
     .animation(.easeInOut(duration: 0.8).repeatForever(), value: isPulsing)
     .onAppear {
     isPulsing = true
     DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
     hasSeenSplash = true
     viewModel.fetchNews()
     }
     }
     }
     }*/
    
    private var mainView: some View {
            VStack(spacing: 0) {
                // Ticker at the top
                if isTickerEnabled && tickerPosition == .top {
                    NewsTickerOverlay()
                    //.padding(.top, 20) // Avoid notch or status bar overlap
                    
                }
                
                // Main Content
                ZStack(alignment: .bottom) {
                    Color.black.ignoresSafeArea()
                    TabView {
                        ArticlesListView(articles: viewModel.articles)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        
                        NavigationView {
                            Settings(
                                isTickerEnabled: $isTickerEnabled,
                                tickerPosition: $tickerPosition,
                                fontSize: $fontSize,
                                textColor: $textColor,
                                darkMode: $darkMode,
                                preferredCountry: $preferredCountry,
                                preferredCategory: $preferredCategory,
                                newsCount: $newsCount
                            )
                        }
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                    .onAppear {
                        viewModel.fetchNews()
                    }
                    .alert(item: $viewModel.alertMessage) { alert in
                        Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
                    }
                    
                    // Ticker at the bottom
                    if isTickerEnabled && tickerPosition == .bottom {
                        NewsTickerOverlay()
                            .padding(.bottom, 50) // Space for TabView icons
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom) // Prevents layout issues at the bottom
    }
        
        private func NewsTickerOverlay() -> some View {
            NewsTicker(
                articles: $viewModel.articles,
                isTickerEnabled: $isTickerEnabled,
                tickerPosition: $tickerPosition,
                fontSize: $fontSize,
                textColor: $textColor,
                darkMode: $darkMode,
                preferredCountry: $preferredCountry,
                preferredCategory: $preferredCategory,
                newsCount: $newsCount
            )
            .frame(height: 40) // Fixed ticker height
            .background(darkMode ? Color.black : Color.white)
            .overlay(
                Rectangle()
                    .fill(darkMode ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
            )
            //.padding(.horizontal)
            .zIndex(1) // Ensures it's above other content
        }
    }


struct ArticlesListView: View {
    let articles: [Article]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) { // Space between articles
                    ForEach(articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            VStack(alignment: .leading, spacing: 10) { // Space between elements
                                
                                // Article title
                                Text(article.title)
                                   // .font(.headline)
                                    .fontWeight(.bold)
                                    .font(.system(size: 25))
                                    .padding(.horizontal, 10) // Slight indent for title
                                    //.padding(5) // Spacing below title
                                    .multilineTextAlignment(.leading)
                                    
                                
                                // Full-width image
                                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity) // Full width
                                            .clipped() // Prevent overflow
                                    } placeholder: {
                                        ProgressView()
                                            .frame(maxWidth: .infinity, minHeight: 200) // Placeholder height
                                    }
                                }
                                
                                // Source name
                                Text(article.source.name)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 10) // Align to the left under the image
                                
                              
                            }
                            .background(Color.white) // Background for each article
                            .cornerRadius(10) // Rounded corners
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5) // Subtle shadow
                            .padding(.horizontal) // Space around articles
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground)) // Background color for the list
            .navigationTitle("Articles")
        }
    }
}

    
/*
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
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                    }
                    .listStyle(PlainListStyle()) // Optional for styling the list
                    .background(Color.black)
                    .navigationTitle("Articles")
                    .background(Color.black)
                }
                
            }
            
        }*/
        
    
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
#Preview{
    ContentView()
}

                        
/*import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var hasSeenSplash = false
    @State private var isPulsing = false
    

    var body: some View {
        
        if hasSeenSplash == false {
            ZStack{
                Color.black
                    .ignoresSafeArea()
                // Text("Animation")
                Image("newspaper")
                    .resizable()
                    .scaledToFit()
                //.frame(width: 200)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.5)
                    .scaleEffect(isPulsing ? 1.2 : 1.0) // Pulsing effect
                                        .rotationEffect(.degrees(360))
                                        .animation(.easeInOut(duration: 0.8).repeatForever(), value: isPulsing) // Animation for pulsing
                                        .animation(.bouncy.speed(0.5), value: 360) // Animation for rotation
                                        .onAppear {
                                            isPulsing = true // Start pulsing animation
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                hasSeenSplash = true
                                                viewModel.fetchNews()
                                            }
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
*/
