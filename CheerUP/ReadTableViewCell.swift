//
//  ReadTableViewCell.swift
//  CheerUP
//
//  Created by 박수연 on 11/6/24.
//

import UIKit

class ReadTableViewCell: UITableViewCell {

    @IBOutlet weak var diary: UILabel!
    var addMoreClickedHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    
}
