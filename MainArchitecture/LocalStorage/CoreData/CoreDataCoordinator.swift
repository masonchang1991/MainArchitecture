//
//  CoreDataCoordinator.swift
//  MainArchitecture
//
//  Created by Mason on 2019/12/3.
//  Copyright © 2019 Mason. All rights reserved.
//

import Foundation
import CoreData

enum CDDataModelError: Error {
    case wrongType
}

protocol CoreDataModelRouter {
    static var entityName: String { get set }
}

protocol CoreDataDataModel: CoreDataModelRouter {
    var id: Int { get set }
    static var coreDataModelType: NSManagedObject.Type { get set }
    static func createBy<T: NSManagedObject, DataModel: CoreDataDataModel>(_ model: T) throws -> DataModel
    @discardableResult
    func setCoreData<Object: NSManagedObject>(_ object: inout Object) throws -> Object
}

protocol CoreDataModelCoordinator: class, Loggable {
    //MARK: - Make dataModel's and entity's name same
    var entityName: String { get set }
    var managedObjectModel: NSManagedObjectModel { get set }
    var persistentStoreCoordinator: NSPersistentStoreCoordinator { get set }
    var managedObjectContext: NSManagedObjectContext { get set }
    
    // first load managedObjects, and use it to modify
    var managedObjects: [NSManagedObject] { get set }
    
    func save<Data: CoreDataDataModel, ModelType: NSManagedObject>(data: Data, modelType: ModelType.Type)
    func load<Data: CoreDataDataModel, ModelType: NSManagedObject>(modelType: ModelType.Type, completion: ([Data]) -> Void)
    func update<Data: CoreDataDataModel, ModelType: NSManagedObject>(data: Data, modelType: ModelType.Type)
}

extension CoreDataModelCoordinator {
    
    func update<Data: CoreDataDataModel, ModelType: NSManagedObject>(data: Data, modelType: ModelType.Type) {
        managedObjectContext.performAndWait {
            let fetchReq = NSFetchRequest<ModelType>(entityName: entityName)
            fetchReq.predicate = NSPredicate(format: "id = %d", data.id)
            do {
                guard var coreData = try managedObjectContext.fetch(fetchReq)[exist: 0] else { return }
                try data.setCoreData(&coreData)
                try managedObjectContext.save()
            } catch {
                log(type: .debug, msg: self, "could not update.", "error: \(error)")
            }
        }
    }
    
    func save<DataModel: CoreDataDataModel, ModelType: NSManagedObject>(data: DataModel, modelType: ModelType.Type) {
        managedObjectContext.performAndWait {
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
            var coreData = modelType.init(entity: entity, insertInto: managedObjectContext)
            do {
                try data.setCoreData(&coreData)
                try managedObjectContext.save()
                self.managedObjects.append(coreData)
            } catch {
                log(type: .debug, msg: self, "could not save.", "error: \(error)")
            }
        }
    }
    
    func load<DataModel: CoreDataDataModel, ModelType: NSManagedObject>(modelType: ModelType.Type, completion: ([DataModel]) -> Void) {
        managedObjectContext.performAndWait {
            let fetchReq = NSFetchRequest<ModelType>(entityName: entityName)
            var fetchResult = [ModelType]()
            var datas = [DataModel]()
            do {
                fetchResult = try managedObjectContext.fetch(fetchReq)
                managedObjects = fetchResult
            } catch {
                log(type: .debug, msg: self, "could not load.", "error: \(error)")
            }
            
            for coreDataObject in fetchResult {
                do {
                    let data: DataModel = try DataModel.createBy(coreDataObject)
                    datas.append(data)
                } catch {
                    log(type: .debug, msg: "error: \(error)")
                }
            }
            completion(datas)
        }
    }
}

class BaseCoreDataModelCoordinator: CoreDataModelCoordinator {
    var entityName: String
    var managedObjectModel: NSManagedObjectModel
    var persistentStoreCoordinator: NSPersistentStoreCoordinator
    var managedObjectContext: NSManagedObjectContext
    var managedObjects: [NSManagedObject] = []
    
    init(name: String,
         managedObjectModel: NSManagedObjectModel,
         persistentStoreCoordinator: NSPersistentStoreCoordinator,
         managedObjectContext: NSManagedObjectContext,
         managedObjects: [NSManagedObject] = []) {
        self.entityName = name
        self.managedObjectModel = managedObjectModel
        self.persistentStoreCoordinator = persistentStoreCoordinator
        self.managedObjectContext = managedObjectContext
        self.managedObjects = managedObjects
    }
    
}

struct CoreDataService {
    
    private static var usedModelCoordintors: [String: CoreDataModelCoordinator] = [:]
    
    static func getDataCoordinatorBy(route: CoreDataModelRouter) -> CoreDataModelCoordinator {
        let entityName = type(of: route).entityName
        return getDataCoordinatorBy(entityName: entityName)
    }
    
    static func getDataCoordinatorBy(entityName: String) -> CoreDataModelCoordinator {
        if let modelCoordinator = usedModelCoordintors[entityName] {
            return modelCoordinator
        } else {
            let managedObjModel = createManagedObjModel(entityName + "Model")
            let persistentStoreCoordinator = createPersistentStoreCoordinator(modelName: entityName,
                                                                              managedObject: managedObjModel)
            let managedObjContext = createManagedObjectContext(coordinator: persistentStoreCoordinator)
            let baseCoordinator = BaseCoreDataModelCoordinator(name: entityName,
                                                               managedObjectModel: managedObjModel,
                                                               persistentStoreCoordinator: persistentStoreCoordinator,
                                                               managedObjectContext: managedObjContext,
                                                               managedObjects: [])
            usedModelCoordintors[entityName] = baseCoordinator
            return baseCoordinator
        }
    }
    
    static private var appDocDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    static private func createManagedObjModel(_ modelName: String) -> NSManagedObjectModel {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }
    
    static private func createManagedObjectContext(coordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }
    
    static private func createPersistentStoreCoordinator(modelName: String, managedObject: NSManagedObjectModel) -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObject)
        let url = appDocDirectory.appendingPathComponent("\(modelName).sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            let sqlPathRoot:NSString = url.absoluteString as NSString
            let shmurl:NSURL = NSURL(string: sqlPathRoot.appending("-shm"))!
            let walurl:NSURL = NSURL(string: sqlPathRoot.appending("-wal"))!
            do{
                try FileManager.default.removeItem(at: url)
                try FileManager.default.removeItem(at: shmurl as URL)
                try FileManager.default.removeItem(at: walurl as URL)
            }catch{
                print(error)
            }
        }
        return coordinator
    }
}

