import CoreLocation
import MapKit
import SwiftUI

struct RunRouteMap: View {
    let coordinates: [CLLocationCoordinate2D]
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            if coordinates.count > 1 {
                MapPolyline(coordinates: coordinates)
                    .stroke(AppTheme.accent, lineWidth: 5)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .frame(minHeight: 230)
        .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                .stroke(AppTheme.stroke, lineWidth: 1)
        }
        .accessibilityLabel("Run route map")
        .accessibilityValue("\(coordinates.count) GPS points recorded")
    }
}
