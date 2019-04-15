import Foundation
import RealmSwift

class RealmService {

    private init() {}
    static let shared = RealmService()

    var userProvider = RealmProvider.user

    
    func addTempPetCards(_ cards:[PetCard]) {
        
        for card in cards {
            userProvider.create(card)
        }
    }
    
    func getCardBy(_ id:String) -> PetCard? {
        
        let card = userProvider.realm.objects(PetCard.self).first { (card) -> Bool in
            card.id == id
        }
        
        return card
    }
    
    func deleteAll() {
        userProvider.deleteAll()
    }

}
