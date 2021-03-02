//
//  MealDBService.swift
//  
//
//  Created by Miguel Angel Olmedo Perez on 02/03/21.
//

import Foundation

enum MealDBService {
    case search(s: String)
    case detail(id: String)
    case random
}
