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
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    private let locations = [
        InterestingPlace(name: "Olin", coordinate: CLLocationCoordinate2D(latitude: 41.502183, longitude: -81.607837)),
        InterestingPlace(name: "Wade Lagoon", coordinate: CLLocationCoordinate2D(latitude: 41.506145, longitude: -81.611097)),
        InterestingPlace(name: "Cleveland Museum of Art", coordinate: CLLocationCoordinate2D(latitude: 41.508636, longitude: -81.611392)),
    
    ]
    
    @State var position = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.511020, longitude: -81.611563), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    )
    
    
    @State private var route:MKRoute?
    
    func getDirections() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 41.502183, longitude: -81.607837)))
        //mkmapitem wrapper around destination, source where you start, destination where you want to end up
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 41.508636, longitude: -81.611392)))
        request.transportType = .walking
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    
    @State var selectedPlace: UUID? ///allows for selection of a place
    
    var body: some View {
        Map(selection: $selectedPlace) {
            if let route {
                MapPolyline(route)
                    .stroke(.green, lineWidth: 5)
                
            }
            ForEach(locations) { location in
                Marker(location.name, systemImage: "graduationcap.fill", coordinate: location.coordinate)
            }
            Annotation("Walking Path", coordinate: CLLocationCoordinate2D(latitude: 41.511020, longitude: -81.611563)) {
                VStack {
                    Image(systemName: "figure.walk")
                        .padding(5)
                        .background(Color.blue)
                        .clipShape(.circle)
                    
                    Text("Walking Path")
                        .foregroundStyle(.white)
                }
            }
            .annotationTitles(.hidden)
            MapCircle(center: CLLocationCoordinate2D(latitude: 41.511020, longitude: -81.611563), radius: 80)
                .foregroundStyle(.blue.opacity(0.3))
            
            MapPolyline(coordinates: [CLLocationCoordinate2D(latitude: 41.502183, longitude: -81.607837), CLLocationCoordinate2D(latitude: 41.506145, longitude: -81.611097), CLLocationCoordinate2D(latitude: 41.508636, longitude: -81.611392)])
                .stroke(Color.blue, lineWidth: 3.0)
            

        }
        .mapStyle(.imagery(elevation: .realistic))
        .onAppear {
            getDirections()
        }
        
    }
}

#Preview {
    ContentView()
}
