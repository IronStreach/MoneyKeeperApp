import UIKit

class CustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var summLabel: UILabel!
        var priority: Int32 = 0
}
