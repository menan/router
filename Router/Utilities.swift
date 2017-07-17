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
    
    enum Kind {
        case route
        case stop
    }
    
    func markAsFavorite(tag: Int,ofKind kind: Kind) {
        
        if isFavorite(tag: tag, ofKind: kind) { return }
        
        var favs = getFavorites(ofKind: kind)
        favs.append(tag)
        
        saveFavourites(values: favs, ofKind: kind)
    }
    
    func removeFromFavorites(tag: Int,ofKind kind: Kind){
        
        if !isFavorite(tag: tag, ofKind: kind) { return }
        
        var favs = getFavorites(ofKind: kind)
        if let index = favs.index(of: tag){
            favs.remove(at: index)
            
            saveFavourites(values: favs, ofKind: kind)
        }
    }
    
    func isFavorite(tag: Int,ofKind kind: Kind) -> Bool{
        
        let favs = getFavorites(ofKind: kind)
        
        if favs.count == 0 { return false }
        
        if let index = favs.index(of: tag), index >= 0{
            return true
        }
        return false
    }
    
    func getFavorites(ofKind kind: Kind) -> [Int]{
        let key = kind == .stop ? Constants.favoriteStopsKey : Constants.favoriteRoutesKey
        
        if let favs = defaults.array(forKey: key) as? [Int] {
            return favs
        }
        return []
    }
    
    func saveFavourites(values: [Int], ofKind kind: Kind){
        let key = kind == .stop ? Constants.favoriteStopsKey : Constants.favoriteRoutesKey
        defaults.set(values, forKey: key)
    }
    
}
