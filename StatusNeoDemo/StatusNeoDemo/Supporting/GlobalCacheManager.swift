//
//  CacheData.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import Foundation

class GlobalCacheManager
{
    static var shared = GlobalCacheManager()
    private init()
    {
    }
    
    var arrFavList : [DogByBreedModel] = []
    
    func fetchBreedList(handler: @escaping(_ status: Bool, _ msg: String, _ list : [BreedModel]) -> Void) -> [BreedModel]
    {
        WebManager.shared.getListFromServer { status, msg, list in
            
            if !list.isEmpty
            {
                self.breedList = list
                let tmpList = BreedModel.breedListToModel(list: list)
                handler(status, msg, tmpList)
                return
            }
            
            handler(status, msg, [])
        }
        
        let breedList : [BreedModel] = BreedModel.breedListToModel(list: breedList)
        return breedList
    }
    
    var breedList : [String : Any]
    {
        set
        {
            UserDefaults.standard.set(newValue, forKey: "breedList")
            UserDefaults.standard.synchronize()
        }
        get
        {
            if let obj = UserDefaults.standard.object(forKey: "breedList") as? [String : Any]
            {
                return obj
            }
            return [:]
        }
    }
    
    
    func fetchDogByBreed(category: String, handler: @escaping(_ status: Bool, _ msg: String, _ list : [DogByBreedModel]) -> Void)
    {
        WebManager.shared.getListDogsByBreed(category: category, handler: { status, msg, list in
            
            if !list.isEmpty
            {
                var arrList : [DogByBreedModel] = []
                
                list.forEach { url in
                    let obj = DogByBreedModel.init(url: url, breedKey: category)
                    arrList.append(obj)
                }
                
                handler(status, msg, arrList)
                return
            }
            
            handler(status, msg, [])
        })
    }

    func loadFavData()  
    {
        arrFavList = getFavListByBreed()
    }
    
    func isAddRemoveFav(objModel : DogByBreedModel, isForCheck : Bool = false) -> Bool
    {
        var valurExist = false
        if arrFavList.contains(where: { obj in
            obj.url == objModel.url
        })
        {
            valurExist = true
            if !isForCheck
            {
                removeInFavThisDog(objModel: objModel)
            }
        }
        else
        {
            if !isForCheck
            {
                addInFavThisDog(objModel: objModel)
            }
        }
        
        return valurExist
    }
    
    func removeInFavThisDog(objModel : DogByBreedModel)
    {
        if var objList = UserDefaults.standard.object(forKey: "breedFavList") as? [String : Any]
        {
            if var breed = objList[objModel.breedKey] as? [String]
            {
                breed.removeAll { url in
                    url == objModel.url
                }
                
                if breed.isEmpty
                {
                    objList.removeValue(forKey: objModel.breedKey)
                }
                else
                {
                    objList[objModel.breedKey] = breed
                }
            }
            UserDefaults.standard.setValue(objList, forKey: "breedFavList")
            UserDefaults.standard.synchronize()
        }

        loadFavData()
    }
    
    func addInFavThisDog(objModel : DogByBreedModel)
    {
        if var objList = UserDefaults.standard.object(forKey: "breedFavList") as? [String : Any]
        {
            if var breed = objList[objModel.breedKey] as? [String]
            {
                breed.append(objModel.url)
                objList[objModel.breedKey] = breed
            }
            else
            {
                objList[objModel.breedKey] = [objModel.url]
            }
            UserDefaults.standard.setValue(objList, forKey: "breedFavList")
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.standard.setValue(objModel.toDict(), forKey: "breedFavList")
            UserDefaults.standard.synchronize()
        }
        
        loadFavData()
    }
    
    func getFavListByBreed(breedKey : String? = nil) -> [DogByBreedModel]
    {
        var arrFavList : [DogByBreedModel] = []
        
        if let objList = UserDefaults.standard.object(forKey: "breedFavList") as? [String : Any]
        {
            if breedKey != nil
            {
                if let breedList = objList[breedKey!] as? [String]
                {
                    breedList.forEach { url in
                        arrFavList.append(DogByBreedModel.init(url: url, breedKey: breedKey!))
                    }
                }
            }
            else
            {
                let keys = objList.keys
                keys.forEach { keyObj in
                    if let breedList = objList[keyObj] as? [String]
                    {
                        breedList.forEach { url in
                            arrFavList.append(DogByBreedModel.init(url: url, breedKey: keyObj))
                        }
                    }
                }
            }
        }
        
        return arrFavList
    }
}
