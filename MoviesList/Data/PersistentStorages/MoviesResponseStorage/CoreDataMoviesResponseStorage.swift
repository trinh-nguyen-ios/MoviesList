import Foundation
import CoreData

final class CoreDataMoviesResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataMoviesResponseStorage: MoviesResponseStorage {

}
