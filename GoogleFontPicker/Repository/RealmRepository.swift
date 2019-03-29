//
//  RealmRepository.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRepository<IdType: Hashable, EntityType, RealmType: Object>: Repository {
    
    let realm: Realm
    
    init(_ realm: Realm) {
        self.realm = realm
    }
    
    @discardableResult
    func save(_ entity: EntityType) -> IdType? {
        self.realm.beginWrite()
        do {
            let object = try self.toRealmObject(entity)
            self.realm.add(object)
            try self.realm.commitWrite()
            return self.identify(entity)
        }
        catch {
            if self.realm.isInWriteTransaction {
                self.realm.cancelWrite()
            }
            return nil
        }
    }
    
    func identify(_ entity: EntityType) -> IdType {
        fatalError("the concrete class should override this method!")
    }
    
    func get(identified id: IdType) -> EntityType? {
        if let object = self.realm.object(ofType: RealmType.self, forPrimaryKey: id) {
            do {
                let result = try fromRealmObject(object)
                return result
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func getAll() -> [EntityType] {
        let objects = self.realm.objects(RealmType.self).map{$0}
        var result = [EntityType]()
        for object in objects {
            do {
                let entity = try self.fromRealmObject(object)
                result.append(entity)
            } catch {
                
            }
        }
        return result
    }
    
    func mapAll() -> [IdType: EntityType] {
        let entities = self.getAll()
        var result = [IdType: EntityType]()
        for entity in entities {
            result.updateValue(entity, forKey: self.identify(entity))
        }
        return result
    }
    
    func update(_ entity: EntityType) {
        self.realm.beginWrite()
        do {
            try self.realm.add(self.toRealmObject(entity), update: true)
            try self.realm.commitWrite()
        }
        catch Failure.needOverrideMethod {
            print("to realm object failed")
        }
        catch {
            if self.realm.isInWriteTransaction {
                self.realm.cancelWrite()
            }
        }
    }
    
    @discardableResult
    func saveOrUpdate(_ entity: EntityType) -> IdType? {
        if (!self.hasSaved(entity)) {
            return self.save(entity)
        }
        self.update(entity)
        return self.identify(entity)
    }
    
    func hasSaved(_ entity: EntityType) -> Bool {
        let id = self.identify(entity)
        return self.get(identified: id) != nil
    }
    
    func hasSaved(identified id: IdType) -> Bool {
        return self.get(identified: id) != nil
    }
    
    func removeAll() {
        try! self.realm.write {
            self.realm.delete(self.realm.objects(RealmType.self))
        }
    }
    
    func remove(identified id: IdType) {
        if let object = self.realm.object(ofType: RealmType.self, forPrimaryKey: id) {
            try! self.realm.write {
                self.realm.delete(object)
            }
        }
    }
    
    func toRealmObject(_ entity: EntityType) throws -> RealmType  {
        throw Failure.needOverrideMethod
    }
    
    func fromRealmObject(_ object: RealmType) throws -> EntityType {
        throw Failure.needOverrideMethod
    }
}
