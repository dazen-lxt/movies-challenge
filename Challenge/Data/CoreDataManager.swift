//
//  CoreDataManager.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import CoreData
import UIKit

protocol CoreDataManagerLogic {
    func getMovies(genres: [Int], year: Int?) async -> [Movie]
}

extension CoreDataManagerLogic {

    func getMovies() async -> [Movie] {
        return await getMovies(genres: [], year: nil)
    }
}

class CoreDataManager: CoreDataManagerLogic {

    static let shared = CoreDataManager(modelName: "Challenge")
    
    private let modelName: String
    
    private init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error: NSError = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    func getMovieById(id: Int) async  -> Movie? {
        return fetchEntities(predicate: NSPredicate(format: "id == %d", id), fetchLimit: 1)?.first
    }

    func existMovie(id: Int) async -> Bool {
        return await getMovieById(id: id) != nil
    }

    func getGenres() async -> [Genre] {
        return fetchEntities() ?? []
    }

    func getYears() async -> Set<Int> {
        let fetchRequest: NSFetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        fetchRequest.propertiesToFetch = ["releaseYear"]
        fetchRequest.returnsDistinctResults = true
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return Set(result.map { Int($0.releaseYear) })
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }

    func saveMovie(movie: MovieModel, genres: [IdNameModel]) async {
        let newMovie: Movie = Movie(context: managedObjectContext)
        newMovie.id = Int64(movie.id)
        newMovie.title = movie.title
        newMovie.overview = movie.overview
        newMovie.releaseYear = Int16(movie.releaseYear ?? 0)
        newMovie.posterPath = movie.posterPath
        newMovie.backdropPath = movie.backdropPath
        genres.forEach { genre in
            let genreCoreData: Genre!
            let results: [Genre] = fetchEntities(predicate: NSPredicate(format: "id = %d", genre.id)) ?? []
            if results.isEmpty {
                genreCoreData = Genre(context: managedObjectContext)
                genreCoreData.id = Int32(genre.id)
                genreCoreData.name = genre.name
            } else {
                genreCoreData = results.first
            }
            newMovie.addToGenres(genreCoreData)
        }
        saveContext()
    }

    func getMovies(genres: [Int] = [], year: Int? = nil) async -> [Movie] {
        var predicates: [NSPredicate] = []
        if !genres.isEmpty {
            predicates.append(NSPredicate(format: "SUBQUERY(genres, $x, ANY $x.id in %@).@count != 0", genres))
        }
        if let year = year {
            predicates.append(NSPredicate(format: "releaseYear == %d", year))
        }
        return fetchEntities(predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicates)) ?? []
    }

    func deleteMovie(idMovie: Int) async {
        guard let movie: Movie = await getMovieById(id: idMovie) else { return }
        managedObjectContext.delete(movie)
        saveContext()
    }
    
    func fetchEntities<T: NSManagedObject>(predicate: NSPredicate? = nil, fetchLimit: Int? = nil) -> [T]? {
        print(T.entity())
        let fetchRequest: NSFetchRequest = NSFetchRequest<T>(entityName: T.entity().name ?? "")
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        return try? managedObjectContext.fetch(fetchRequest)
    }
    
    func saveContext () {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("CoreDataManager error. \(error)")
            }
        }
    }
}
