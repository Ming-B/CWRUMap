//
//  ContentView.swift
//  CWRUMap
//
//  Created by Ming Bian on 3/20/25.
//

import SwiftUI
import MapKit

struct InterestingPlace: Identifiable {
    let id: UUID = UUID()
    var name:String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    private let locations = [
        InterestingPlace(name: "Olin", coordinate: CLLocationCoordinate2D(latitude: 41.502183, longitude: -81.607837)),
        InterestingPlace(name: "Wade Lagoon", coordinate: CLLocationCoordinate2D(latitude: 41.506145, longitude: -81.611097)),
        InterestingPlace(name: "Cleveland Museum of Art", coordinate: CLLocationCoordinate2D(latitude: 41.508636, longitude: -81.611392)),
    
    ]
    
    @State var position = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.511020, longitude: -81.611563), span: .init(latitudeDelta: 1, longitudeDelta: 1))
        
    )
    @State private var route:MKRoute?
    func getDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 41.511020, longitude: -81.611563)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 41.506145, longitude: -81.611097)))
        request.transportType = .walking
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    @State var selectedPlace: UUID?
    
    var body: some View {
        Map(selection:$selectedPlace){
            ForEach(locations) { location in
                Marker(location.name, systemImage: "graduationcap", coordinate: location.coordinate)
            }
            
            Annotation("Walking Path", coordinate: CLLocationCoordinate2D(latitude: 41.511020, longitude: -81.611563)) {
                VStack {
                    Image(systemName: "figure.walk")
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(.buttonBorder)
                    
                    Text("Walking Path")
                }
            }.annotationTitles(.hidden)
            MapCircle(center: CLLocationCoordinate2D(latitude: 41.511020, longitude: -81.611563), radius: 80)
                .foregroundStyle(.blue.opacity(0.3))
            
        }
        .mapStyle(.imagery)
        
    }
}

#Preview {
    ContentView()
}
