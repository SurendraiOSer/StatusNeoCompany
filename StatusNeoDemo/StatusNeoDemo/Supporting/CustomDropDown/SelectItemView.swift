

import UIKit

class SelectItemView<T: CustomStringConvertible & Equatable>: UIView, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    typealias ItemType = T
    private var items: [ItemType] = []
    private var selectedItems: [ItemType] = []
    private var allowMultiSelection = false
    var completionHandler: (([ItemType]) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    func setDefault(list: [ItemType], selectedList: [ItemType], multiSelection: Bool = true) {
        items = list
        selectedItems = selectedList
        allowMultiSelection = multiSelection
    }

    func setupUI() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)

        self.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44.0
        tableView.isScrollEnabled = true
        
        tableView.register(UINib(nibName: "SelectListItemViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SelectItemView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func okClicked()
    {
        completionHandler?(selectedItems)

        hide()
    }
    func animate(toogle: Bool) {
                              
               if toogle {
                   UIView.animate(withDuration: 0.3) {
                       self.tableView.isHidden = false
                   }
               } else {
                   UIView.animate(withDuration: 0.3) {
                       self.tableView.isHidden = true
                       self.alpha = 0

                       self.removeFromSuperview()

                   }
               }
           
    }
    

    func showOver(view: UIView, completionHandler: @escaping (([ItemType]) -> Void)) {
        self.completionHandler = completionHandler
        tableView.reloadData()

        view.addSubview(self)

        self.alpha = 0
        UIView.transition(with: self,
             duration: 0.3,
              options: .curveEaseInOut,
           animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    func hide()
    {
        self.alpha = 1
        UIView.transition(with: self, duration: 0.3, options: .curveEaseInOut, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SelectListItemViewCell
        
        let item = items[indexPath.row]
        cell?.labelTitle.text = item.description
        if selectedItems.contains(item)
        {
            //cell?.accessoryType = .checkmark
        }
        
        cell?.labelTitle.textColor = .black
        
        if cell?.imgSelected != nil
        {
            cell?.imgSelected.isHidden = true
        }
        
        cell?.accessoryType = .none
        cell?.labelTitle.textColor = .black
        
        cell?.selectionStyle = .none
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let item = items[indexPath.row]

        if allowMultiSelection
        {
            if selectedItems.contains(item)
            {
                selectedItems.removeAll { (listItem) in
                    listItem == item
                }
            }
            else
            {
                selectedItems.append(item)
            }
        }
        else
        {
            selectedItems.removeAll()
            selectedItems.append(item)
            
            okClicked()
        }
        
//        if CurrentAppTheme != .TajPoker
//        {
//            if let cell = tableView.cellForRow(at: indexPath) as? SelectListItemViewCell
//            {
//                cell.labelTitle.textColor = .white
//                cell.imgSelected.backgroundColor = .gray
//                cell.imgSelected.isHidden = false
//            }
//        }
//        else
//        {
            tableView.reloadRows(at: [indexPath], with: .none)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44.0
    }
}
