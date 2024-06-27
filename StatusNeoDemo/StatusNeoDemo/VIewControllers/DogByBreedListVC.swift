//
//  ViewController.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import UIKit
//import Kingfisher

class DogByBreedListVC: UIViewController
{
    @IBOutlet weak var collDogList : UICollectionView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblEmpty : UILabel!
    
    var arrDobList : [DogByBreedModel] = []
    
    var parentBreedModel : BreedModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GlobalCacheManager.shared.loadFavData()
        
        lblTitle.text = parentBreedModel.title
        lblEmpty.text = "Loading..."
        
        let catName = parentBreedModel.orignalKey
//        if !parentBreedModel.subCategory.isEmpty
//        {
//            catName = catName + "-" +  parentBreedModel.subCategory.first!.orignalKey
//        }
        
        GlobalCacheManager.shared.fetchDogByBreed(category: catName) { status, msg, list in
            self.arrDobList = list
            self.lblEmpty.text = msg

            self.collDogList.reloadData()
        }
    }
    
    @IBAction func btnBackClicked(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}


extension DogByBreedListVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        self.lblEmpty.isHidden = !arrDobList.isEmpty
        return arrDobList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPetCollection", for: indexPath) as! CellPetCollection
        
        cell.loadUI(objBreed: arrDobList[indexPath.row])
        
        cell.selectedFav = 
        {
            self.collDogList.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let wid = UIScreen.main.bounds.width
        let cellWid = wid/2.0
        
        return CGSize.init(width: wid, height: cellWid)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
    }
}

