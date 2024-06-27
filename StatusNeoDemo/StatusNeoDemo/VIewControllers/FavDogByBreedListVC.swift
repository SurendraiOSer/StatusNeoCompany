//
//  ViewController.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import UIKit
//import Kingfisher

class FavDogByBreedListVC: UIViewController
{
    @IBOutlet weak var collDogList : UICollectionView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblEmpty : UILabel!
    
    @IBOutlet weak var viwFilterBreed : SKView!
    @IBOutlet weak var lblFav : UILabel!
    
    var listView: SelectItemView<String>?
    @IBOutlet weak var btnCloseList : UIButton!

    var arrFavDobList : [DogByBreedModel] = []
    var selectedBreed : String = "all"
    
    var parentBreedModel : BreedModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblTitle.text = "Favorite Dogs"
        fecthDataFromLocal()
        self.lblEmpty.text = "No fav dog breed in list."
    }
    
    @IBAction func btnBackClicked(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fecthDataFromLocal(breenName : String? = nil)
    {
        self.arrFavDobList = GlobalCacheManager.shared.getFavListByBreed(breedKey: breenName)
        
        if self.arrFavDobList.isEmpty && breenName != nil, breenName!.lowercased() != "all"
        {
            selectedBreed = "all"
            fecthDataFromLocal()
            return
        }
        lblFav.text = selectedBreed.capitalized
        self.collDogList.reloadData()
    }
    
    @IBAction func selectItemCloseClicked(_ sender : UIButton)
    {
        listView?.hide()
        listView?.removeFromSuperview()
        listView = nil
        btnCloseList.isHidden = true
    }
    
    @IBAction func selectItemClicked(_ sender : UIButton)
    {
        selectItemCloseClicked(sender)
        
        let tmpArr = GlobalCacheManager.shared.arrFavList
        var arrList : [String] = []
        tmpArr.forEach { objModel in
            if !arrList.contains(objModel.breedKey.capitalized)
            {
                arrList.append(objModel.breedKey.capitalized)
            }
        }
        arrList.sort()
        arrList.insert("All", at: 0)

        let n = arrList.count
        let height = ( n > 5 ) ? (5 * 44.0) : (Double(n) * 44.0)
        
        let y = viwFilterBreed.frame.origin.y + viwFilterBreed.bounds.height
        let x = viwFilterBreed.frame.origin.x
        let width = 200.0
        
        listView = SelectItemView<String>(frame: CGRect(x: x, y: y, width: width, height: height))
        
        listView?.setDefault(list: arrList, selectedList: [], multiSelection: false)
        
        listView?.showOver(view: view)
        { [weak self] selected in
            
            let key = selected.first
            
            if key == "All"
            {
                self?.selectedBreed = "all"
                self?.lblFav.text = self?.selectedBreed.capitalized
                self?.fecthDataFromLocal()
            }
            else
            {
                self?.lblFav.text = key
                self?.selectedBreed = key?.lowercased() ?? "all"
                self?.fecthDataFromLocal(breenName: key?.lowercased())
            }
        }
        btnCloseList.isHidden = false
        listView!.dropShadow()
    }
}


extension FavDogByBreedListVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        self.lblEmpty.isHidden = !arrFavDobList.isEmpty
        return arrFavDobList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPetCollection", for: indexPath) as! CellPetCollection
        
        cell.loadUI(objBreed: arrFavDobList[indexPath.row])
        
        cell.selectedFav = 
        {
            self.fecthDataFromLocal(breenName: self.selectedBreed)
            self.collDogList.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let wid = UIScreen.main.bounds.width - 15
        let cellWid = wid/2.0
        
        return CGSize.init(width: wid, height: cellWid)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
    }
}

