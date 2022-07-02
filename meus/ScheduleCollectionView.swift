
import UIKit

class ScheduleCollectionView: UICollectionView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
          self.invalidateIntrinsicContentSize()
        }
      }

      override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
      }
    

}
