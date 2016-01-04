//
//  Cells.swift
//  Test
//
//  Created by Sergey Kolupaev on 12/29/15.
//  Copyright © 2015 Sergey Kolupaev. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {
    @IBOutlet weak var label : UILabel?
}

class ViewCell: LabelCell {
    @IBOutlet weak var textView : UITextView?
}