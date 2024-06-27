//
//  WebServices.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import Foundation

class WebManager
{
    static var shared = WebManager()
    private init()
    {
    }
    
    func getListFromServer(handler: @escaping(_ status: Bool, _ msg: String, _ list : [String : Any]) -> Void)
    {
        let urlReq = URLRequest(url: URL(string: EndPoints.allCategories)!)
        
        URLSession.shared.dataTask(with: urlReq) { data, urlRes, err in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                
                var arrList : [String : Any] = [:]
                if let list = json["message"] as? [String : Any]
                {
                    arrList = list
                }
                DispatchQueue.main.async
                {
                    handler(true, "", arrList)
                }
            }
            catch
            {
                print(error.localizedDescription)
                DispatchQueue.main.async
                {
                    handler(false, "Receving invalid data.", [:])
                }
            }
        }.resume()
    }
    
    func getListDogsByBreed(category : String, handler: @escaping(_ status: Bool, _ msg: String, _ list : [String]) -> Void)
    {
        var apiPath = EndPoints.allImagesByBreed
        apiPath = apiPath.replacingOccurrences(of: "<name>", with: category)
        let urlReq = URLRequest(url: URL(string: apiPath)!)
        
        URLSession.shared.dataTask(with: urlReq) { data, urlRes, err in
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                
                var arrList : [String] = []
                if let list = json["message"] as? [String]
                {
                    arrList = list
                }
                DispatchQueue.main.async
                {
                    handler(true, "", arrList)
                }
            }
            catch
            {
                print(error.localizedDescription)
                DispatchQueue.main.async
                {
                    handler(false, "Receving invalid data.", [])
                }
            }
        }.resume()
    }
}
