
import UIKit

class SelectListItemViewCell: UITableViewCell
{
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgSelected: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
