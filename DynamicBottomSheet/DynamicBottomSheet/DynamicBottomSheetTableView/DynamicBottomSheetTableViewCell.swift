//
//  DynamicBottomSheetTableViewCell.swift
//  DynamicBottomSheet
//
//  Created by Oğuz Canbaz on 31.05.2024.
//

import UIKit
import SnapKit

class DynamicBottomSheetTableViewCell: UITableViewCell {
    
    // MARK: -- Components
    
    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: -- Life Cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupview()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupview()
        
    }
    
    // MARK: -- Functions
    
    func setupview(){
        contentView.addSubview(label)
        setupLayout()
    }
    
    func setupLayout(){
        label.snp.makeConstraints({lbl in
            lbl.centerY.equalToSuperview()
            lbl.leading.equalToSuperview().offset(30)
        })
    }
}
