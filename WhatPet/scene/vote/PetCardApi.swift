//  WhatPet
//
//  Created by Cristian Spiridon on 14/04/2019.
//  Copyright (c) 2019 Cristian Spiridon. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol VoteAPIProtocol  {
    func newCards(elements:[String], onTop:Bool)
}

enum BreedMode {
    case CAT
    case DOG
}

class PetCardApi
{
    var delegate:VoteAPIProtocol?
    
    let catAPI:String = "https://api.thecatapi.com/v1/images/search?limit={searchLimit}&size=full&sub_id=demo-d7897a"
    let dogAPI:String = "https://api.thedogapi.com/v1/images/search?limit={searchLimit}&size=full&sub_id=demo-91b93d"
    
    var currentAPI:String = ""
    var currentMode:BreedMode = .DOG
    
    func loadCards(searchLimit:Int = 1, onTop:Bool = false, showSpinner:Bool = false) {
        
        if showSpinner { SVProgressHUD.show() }
        
        switch currentMode {
        case .CAT:
            self.currentAPI = self.catAPI
        default:
            self.currentAPI = self.dogAPI
        }
        
        let urlStr = currentAPI.replacingOccurrences(of: "{searchLimit}", with: String(searchLimit))
        guard let url = URL(string:urlStr) else {
            return
        }
        
        loadData(url: url) { (petCardIds) in
            self.delegate?.newCards(elements: petCardIds, onTop: onTop)
            SVProgressHUD.dismiss()
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
