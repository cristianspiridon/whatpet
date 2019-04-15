//  WhatPet
//
//  Created by Cristian Spiridon on 14/04/2019.
//  Copyright (c) 2019 Cristian Spiridon. All rights reserved.
//

import UIKit

protocol VoteAPIProtocol  {
    func newCards(elements:[String], onTop:Bool)
}

class PetCardApi
{
    var delegate:VoteAPIProtocol?
    
    func loadCards(searchLimit:Int = 1, onTop:Bool = false) {

        guard let url = URL(string:"https://api.thedogapi.com/v1/images/search?limit=\(searchLimit)&size=full&sub_id=demo-91b93d") else {
            return
        }
        
        loadData(url: url) { (petCardIds) in
            self.delegate?.newCards(elements: petCardIds, onTop: onTop)
        }
    }
    
    func loadData(url:URL, completed: @escaping ([String]) -> ()) {
     
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error == nil {
                do {

                    let cards = try JSONDecoder().decode([PetCard].self, from: data!)
                    realm.addTempPetCards(cards)
                    
                    let ids:[String] = cards.map({"\(($0).id)"})
                    
                    DispatchQueue.main.async {
                        completed(ids)
                    }
                } catch {
                    print("JSON Error: Data")
                }
            }
            }.resume()
        
    }
  
}
