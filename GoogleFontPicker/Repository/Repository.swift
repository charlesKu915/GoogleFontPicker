//
//  Repository.swift
//  GoogleFontPicker
//
//  Created by Charles Ku on 2019/3/29.
//  Copyright © 2019 Charles Ku. All rights reserved.
//

import Foundation

protocol Repository: class {
    
    associatedtype IdType: Hashable
    associatedtype EntityType: Any
    
    @discardableResult
    func save(_ entity: EntityType) -> IdType?
    
    func identify(_ entity: EntityType) -> IdType
    
    func get(identified id: IdType) -> EntityType?
    
    func getAll() -> [EntityType]
    
    func mapAll() -> [IdType: EntityType]
    
    func update(_ entity: EntityType)
    
    @discardableResult
    func saveOrUpdate(_ entity: EntityType) -> IdType?
    
    func hasSaved(_ entity: EntityType) -> Bool
    
    func hasSaved(identified id: IdType) -> Bool
    
    func removeAll()
    
    func remove(identified id: IdType)
}
