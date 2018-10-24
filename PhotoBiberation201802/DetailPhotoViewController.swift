//
//  DetailPhotoViewController.swift
//  PhotoBiberation201802
//
//  Created by oshitahayato on 2018/10/19.
//  Copyright © 2018年 oshitahayato. All rights reserved.
//

import UIKit
import Photos

class DetailPhotoViewController: UIViewController {

	//写真詳細
	@IBOutlet weak var DetailImage: UIImageView!
	//写真情報
	var PHAsset : PHAsset!
	//写真画像情報
	var selectImg: UIImage!
	
	//写真メタデータ引き継ぎ
	var photoheartrate :Double?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		getImageData(photoAsset: PHAsset)
		getExifData(photoAsset: PHAsset,exifCompletionHandler: {(text) -> Void in
			//text -> double変換
			if(text == nil){
				self.photoheartrate = nil
				print(text as Any)
				print(self.photoheartrate as Any)
			}else{
				// if, guard などを使って切り分ける
				if let p = Double(text!){
					self.photoheartrate = p
					print(p)
					print(self.photoheartrate as Any)
				}
			}
		})
        // Do any additional setup after loading the view.
		DetailImage.image = selectImg
		// 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
		DetailImage.contentMode = UIViewContentMode.scaleAspectFit
		//心拍表示
		print("Detailmetadata: \(self.photoheartrate as Any)")
		//
		//print(PHAsset)
	
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension DetailPhotoViewController: UICollectionViewDelegate{
	
	func getImageData(photoAsset:PHAsset){
		//画像データ取得
		//画像オブジェクト取得
		let manager = PHImageManager()
		//取得オプション
		let option = PHImageRequestOptions()
		//highquality高画質の状態を１回で引き渡す
		option.deliveryMode = .highQualityFormat
		//同期処理にする、バックグラウンド処理をやめる
		option.isSynchronous = true
		manager.requestImage(for: photoAsset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFill, options: option){(image,info) in
			//imageにUIImageが渡ってくる。
			//print(image!)
			self.selectImg = image
			print(self.selectImg as Any)
		}
	}
	
	//exif情報取得関数,非同期処理にして参照実行時の不具合なくす。
	func getExifData(photoAsset:PHAsset,exifCompletionHandler: @escaping (_ text:String?) -> Void){
		//exif情報取得
		let editOptions = PHContentEditingInputRequestOptions()
		editOptions.isNetworkAccessAllowed = true
		
		photoAsset.requestContentEditingInput(with: editOptions, completionHandler: {(contentEditingInput, _) -> Void in
			
			let url = contentEditingInput?.fullSizeImageURL
			//画像nilの条件処理
			if let inputImage:CIImage = CoreImage.CIImage(contentsOf: url!){
				//print("画像:\(inputImage)")
				let meta:NSDictionary? = inputImage.properties as NSDictionary?
				//print("exif:\(meta?["{Exif}"] as? NSDictionary)")
				let exif:NSDictionary? = meta?["{Exif}"] as? NSDictionary
				let text = exif?.object(forKey: kCGImagePropertyExifUserComment) as! String?
				exifCompletionHandler(text)
			}
		})
	}
	
}
