//
//  PreferenceView.swift
//  SwiftUiWeatherApp
//
//  Created by ipeerless on 19/01/2025.
//

import SwiftUI
import SwiftData

struct PreferenceView: View {
    @Query var preferences: [Preference]
    @State var  locationName = ""
    @State var latString = ""
    @State var longString = ""
    @State var selectedUnit = UnitSystem.imperial
    @State var degreeUnitShowing = true
    var degreeUnit: String {
        if degreeUnitShowing {
            return selectedUnit == .imperial ? "F" : "C"
        }
        return ""
    }
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("Location", text: $locationName)
                    .textFieldStyle(.roundedBorder)
                    .font(.title)
                    .padding(.bottom)
                Group {
                    Text("Latitude")
                        .bold()
                    
                    TextField("Latitude", text: $latString)
                    
                    Text("Longitude")
                        .bold()
                    TextField("Longitude", text: $longString)
                        .padding(.bottom)
                }
                .font(.title2)
                HStack {
                    Text("Units:")
                        .bold()
                    Spacer()
                    Picker("", selection: $selectedUnit) {
                        ForEach(UnitSystem.allCases, id: \.self) { unit in
                            Text(unit.rawValue)
                        }
                    }
                    .padding(.bottom)
                }
                .font(.title2)
                Toggle("Show F/C after temp value:", isOn: $degreeUnitShowing)
                    .font(.title2)
                    .bold()
                HStack {
                    Spacer()
                    Text("42°\(degreeUnit)")
                        .font(.system(size: 150))
                        .fontWeight(.thin)
                    Spacer()
                }
            }.padding()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            if !preferences.isEmpty {
                                for preference in preferences {
                                    modelContext.delete(preference)
                                }
                            }
                            let preference = Preference(
                                locationName: locationName,
                                latString: latString,
                                longString: longString,
                                selectedUnit: selectedUnit,
                                degreeUnitShowing: degreeUnitShowing
                            )
                            modelContext.insert(preference)
                            guard let  _ = try? modelContext.save() else {return}
                            dismiss()
                        }
                    }
                }
        }
        .task {
            guard !preferences.isEmpty else {return}
            let preference = preferences.first!
            locationName = preference.locationName
            latString = preference.latString
            longString =  preference.longString
            selectedUnit = preference.selectedUnit
            degreeUnitShowing = preference.degreeUnitShowing
        }
    }
}

#Preview {
    PreferenceView()
        .modelContainer(Preference.preview)
}
