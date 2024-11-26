//
//  SettingsView.swift
//  YourNews
//
//  Created by Hannah Eilertsen on 25/11/2024.
//
// Window for settings

import SwiftUI

struct Settings: View {
    @Binding var isTickerEnabled: Bool
    @Binding var tickerPosition: NewsTicker.TickerPosition
    @Binding var fontSize: CGFloat
    @Binding var textColor: Color
    @Binding var darkMode: Bool
    @Binding var preferredCountry: String
    @Binding var preferredCategory: String
    @Binding var newsCount: Int
    
    let countries = ["All Countries", "US", "UK", "France", "Germany", "India", "Japan", "Norway"]
    let categories = ["All Categories", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"]
    
    var body: some View {
        Form {
            Section(header: Text("Ticker Settings")) {
                Toggle("Enable News Ticker", isOn: $isTickerEnabled)
                
                Picker("Ticker Position", selection: $tickerPosition) {
                    Text("Top").tag(NewsTicker.TickerPosition.top)
                    Text("Bottom").tag(NewsTicker.TickerPosition.bottom)
                }.pickerStyle(SegmentedPickerStyle())
                
                Stepper("Number of News: \(newsCount)", value: $newsCount, in: 1...50)
            }
            
            Section(header: Text("Appearance")) {
                ColorPicker("Text Color", selection: $textColor)
                Slider(value: $fontSize, in: 10...30, step: 1, label: {
                    Text("Font Size")
                })
                Toggle("Dark Mode", isOn: $darkMode)
            }
            
            Section(header: Text("Preferences")) {
                Picker("Country", selection: $preferredCountry) {
                    ForEach(countries, id: \.self) { country in
                        Text(country)
                    }
                }
                
                Picker("Category", selection: $preferredCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

