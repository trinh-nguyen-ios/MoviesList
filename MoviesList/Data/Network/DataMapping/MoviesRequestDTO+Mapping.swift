import Foundation

struct OMDBMoviesRequestDTO: Encodable {
    let query: String
    let page: Int
}
