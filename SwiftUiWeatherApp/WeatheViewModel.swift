//
//  WeatheViewModel.swift
//  SwiftUiWeatherApp
//
//  Created by ipeerless on 17/01/2025.
//
import Foundation
import Observation

@Observable
class WeatherViewModel {
    
    struct Returned: Codable {
        var current: Current
        var daily: Daily
    }
    
    struct Current: Codable {
        var temperature_2m: Double
        var apparent_temperature: Double
        var wind_speed_10m: Double
        var weather_code: Int
    }
    
    struct Daily: Codable {
        var time: [String] = []
        var weather_code: [Int] = []
        var temperature_2m_max: [Double] = []
        var temperature_2m_min: [Double] = []
        
    }
    var temperature: Double = 0.0
    var feelsLike: Double = 0.0
    var windSpeed: Double = 0.0
    var weatherCode: Int = 0
    var date: [String] = []
    var DailyWeatherCode: [Int] = []
    var dailyHighTemp: [Double] = []
    var dailylowTemp: [Double] = []
    var urlString = "https://api.open-meteo.com/v1/forecast?latitude=42.33467401570891&longitude=-71.17007347605109&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&hourly=uv_index&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timezone=auto"
    
    func fetchData() async {
        guard let url = URL(string: urlString) else {return}
        
        do {
            let (data, _ ) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else{return}
            temperature = returned.current.temperature_2m
            feelsLike = returned.current.apparent_temperature
            windSpeed = returned.current.wind_speed_10m
            weatherCode = returned.current.weather_code
            
            date = returned.daily.time
            DailyWeatherCode = returned.daily.weather_code
            dailyHighTemp = returned.daily.temperature_2m_max
            dailylowTemp = returned.daily.temperature_2m_min

            print("Daily Weather Codes: \(DailyWeatherCode)")
            print("Dates: \(date)")
            print("Daily Low Temps: \(dailylowTemp)")
            print("Daily High Temps: \(dailyHighTemp)")

        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
