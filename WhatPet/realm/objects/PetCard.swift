//
//  VoteCard.swift
//  WhatPet
//
//  Created by Cristian Spiridon on 15/04/2019.
//  Copyright © 2019 Cristian Spiridon. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


@objcMembers
class PetCard:Object, Decodable {
    
    dynamic var id:String = ""
    dynamic var url:String = ""
    var breedsList = List<Breeds>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum VoteCodingKeys: String, CodingKey {
        case id
        case url
        case breedsList = "breeds"
    }
    
    convenience required init(from decoder: Decoder) throws {
        
        self.init()
        
        let container = try decoder.container(keyedBy: VoteCodingKeys.self)
        
        id        = try container.decode(String.self, forKey: .id)
        url       = try container.decode(String.self, forKey: .url)
        
        let breeds = try container.decodeIfPresent([Breeds].self, forKey: .breedsList) ?? [Breeds()]
        breedsList.append(objectsIn: breeds)
        
    }

}

@objcMembers
class Breeds:Object, Decodable {
    dynamic var id:Int = 0
    dynamic var name:String?
    dynamic var bred_for:String?
    dynamic var life_span:String?
    dynamic var temperament:String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case bred_for
        case life_span
        case temperament
    }
}
