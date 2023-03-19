import Foundation

struct APIEndpoints {
    static func getOBDMMovies(with moviesRequestDTO: OMDBMoviesRequestDTO) -> Endpoint<OMDBMoviesDTO> {
        return Endpoint(
            path: "",
            method: .get,
            queryParameters: ["s": moviesRequestDTO.query, "type": "movie", "page": moviesRequestDTO.page]
        )
    }
}
