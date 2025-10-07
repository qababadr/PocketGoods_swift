//
//  ProductViewModel.swift
//  ProductFeature
//
//  Created by BADR  QABA on 2025-10-07.
//

@preconcurrency import Combine
import CoreApp
import Foundation

@MainActor
public class ProductViewModel: ObservableObject {

    @Published
    public private(set) var state: ProductState = .init()

    @Published
    public var searchQuery: String = ""

    private var cancellables: Set<AnyCancellable> = []

    private let useCases: ProductUseCases?

    public init(useCases: ProductUseCases?) {
        self.useCases = useCases

        $searchQuery
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                guard let self else { return }
                searchSuggestions()
            }
            .store(in: &cancellables)
    }

    public func onEvent(event: ProductEvent) {

        switch event {

        case .getProducts:
            getProducts()
        case .onNextPage:
            onNextPage()
        case .loadProduct(let productId):
            loadProduct(productId)
        case .searchSuggestions:
            searchSuggestions()
        case .searchProducts:
            searchProducts()
        case .clearSearch:
            clearSearch()
        }

    }

    private func onNextPage() {
        state = state.copy(
            currentPage: state.currentPage + 1
        )
    }

    private func getProducts() {
        guard let useCases else { return }

        if state.currentPage <= state.lastPage {
            Task {
                await useCases
                    .getProducts(page: state.currentPage)
                    .receive(on: DispatchQueue.main)
                    .sink {
                        [weak self]
                        (resource: Resource<PaginationResponse<ProductPreview>>)
                        in

                        guard let self else { return }

                        switch resource {

                        case .loading(_):
                            state = state.copy(isPageLoading: true)
                            break

                        case .success(data: let response):
                            let newList = state.products + response.data
                            state = state.copy(
                                products: newList.distinctBy { $0.id },
                                lastPage: response.lastPage,
                                isPageLoading: false
                            )
                            break

                        case .error(_, let error):
                            if (error as? URLError)?.code == .cancelled {
                                return
                            }
                            if (error! as NSError).code == NSURLErrorCancelled {
                                return
                            }
                            state = state.copy(
                                isPageLoading: false,
                                error: error
                            )
                            break

                        default:
                            state = state.copy(isPageLoading: false)
                        }
                    }
                    .store(in: &cancellables)

            }
        }
    }

    private func loadProduct(_ productId: Int64) {
        guard let useCases else { return }

        Task {
            await useCases.getProduct(id: productId)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] (resource: Resource<Product?>) in
                    guard let self else { return }
                    switch resource {
                    case .loading(let data):
                        let product = data as? Product
                        state = state.copy(
                            isPageLoading: true,
                            product: product
                        )
                        break

                    case .success(let product):
                        state = state.copy(
                            isPageLoading: false,
                            product: product
                        )
                        break

                    case .error(_, let error):
                        state = state.copy(
                            isPageLoading: false,
                            error: error
                        )

                    default:
                        state = state.copy(
                            isPageLoading: false
                        )
                    }
                }
                .store(in: &cancellables)
        }
    }

    private func searchSuggestions() {
        guard let useCases else { return }

        if !searchQuery.isEmpty {
            Task {
                await useCases
                    .getSuggestedProducts(query: searchQuery)
                    .receive(on: DispatchQueue.main)
                    .sink {
                        [weak self] (resource: Resource<[ProductPreview]>) in
                        guard let self = self else { return }
                        switch resource {

                        case .loading(_):
                            state = state.copy(isSearching: true)
                            break

                        case .success(let data):
                            state = state.copy(
                                isSearching: false,
                                suggestedProducts: data
                            )
                        case .error(_, let error):
                            state = state.copy(
                                error: error,
                                isSearching: false,
                            )
                            break

                        default:
                            state = state.copy(isSearching: false)
                        }
                    }
                    .store(in: &cancellables)
            }
        }
    }

    private func searchProducts() {
        guard let useCases else { return }

        if state.currentPage <= state.lastPage && !searchQuery.isEmpty {
            Task {
                await useCases
                    .searchProducts(query: searchQuery, page: state.currentPage)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] (resource: Resource<PaginationResponse<ProductPreview>>) in
                        guard let self = self else { return }
                        
                        switch resource {
                            
                        case .loading(_):
                            state = state.copy(isPageLoading: true)
                            
                        case .success(data: let response):
                            let newList =
                                state.products + response.data
                            state = state.copy(
                                products: newList.distinctBy { $0.id },
                                lastPage: response.lastPage,
                                isPageLoading: false
                            )
                            break
                            
                        case .error(_, error: let error):
                            state = state.copy(
                                isPageLoading: false,
                                error: error,
                            )
                            break
                            
                        default:
                            state = state.copy(isPageLoading: false)
                        }
                    }
                    .store(in: &cancellables)
            }
        }
    }
    
    private func clearSearch() {
        state = state.copy(
            suggestedProducts: [],
        )
        searchQuery = ""
    }
}
