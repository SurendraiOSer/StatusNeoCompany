//
//  StoryBoardModal.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 26/06/24.
//

import Foundation
import UIKit

enum SBMain : String
{
    case BreedListVC = "BreedListVC"
    case DogByBreedListVC = "DogByBreedListVC"
    case FavDogByBreedListVC = "FavDogByBreedListVC"
    
    func LoadVC() -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.rawValue)
    }
}
