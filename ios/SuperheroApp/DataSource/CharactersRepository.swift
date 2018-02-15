//
//  CharactersRepository.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 11..
//  Copyright © 2018. W.UP. All rights reserved.
//

import Common

class CharactersRepository: CharactersDataSource {

    private let localDataSource: CharactersDataSource
    private let remoteDataSource: CharactersDataSource

    init(localDataSource: CharactersDataSource, remoteDataSource: CharactersDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func loadCharacters(page: CommonPage, complete: @escaping ([CommonCharacter]) -> Void, fail: @escaping () -> Void) {
        self.localDataSource.loadCharacters(page: page, complete: { (characters: [CommonCharacter]) in
            if characters.isEmpty {
                self.remoteDataSource.loadCharacters(page: page, complete: { (characters) in
                    self.localDataSource.saveCharacters(characters: characters, complete: {}, fail: {})
                    complete(characters)
                }, fail: fail)
            } else {
                complete(characters)
            }
        }, fail: {
            self.remoteDataSource.loadCharacters(page: page, complete: { (characters) in
                self.localDataSource.saveCharacters(characters: characters, complete: {}, fail: {})
                complete(characters)
            }, fail: fail)
        })
    }

    func loadCharacter(characterId: Int32, complete: @escaping (CommonCharacter?) -> Void, fail: @escaping () -> Void) {
        self.localDataSource.loadCharacter(characterId: characterId, complete: { (character) in
            if let character = character {
                complete(character)
            } else {
                self.remoteDataSource.loadCharacter(characterId: characterId, complete: complete, fail: fail)
            }
        }, fail: {
            self.remoteDataSource.loadCharacter(characterId: characterId, complete: complete, fail: fail)
        })
    }

    func saveCharacters(characters: [CommonCharacter], complete: @escaping () -> Void, fail: @escaping () -> Void) {
        self.localDataSource.saveCharacters(characters: characters, complete: {
            self.remoteDataSource.saveCharacters(characters: characters, complete: {}, fail: {})
        }, fail: {
            self.remoteDataSource.saveCharacters(characters: characters, complete: {}, fail: {})
        })
    }

}
