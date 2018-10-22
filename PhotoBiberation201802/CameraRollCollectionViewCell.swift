//
//  CameraRollCollectionViewCell.swift
//  PhotoBiberation201802
//
//  Created by oshitahayato on 2018/01/24.
//  Copyright © 2018年 oshitahayato. All rights reserved.
//

import UIKit
import Photos

class CameraRollCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var photoImage: UIImageView!
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	
	
	// 画像を表示する,描画
	func setConfigure(assets: PHAsset) {
		let manager = PHImageManager()
		
		manager.requestImage(for: assets,
							 targetSize: frame.size,
							 contentMode: .aspectFit,
							 options: nil,
							 resultHandler: { [weak self] (image, info) in
								guard let wself = self, let outImage = image else {
									return
								}
								wself.photoImage.image = image
								//print(image)
		})
	}
	
	
    
}
