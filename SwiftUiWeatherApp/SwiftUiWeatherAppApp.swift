//
//  SwiftUiWeatherAppApp.swift
//  SwiftUiWeatherApp
//
//  Created by ipeerless on 17/01/2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftUiWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .modelContainer(for: Preference.self)
        }
    }
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
