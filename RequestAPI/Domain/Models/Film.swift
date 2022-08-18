//
//  Film.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation

struct Film {
    let name: String
}

extension Film {
    var filmName: String {
        switch name {
        case "https://swapi.dev/api/films/1/":
            return "Episode IV: A New Hope"
        case "https://swapi.dev/api/films/2/":
            return "Episode V: The Empire Strikes Back"
        case "https://swapi.dev/api/films/3/":
            return "Episode VI: Return Of The Jedi"
        case "https://swapi.dev/api/films/4/":
            return "Episode I: The Phantom Menace"
        case "https://swapi.dev/api/films/5/":
            return "Episode II: Attack Of The Clones"
        case "https://swapi.dev/api/films/6/":
            return "Episode III: Revenge Of The Sith"
        case "https://swapi.dev/api/films/7/":
            return "Episode VII: The Force Awakens"
        case "https://swapi.dev/api/films/8/":
            return "Episode VIII: The Last Jedi"
        case "https://swapi.dev/api/films/9/":
            return "Episode IX: The Rise Of Skywalker"
        default:
            return ""
        }
    }
}
