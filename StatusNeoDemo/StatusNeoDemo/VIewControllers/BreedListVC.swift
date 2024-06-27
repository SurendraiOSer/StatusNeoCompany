//
//  ViewController.swift
//  StatusNeoDemo
//
//  Created by Surendra Sharma on 25/06/24.
//

import UIKit

class BreedListVC: UIViewController
{
    @IBOutlet weak var tblBreedList : UITableView!

    @IBOutlet weak var btnCloseList : UIButton!
    @IBOutlet weak var viwSortBreed : SKView!
    var listView: SelectItemView<String>?
    
    var arrBreedCategory : [BreedModel] = []
    var selectedBreed : Int = -1
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        arrBreedCategory = GlobalCacheManager.shared.fetchBreedList { status, msg, list in
            print("List ",list.count)
            
            self.arrBreedCategory = list
            self.updateList(sortAtoZ: true)
        }
        
        updateList(sortAtoZ: true)
    }
    
    func updateList(sortAtoZ : Bool)
    {
        if  sortAtoZ
        {
            arrBreedCategory.sort { obj1, obj2 in
                return obj1.orignalKey < obj2.orignalKey
            }
        }
        else
        {
            arrBreedCategory.sort { obj1, obj2 in
                return obj1.orignalKey > obj2.orignalKey
            }
        }
        self.tblBreedList.reloadData()

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
        
        var arrList : [String] = []
        arrList.append("A to Z")
        arrList.append("Z to A")
        
        let n = arrList.count
        let height = ( n > 5 ) ? (5 * 44.0) : (Double(n) * 44.0)
        
        let y = viwSortBreed.frame.origin.y + viwSortBreed.bounds.height
        let x = viwSortBreed.frame.origin.x
        let width = 150.0
        
        listView = SelectItemView<String>(frame: CGRect(x: x, y: y, width: width, height: height))
        
        listView?.setDefault(list: arrList, selectedList: [], multiSelection: false)
        
        listView?.showOver(view: view)
        { [weak self] selected in
            
            let key = selected.first
            
            if key == "A to Z"
            {
                self?.updateList(sortAtoZ: true)
            }
            else
            {
                self?.updateList(sortAtoZ: false)
            }
        }
        btnCloseList.isHidden = false
        listView!.dropShadow()
    }
}


// MARK: Extension
extension BreedListVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrBreedCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let objBreed = arrBreedCategory[section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSectionTable") as! CellSectionTable
        
        cell.loadUI(objModel: objBreed, isSeleced: self.selectedBreed == section)
        
        cell.selectedBreedForSubCat =
        {
            if self.arrBreedCategory[section].subCategory.isEmpty
            {
                self.navigateOnDogByBreedScreen(objBreed: self.arrBreedCategory[section])
                return
            }
            if self.selectedBreed == section
            {
                self.selectedBreed = -1
            }
            else
            {
                self.selectedBreed = section
            }
            self.tblBreedList.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.selectedBreed == section
        {
            return arrBreedCategory[section].subCategory.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTable") as! CellTable
        
        let objModel = arrBreedCategory[indexPath.section]
        let title = objModel.subCategory[indexPath.row].title
        
        cell.lblTitle.text = title
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.navigateOnDogByBreedScreen(objBreed: arrBreedCategory[indexPath.section])
    }
    
    func navigateOnDogByBreedScreen(objBreed : BreedModel)
    {
        let vc = SBMain.DogByBreedListVC.LoadVC() as! DogByBreedListVC
        vc.parentBreedModel = objBreed
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func navigateOnFavDogByBreedScreen(_ sender : UIButton)
    {
        let vc = SBMain.FavDogByBreedListVC.LoadVC() as! FavDogByBreedListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
