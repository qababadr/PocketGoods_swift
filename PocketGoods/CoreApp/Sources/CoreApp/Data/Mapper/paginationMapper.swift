//
//  paginationMapper.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

extension PaginationResponseDTO {
    public func toPaginationResponse<Model>(
        of: Model.Type,
        to: (T) -> Model
    ) -> PaginationResponse<Model> {
        return PaginationResponse(
            data: data.map(to),
            firstLink: links.first,
            lastLink: links.last,
            currentPage: meta.currentPage,
            from: meta.from,
            lastPage: meta.lastPage,
            path: meta.path,
            perPage: meta.perPage,
            to: meta.to,
            total: meta.total,
            nextLink: links.next,
            prevLink: links.prev
        )
    }
}

extension SearchPaginationResponseDTO {
    public func toSearchPaginationResponse<Model>(
        of: Model.Type,
        to: (T) -> Model
    ) -> SearchPaginationResponse<Model> {
        return SearchPaginationResponse(
            data: data.map(to),
            lastPage: lastPage
        )
    }
}

