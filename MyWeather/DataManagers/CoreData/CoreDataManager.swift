//
//  CoreDataManager.swift
//  Weather
//
//  Created by Миша Вашкевич on 05.04.2024.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    
    func updateWeatherData(locationName: String, weather: WeatherModel)
    func fetchPlaces(complition: (Result<[Place], Error>) -> Void)
    func saveLocation(location: PlaceModel, complition: @escaping(Result<Place, Error>) -> Void)
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
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
    
    func delelePostFromFvorite(location: Place) {
        
        persistentContainer.performBackgroundTask { backgroundContext in
            let placeForDelete = backgroundContext.object(with: location.objectID)
            backgroundContext.delete(placeForDelete)
            
            do {
                try backgroundContext.save()
            } catch {
                print(error.localizedDescription)
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
}

