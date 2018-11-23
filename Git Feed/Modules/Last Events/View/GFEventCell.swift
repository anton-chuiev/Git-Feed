//
//  GFEventCell.swift
//  Git Feed
//
//  Created by Anton Chuev on 11/12/18.
//  Copyright © 2018 Anton Chuiev. All rights reserved.
//

import RxSwift
import Kingfisher

class GFEventCell: GFBaseTableViewCell {
    override func configure(with viewModel: GFBaseCellViewModel) {
        guard let viewModel = viewModel as? GFEventCellViewModel else {
            return
        }
        
        textLabel?.text = viewModel.eventTitle
        detailTextLabel?.text = viewModel.eventDescription
        imageView?.kf.setImage(with: viewModel.eventImageURL,
                               placeholder: UIImage(named: "blank-avatar"))
    }
}
