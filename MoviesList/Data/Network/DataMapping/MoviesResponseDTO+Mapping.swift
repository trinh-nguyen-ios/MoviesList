import Foundation

// MARK: - Data Transfer Object
struct OMDBMoviesDTO: Codable {
    let search: [MovieItem]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct MovieItem: Codable, Equatable {
    let title, year, imdbID, type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

// MARK: - Mappings to Domain
extension OMDBMoviesDTO {
    func toDomain() -> OMDBMoviesPage {
        let totalResult: Int = Int(totalResults) ?? 0
        return .init(totalResult: totalResult, movies: search)
    }
}

