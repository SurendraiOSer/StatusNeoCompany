//
//  EndPoints.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import Foundation

let BasePath = "https://dog.ceo/api/"

struct EndPoints
{
    //https://dog.ceo/api/breeds/list/all
    static let allCategories  = BasePath + "breeds/list/all"
    
    //https://dog.ceo/api/breed/hound
    static let allImagesByBreed  = BasePath + "breed/<name>/images"
}
