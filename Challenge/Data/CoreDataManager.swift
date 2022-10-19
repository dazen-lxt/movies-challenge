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

    static let shared: CoreDataManager = CoreDataManager()

    private init() {
    }

    var managedObjectContext: NSManagedObjectContext!

    func getMovieById(id: Int) async  -> Movie? {
        let fetchRequest: NSFetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(
            format: "id == %d", id
        )
        fetchRequest.fetchLimit = 1
        do {
            return try managedObjectContext.fetch(fetchRequest).first
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }

    func existMovie(id: Int) async -> Bool {
        return await getMovieById(id: id) != nil
    }

    func getGenres() async -> [Genre] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<Genre>(entityName: "Genre")
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
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
        do {
            let newMovie: Movie = Movie(context: managedObjectContext)
            newMovie.id = Int64(movie.id)
            newMovie.title = movie.title
            newMovie.overview = movie.overview
            newMovie.releaseYear = Int16(movie.releaseYear ?? 0)
            newMovie.posterPath = movie.posterPath
            newMovie.backdropPath = movie.backdropPath
            try genres.forEach { genre in
                let genreCoreData: Genre!
                let fetchGenre: NSFetchRequest<Genre> = Genre.fetchRequest()
                fetchGenre.predicate = NSPredicate(format: "id = %d", genre.id)
                let results: [Genre] = try managedObjectContext.fetch(fetchGenre)
                if results.isEmpty {
                    genreCoreData = Genre(context: managedObjectContext)
                    genreCoreData.id = Int32(genre.id)
                    genreCoreData.name = genre.name
                } else {
                    genreCoreData = results.first
                }
                newMovie.addToGenres(genreCoreData)
            }
            if managedObjectContext.hasChanges {
                try managedObjectContext.save()
            }
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }

    func getMovies(genres: [Int] = [], year: Int? = nil) async -> [Movie] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        var predicates: [NSPredicate] = []
        if !genres.isEmpty {
            predicates.append(NSPredicate(format: "SUBQUERY(genres, $x, ANY $x.id in %@).@count != 0", genres))
        }
        if let year = year {
            predicates.append(NSPredicate(format: "releaseYear == %d", year))
        }
        if !predicates.isEmpty {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }

    func deleteMovie(idMovie: Int) async {
        guard let movie: Movie = await getMovieById(id: idMovie) else { return }
        managedObjectContext.delete(movie)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }
}
