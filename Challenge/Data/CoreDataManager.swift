//
//  CoreDataManager.swift
//  Challenge
//
//  Created by Carlos Mario Munoz Perez on 18/10/22.
//

import CoreData
import UIKit

class CoreDataManager {

    static let shared: CoreDataManager = CoreDataManager()

    private init() {

    }

    private var persistentContainer: NSPersistentContainer {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("AppDelegate Error") }
        return delegate.persistentContainer
    }

    private var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func getMovieById(id: Int) -> Movie? {
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

    func existMovie(id: Int) -> Bool {
        return getMovieById(id: id) != nil
    }

    func getGenres() -> [Genre] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<Genre>(entityName: "Genre")
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }

    func saveMovie(movie: MovieModel, genres: [IdNameModel]) {
        do {
            let newMovie: Movie = Movie(context: managedObjectContext)
            newMovie.id = Int64(movie.id)
            newMovie.title = movie.title
            newMovie.overview = movie.overview
            newMovie.releaseDate = movie.releaseDate
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

    func getMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        do {
            return try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }

    func deleteMovie(idMovie: Int) {
        guard let movie: Movie = getMovieById(id: idMovie) else { return }
        managedObjectContext.delete(movie)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("CoreDataManager error. \(error), \(error.userInfo)")
        }
    }
}
