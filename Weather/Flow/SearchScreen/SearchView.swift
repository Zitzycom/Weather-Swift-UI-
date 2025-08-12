import SwiftUI


import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    
    init(repository: WeatherRepository, appState: AppState) {
        _viewModel = StateObject(
            wrappedValue: SearchViewModel(repository: repository, appState: appState)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Название города", text: $viewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit {
                            Task { await viewModel.performSearch() }
                        }
                    
                    Button {
                        Task { await viewModel.performSearch() }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .disabled(viewModel.query.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                
                if viewModel.isSearching {
                    ProgressView().padding()
                }
                
                if let error = viewModel.errorText {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                List {
                    if !viewModel.results.isEmpty {
                        Section(header: Text("Результаты")) {
                            ForEach(viewModel.results, id: \.lat) { item in
                                Button {
                                    viewModel.addCity(from: item)
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text("\(item.name), \(item.country)")
                                        if let state = item.state {
                                            Text(state)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Сохранённые города")) {
                        ForEach(Array(viewModel.savedCities.enumerated()), id: \.1.id) { idx, city in
                            HStack {
                                Text(city.displayName)
                                Spacer()
                                if viewModel.selectedCityIndex == idx {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                } else {
                                    Button("Выбрать") {
                                        viewModel.selectCity(at: idx)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: viewModel.removeCity)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Поиск города")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    SearchView(
        repository: DefaultWeatherRepository(client: DefaultNetworkClient(), apiKey: ""), appState: AppState()
    )
    
}
