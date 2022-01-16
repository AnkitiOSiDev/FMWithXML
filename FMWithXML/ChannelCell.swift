//
//  ChannelCell.swift
//  FMWithXML
//
//  Created by Ankit on 17/01/22.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
        detailTextLabel?.text = ""
        imageView?.image = UIImage(named: "placeholder")
    }
}
