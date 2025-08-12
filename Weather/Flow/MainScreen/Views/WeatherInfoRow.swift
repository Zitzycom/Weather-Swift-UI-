import SwiftUI

struct WeatherInfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.yellow)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    WeatherInfoRow(icon: "thermometer", label: "Ощущается", value: "\(Int(10))°")
}
