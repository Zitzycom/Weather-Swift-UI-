import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel

    init(repository: WeatherRepositoryProtocol, appState: AppState) {
        _viewModel = StateObject(
            wrappedValue: SearchViewModel(repository: repository, appState: appState)
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchBar

                if viewModel.isSearching {
                    searchingView
                }

                if let error = viewModel.errorText {
                    errorView(error)
                }

                ScrollView {
                    VStack(spacing: 16) {
                        searchResultsSection
                        Divider()
                        savedCitiesSection
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Поиск города")
        }
    }

    @ViewBuilder
    private var searchBar: some View {
        HStack {
            TextField("Название города", text: $viewModel.query)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit {
                    viewModel.performSearch()
                }

            Button {
                viewModel.performSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .padding(6)
            }
            .disabled(viewModel.query.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(.thinMaterial)
    }

    @ViewBuilder
    private var searchingView: some View {
        ProgressView("Поиск...")
            .padding()
    }

    @ViewBuilder
    private func errorView(_ error: String) -> some View {
        Text(error)
            .foregroundColor(.red)
            .padding(.horizontal)
    }

    @ViewBuilder
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Результаты")
                .font(.headline)
                .padding(.horizontal)

            if viewModel.results.isEmpty {
                Text("Нет результатов")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(viewModel.results) { item in
                    Button {
                        viewModel.addCity(from: item)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(item.name), \(item.country)")
                                    .font(.headline)
                                if let state = item.state {
                                    Text(state)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var savedCitiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Сохранённые города")
                .font(.headline)
                .padding(.horizontal)

            if viewModel.savedCities.isEmpty {
                Text("Нет сохранённых городов")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(viewModel.savedCities, id: \.id) { city in
                    HStack {
                        Text(city.displayName)
                            .font(.headline)
                        Spacer()
                        Button {
                            viewModel.removeCity(city)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    SearchView(
        repository: WeatherRepository(
            client: NetworkManager(),
            apiKey: WeatherAPI.apiKey
        ),
        appState: AppState()
    )
}
