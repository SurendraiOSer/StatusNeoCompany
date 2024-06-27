//
//  CustomCells.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import Foundation
import UIKit

class CellSectionTable: UITableViewCell
{
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var btnArrow : UIButton!
    
    @IBOutlet var btnArrowRight : UIButton!
    @IBOutlet var imgArrowRight : UIImageView!

    @IBOutlet var imgSep : UIImageView!

    var selectedBreedForSubCat : ( ) -> Void = {}

    func loadUI(objModel : BreedModel, isSeleced : Bool)
    {
        var titleStr = objModel.title
        
        
        btnArrow.isSelected = isSeleced
        btnArrowRight.isSelected = isSeleced
        
        imgSep.isHidden = false

        if objModel.subCategory.isEmpty
        {
            lblTitle.text = titleStr
            btnArrowRight.isHidden = true
            imgArrowRight.isHidden = false
        }
        else
        {
            titleStr = titleStr + " [\(objModel.subCategory.count)]"
            lblTitle.text = titleStr

            btnArrowRight.isHidden = false
            imgArrowRight.isHidden = true
            
            if isSeleced
            {
                imgSep.isHidden = true
            }
        }
        
    }
    
    @IBAction func btnClicked(_ sender : UIButton)
    {
        selectedBreedForSubCat()
    }
}

class CellTable: UITableViewCell
{
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var imgSep : UIImageView!

}


class CellPetCollection: UICollectionViewCell
{
    @IBOutlet var imgPet : UIImageView!
    @IBOutlet var btnFav : UIButton!
    @IBOutlet var loading : UIActivityIndicatorView!
    
    var selectedFav : ( ) -> Void = {}
    var objModel : DogByBreedModel!
    
    func loadUI(objBreed : DogByBreedModel)
    {
        objModel = objBreed
        
        loading.startAnimating()
        btnFav.isHidden = true
        
        btnFav.isSelected = GlobalCacheManager.shared.isAddRemoveFav(objModel: objModel, isForCheck: true)
        
        imgPet.kf.setImage(with: URL.init(string: objModel.url), placeholder: nil, options: [])
        { (resutl) in
            self.loading.stopAnimating()
            self.btnFav.isHidden = false
        }
    }
    
    @IBAction func btnFavClicked(_ sender : UIButton)
    {
        _ = GlobalCacheManager.shared.isAddRemoveFav(objModel: objModel, isForCheck: false)
        selectedFav()
    }
}
