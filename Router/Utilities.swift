//
//  Utilities.swift
//  Router
//
//  Created by Menan Vadivel on 2017-07-16.
//  Copyright © 2017 Tinrit Labs Inc. All rights reserved.
//

import Foundation

class Utilities {
    
    static let shared = Utilities()
    
    let defaults = UserDefaults.standard
    
    func markAsFavorites(tag: Int) {
        
        if isFavorite(tag: tag) { return }
        
        var favs = getFavorites()
        favs.append(tag)
        
        defaults.set(favs, forKey: Constants.favoritesKey)
        
    }
    
    func removeFromFavorites(tag: Int){
        
        if !isFavorite(tag: tag) { return }
        
        var favs = getFavorites()
        if let index = favs.index(of: tag){
            favs.remove(at: index)
            defaults.set(favs, forKey: Constants.favoritesKey)
        }
    }
    
    func isFavorite(tag: Int) -> Bool{
        
        let favs = getFavorites()
        
        if favs.count == 0 { return false }
        
        if let index = favs.index(of: tag), index >= 0{
            return true
        }
        
        return false
        
    }
    
    func getFavorites() -> [Int]{
        
        if let favs = defaults.array(forKey: Constants.favoritesKey) as? [Int] {
            return favs
        }
        
        return []
    }
    

}
