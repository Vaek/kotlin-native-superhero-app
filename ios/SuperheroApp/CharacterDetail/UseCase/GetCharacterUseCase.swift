//
//  GetCharacterUseCase.swift
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 12..
//  Copyright © 2018. W.UP. All rights reserved.
//

import Common

class GetCharacterRequest: NSObject, CommonUseCaseRequest {
    let characterId: Int32

    init(characterId: Int32) {
        self.characterId = characterId
    }
}

class GetCharacterResponse: NSObject, CommonUseCaseResponse {
    let character: CommonCharacter?

    init(character: CommonCharacter?) {
        self.character = character
    }
}

class GetCharacterUseCase: CommonUseCase {

    private var charactersDataSource: CommonCharactersDataSource

    init(charactersDataSource: CommonCharactersDataSource) {
        self.charactersDataSource = charactersDataSource
    }

    override func executeUseCase(request: CommonUseCaseRequest) {

        if let request = request as? GetCharacterRequest {

            self.charactersDataSource.loadCharacter(characterId: request.characterId, complete: { (character) in
                let response = GetCharacterResponse(character: character)
                return self.success(response)
            }, fail: {
                return self.error()
            })
        }
    }
}
