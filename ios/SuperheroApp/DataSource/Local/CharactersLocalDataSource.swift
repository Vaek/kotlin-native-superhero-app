//
//  CharactersLocalDataSource.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 11..
//  Copyright © 2018. W.UP. All rights reserved.
//

import CoreData
import Common

class CharactersLocalDataSource: CharactersDataSource {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func loadCharacters(page: CommonPage, complete: @escaping ([CommonCharacter]) -> Void, fail: @escaping () -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CharacterEntity")
        fetchRequest.fetchLimit = Int(page.limit)
        fetchRequest.fetchOffset = Int(page.offset)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            let result = try self.persistentContainer.viewContext.fetch(fetchRequest)

            var characters = [CommonCharacter]()

            for entity in result {

                if let characterId = entity.value(forKey: "id") as? Int32,
                    let name = entity.value(forKey: "name") as? String,
                    let thumbnailUrl = entity.value(forKey: "thumbnailUrl") as? String {
                    let character = CommonCharacter(characterId: characterId, name: name, thumbnailUrl: thumbnailUrl)
                    characters.append(character)
                }
            }

            complete(characters)

        } catch {
            fail()
        }
    }

    func loadCharacter(characterId: Int32, complete: @escaping (CommonCharacter?) -> Void, fail: @escaping () -> Void) {

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CharacterEntity")
        fetchRequest.predicate = NSPredicate(format: "id = \(characterId)")

        do {
            let result = try self.persistentContainer.viewContext.fetch(fetchRequest)

            if let entity = result.first,
                let characterId = entity.value(forKey: "id") as? Int32,
                let name = entity.value(forKey: "name") as? String,
                let thumbnailUrl = entity.value(forKey: "thumbnailUrl") as? String {
                let character = CommonCharacter(characterId: characterId, name: name, thumbnailUrl: thumbnailUrl)
                complete(character)
            }

        } catch {
            fail()
        }
    }

    func saveCharacters(characters: [CommonCharacter], complete: @escaping () -> Void, fail: @escaping () -> Void) {

        for character in characters {
            let entity = NSEntityDescription .insertNewObject(forEntityName: "CharacterEntity",
                                                              into: self.persistentContainer.viewContext)
            entity.setValue(character.characterId, forKey: "id")
            entity.setValue(character.name, forKey: "name")
            entity.setValue(character.thumbnailUrl, forKey: "thumbnailUrl")
        }
        do {
            try self.persistentContainer.viewContext.save()
            complete()
        } catch {
            fail()
        }
    }
}
