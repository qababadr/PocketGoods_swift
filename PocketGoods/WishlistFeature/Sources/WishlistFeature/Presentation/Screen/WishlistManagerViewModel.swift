//
//  WishlistManagerViewModel.swift
//  WishlistFeature
//
//  Created by BADR  QABA on 2025-10-11.
//

@preconcurrency import Combine
import Foundation

@MainActor
public class WishlistManagerViewModel: ObservableObject {

    @Published
    public var state: WishlistManagerState = WishlistManagerState()

    private var cancellables: Set<AnyCancellable> = []

    private let useCases: WishlistUseCases?

    public init(useCases: WishlistUseCases?) {
        self.useCases = useCases
    }

    public func onEvent(event: WishlistManagerScreenEvent) {
        switch event {

        case .getWishlistItems(let userId):
            getWishlistItems(userId: userId)

        case .deleteWishlistItem(
            let userId,
            let productId,
            let onSuccess,
            let onError
        ):
            deleteWishlistItem(
                userId: userId,
                productId: productId,
                onSuccess: onSuccess,
                onError: onError
            )
        }
    }

    private func getWishlistItems(userId: Int64) {
        guard let useCases else { return }

        Task {
            await useCases
                .getEntireWishlist()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    if case .failure(let error) = completion {
                        state = state.copy(
                            error: error
                        )
                    }
                } receiveValue: { [weak self] resource in
                    guard let self else { return }
                    switch resource {
                    case .loading(_):
                        state = state.copy(isPageLoading: true)
                    case .success(let data):
                        state = state.copy(
                            isPageLoading: false,
                            wishlist: data
                        )
                    case .error(_, let error):
                        state = state.copy(
                            isPageLoading: false,
                            error: error
                        )

                    default:
                        break
                    }
                }
                .store(in: &cancellables)
        }
    }

    private func deleteWishlistItem(
        userId: Int64,
        productId: Int64,
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error?) -> Void
    ) {
        guard let useCases else { return }

        Task {
            state = state.copy(isDeleting: true)

            do {
                let _ = try await useCases.toggleWishlist(
                    userId: userId,
                    productId: productId
                )

                state = state.copy(isDeleting: false)

                onSuccess()

            } catch {
                onError(error)
                state = state.copy(isDeleting: false)
            }
        }
    }
}
