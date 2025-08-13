import SwiftUI

struct ForecastListView: View {
    @StateObject var viewModel: ForecastListViewModel
    
    init(response: ForecastResponse) {
        _viewModel = StateObject(wrappedValue: ForecastListViewModel(response: response))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Прогноз на 5 дней")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ForEach(viewModel.items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.dateTimeText)
                            .bold()
                            .foregroundColor(.white)
                        Text(item.description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.85))
                    }
                    Spacer()
                    Text("\(item.temp)°")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.trailing, 6)
                    
                    if let url = item.iconURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 44, height: 44)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.05))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ForecastListView(response: WeatherPreviewMock.forecast)
}
