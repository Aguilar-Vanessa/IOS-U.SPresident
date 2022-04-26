//
//  individualPresident.swift
//  U.S Presidents App
//
//  Created by Vanessa Aguilar on 10/28/20.
//  Copyright © 2020 Personal Team. All rights reserved.
//

import Foundation

//Will decode from our character list
class presidentInfo: Decodable{
    
    var name = ""
    var number : Int         
    var startDate = ""
    var endDate = ""
    var nickname = ""
    var politicalParty = ""
    var imageUrlString = ""
   
    private enum CodingKeys: String, CodingKey{
        
        case name = "Name"
        case number = "Number"
        case startDate = "Start Date"
        case endDate = "End Date"
        case nickname = "Nickname"
        case politicalParty = "Political Party"
        case imageUrlString = "URL"
        
    }
    
    init(name:String, number: Int, startDate: String, endDate: String, nickname: String, politicalParty: String, imageUrlString: String = "None"){
        
        self.name = name
        self.number = number
        self.startDate = startDate
        self.endDate = endDate
        self.nickname = nickname
        self.politicalParty = politicalParty
        self.imageUrlString = imageUrlString
        
    }
    
    
}

