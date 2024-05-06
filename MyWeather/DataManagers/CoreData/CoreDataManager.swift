//
//  CoreDataManager.swift
//  Weather
//
//  Created by Миша Вашкевич on 05.04.2024.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    
    var fetchResultController: NSFetchedResultsController<Place> {get}
    
    func updateWeatherData(locationName: String, weather: WeatherModel)
    func fetchPlaces(complition: (Result<[Place], Error>) -> Void)
    func saveLocation(location: PlaceModel, complition: @escaping(Result<Place, Error>) -> Void)
    func subscribeFetchResultController(delegate: NSFetchedResultsControllerDelegate)
    func delelePlaceFromFvorite(location: Place, complition: @escaping(Result<String, Error>) -> Void)
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()
    lazy var fetchResultController: NSFetchedResultsController<Place> = {
        
        let request = Place.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                               managedObjectContext: persistentContainer.viewContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        return fetchResultController
    }()
    
    
    func saveLocation(location: PlaceModel, complition: @escaping(Result<Place, Error>) -> Void) {
        
        persistentContainer.performBackgroundTask { backgroundContext in
            
            let place = Place(context: backgroundContext)
            place.name = location.name
            place.latitude = location.latitude
            place.longitude = location.longitude
            place.weatherData = location.weatherData
            place.updateDate = Date()
                do {
                    try backgroundContext.save()
                    complition(.success(place))
                } catch {
                    print(error.localizedDescription)
                    complition(.failure(CoreDataManagerError.saveDataError))
                }
            }
    }
    
    func updateWeatherData(locationName: String, weather: WeatherModel) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
            fetchRequest.predicate = NSPredicate(format: "name = %@", locationName)
            
            do {
                if let result = try backgroundContext.fetch(fetchRequest) as? [NSManagedObject], let place = result.first {
                    
                    do {
                        let weatherData = try JSONEncoder().encode(weather)
                        place.setValue(weatherData, forKey: "weatherData")
                        try backgroundContext.save()
                        print("Данные погоды успешно обновлены в кэше")
                        
                    } catch {
                        // error
                    }
                } else {
                    print("Объект с name \(locationName) не найден")
                }
            } catch {
                print("Ошибка при обновлении данных погоды в кэше: \(error.localizedDescription)")
            }
        }
    }
    
    func delelePlaceFromFvorite(location: Place, complition: @escaping(Result<String, Error>) -> Void) {
        
        persistentContainer.performBackgroundTask { backgroundContext in
            let placeForDelete = backgroundContext.object(with: location.objectID)
            backgroundContext.delete(placeForDelete)
            
            do {
                try backgroundContext.save()
                complition(.success("success"))
            } catch let error {
                complition(.failure(error))
            }
        }
    }
    
    func isEnableToSaveLocation(locationName: String, complition: (Result<Bool, Error>) -> Void) {
        
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        do {
            let place = try persistentContainer.viewContext.fetch(fetchRequest)
            if place.contains(where: {$0.name == locationName}) {
                complition(.failure(CoreDataManagerError.locationAlreadyExist))
            } else {
                complition(.success(true))
            }
        } catch {
            print(CoreDataManagerError.fetchRequestError)
        }
    }
    
    func fetchPlaces(complition: (Result<[Place], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        do {
            let places = try persistentContainer.viewContext.fetch(fetchRequest)
            complition(.success(places))
        } catch {
            complition(.failure(CoreDataManagerError.fetchRequestError))
        }
    }
    func subscribeFetchResultController(delegate: NSFetchedResultsControllerDelegate) {
        fetchResultController.delegate = delegate
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }
}

