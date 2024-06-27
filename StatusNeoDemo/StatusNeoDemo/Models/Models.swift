//
//  Models.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import Foundation


struct BreedModel
{
    var title : String = ""
    var orignalKey : String = ""
    
    var subCategory : [BreedSubCategoryModel] = []

    init(key : String, list : [String])
    {
        orignalKey = key
        
        subCategory = list.compactMap{BreedSubCategoryModel(name: $0)}
        title = orignalKey.capitalized
    }
    
    
    static func breedListToModel(list : [String : Any]) -> [BreedModel]
    {
        var mdlList : [BreedModel] = []
        
        let allKeys = list.keys
        for objKey in allKeys
        {
            let list = list[objKey] as? [String] ?? []
            mdlList.append(BreedModel.init(key: objKey, list: list))
        }
        
        return mdlList
    }
}

struct BreedSubCategoryModel
{
    var title : String = ""
    var orignalKey : String = ""
    
    init(name : String)
    {
        orignalKey = name
        title = name.capitalized
    }
}

struct DogByBreedModel
{
    var url : String = ""
    var breedKey : String = ""
    
    init(url: String, breedKey: String)
    {
        self.url = url
        self.breedKey = breedKey
    }
    
    func toDict() -> [String : Any]
    {
        var dict : [String : String] = [:]
        dict["breed"] = self.breedKey
        dict["url"] = self.url
        return dict
    }
    
    static func toModel(dict : [String : Any]) -> DogByBreedModel
    {
        let obj = DogByBreedModel(url: dict["url"] as? String ?? "", breedKey: dict["breed"] as? String ?? "")
        return obj
    }
}
