import UIKit

class TimeLabel: UILabel {
    @IBInspectable var isBorder: Bool = false{
        didSet{
            if isBorder{
                self.layer.borderWidth = 0.5
            }
        }
    }
    @IBInspectable var isSize: Bool = false{
        didSet{
            if isSize{
                self.frame.size.width = (UIScreen.main.bounds.width) / 4
            }
        }
    }

}
