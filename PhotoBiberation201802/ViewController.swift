//
//  ViewController.swift
//  PhotoBiberation201802
//
//  Created by oshitahayato on 2018/01/23.
//  Copyright © 2018年 oshitahayato. All rights reserved.
//


//ライブラリインポート
import UIKit
import Photos


class ViewController: UIViewController {

	//UI collectionView　写真表示
	@IBOutlet weak var collectionView: UICollectionView!
	
	var photoAssets: Array! = [PHAsset]()
	
	//選択画像
	var selectImage:UIImage?
	var PhotoDATA :PHAsset?
	//選択画像の心拍数
	///var heartrate:Double?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		//collectionView写真セル数をセットアップ
		setup()
		//カメラロールへのアクセス申請、許可
		libraryRequestAuthorization()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	//写真配置のセットアップ
	fileprivate func setup() {
		collectionView.dataSource = self as UICollectionViewDataSource
		
		// UICollectionViewCellのマージン等の設定
		let flowLayout: UICollectionViewFlowLayout! = UICollectionViewFlowLayout()
		flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 4,
									 height: UIScreen.main.bounds.width / 3 - 4)
		flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
		flowLayout.minimumInteritemSpacing = 0
		flowLayout.minimumLineSpacing = 6
		
		collectionView.collectionViewLayout = flowLayout
	}
	
	//カメラロールへのアクセス申請、許可
	fileprivate func libraryRequestAuthorization() {
		PHPhotoLibrary.requestAuthorization({ [weak self] status in
			guard let wself = self else {
				return
			}
			switch status {
			case .authorized:
				wself.getAllPhotosInfo()
			case .denied:
				wself.showDeniedAlert()
			case .notDetermined:
				print("NotDetermined")
			case .restricted:
				print("Restricted")
			}
		})
	}
	
	// カメラロールから全て取得する
	fileprivate func getAllPhotosInfo() {
		//ソート条件を指定(新しい順）
		let new = PHFetchOptions()
		new.sortDescriptors = [
			NSSortDescriptor(key: "creationDate", ascending: false)
		]
		/////////////////////////
		let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: new)
		assets.enumerateObjects({ [weak self] (asset, index, stop) -> Void in
			guard let wself = self else {
				return
			}
			wself.photoAssets.append(asset as PHAsset)
		})
		collectionView.reloadData()
		//print("写真は\(assets.count)")
	}
	
	
	
	//カメラロールで拒否されたときのアラート処理
	fileprivate func showDeniedAlert() {
		let alert: UIAlertController = UIAlertController(title: "エラー",
														 message: "「写真」へのアクセスが拒否されています。設定より変更してください。",
														 preferredStyle: .alert)
		let cancel: UIAlertAction = UIAlertAction(title: "キャンセル",
												  style: .cancel,
												  handler: nil)
		let ok: UIAlertAction = UIAlertAction(title: "設定画面へ",
											  style: .default,
											  handler: { [weak self] (action) -> Void in
												guard let wself = self else {
													return
												}
												wself.transitionToSettingsApplition()
		})
		alert.addAction(cancel)
		alert.addAction(ok)
		present(alert, animated: true, completion: nil)
	}
	
	//アプリケーションで設定画面へ遷移するための処理
	fileprivate func transitionToSettingsApplition() {
		let url = URL(string: UIApplicationOpenSettingsURLString)
		if let url = url {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	/*
	//cellが選択された場合
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	//セグエを実行する。
	//performSegue(withIdentifier: "result", sender: nil)
	print("selected")
	}
	*/
	// Segue 準備
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "DetailPhotoViewController"){
			let SubView: DetailPhotoViewController = (segue.destination as? DetailPhotoViewController)!
			//DetailviewcontrollerにselectImg,heartrateデータを受け渡し
			SubView.PHAsset = PhotoDATA
			//SubView.selectImg = selectImage
			//SubView.photoheartrate = heartrate
		}
		
	}
	
	/// Storyboadでunwind sequeを引くために必要,記述この処理へ戻ってくる。
	@IBAction func unwindToFirstView(segue: UIStoryboardSegue) {
		//print("back")
	}

	
	
	
	
}

extension ViewController :UICollectionViewDataSource{
	
	//cellの総数カウントして準備
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		//print("photoAssets:\(photoAssets.count)")
		return photoAssets.count
	}
	
	//Cellの設定、描画
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CameraRollCollectionViewCell
		cell.setConfigure(assets: photoAssets[indexPath.row])
		//print("cell:\(cell)")
		return cell
	}
	
}

extension ViewController: UICollectionViewDelegate{
	
	//セルが選択されたとき
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("select")
		print(indexPath.row)
		//print(photoAssets[indexPath.row])
		PhotoDATA = photoAssets[indexPath.row]
		
		//画像データ取得処理
		//getImageData(photoAsset: photoAssets[indexPath.row])
		/*
		///////////////////////////////////
		//画像データ取得
		//画像オブジェクト取得
		let manager = PHImageManager()
		//取得オプション
		let option = PHImageRequestOptions()
		//highquality高画質の状態を１回で引き渡す
		option.deliveryMode = .highQualityFormat
		//同期処理にする、バックグラウンド処理をやめる
		option.isSynchronous = true
		manager.requestImage(for: photoAssets[indexPath.row], targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFill, options: option){(image,info) in
			//imageにUIImageが渡ってくる。
			//print(image!)
			self.selectImage = image
			print(self.selectImage as Any)
		}
		///////////////////////////////////
		*/
		/*
		//exif取得処理
		getExifData(photoAsset: photoAssets[indexPath.row],exifCompletionHandler: {(text) -> Void in
			//text -> double変換
			if(text == nil){
				print(text as Any)
				//self.heartrate = nil
			}else{
				// if, guard などを使って切り分ける
				if let p = Double(text!){
					print(p)
					//self.heartrate = p
				}
			}
		})
		*/
		/*
		///////////////////////////////////
		//exif情報取得
		let editOptions = PHContentEditingInputRequestOptions()
		editOptions.isNetworkAccessAllowed = true
		photoAssets[indexPath.row].requestContentEditingInput(with: editOptions, completionHandler: {(contentEditingInput, _) -> Void in
			
			let url = contentEditingInput?.fullSizeImageURL
			//画像nilの条件処理
			if let inputImage:CIImage = CoreImage.CIImage(contentsOf: url!){
				//print("画像:\(inputImage)")
				let meta:NSDictionary? = inputImage.properties as NSDictionary?
				//print("exif:\(meta?["{Exif}"] as? NSDictionary)")
				let exif:NSDictionary? = meta?["{Exif}"] as? NSDictionary
				let text = exif?.object(forKey: kCGImagePropertyExifUserComment) as! String?
				//print(text)
				//text -> double変換
				if(text == nil){
					//print(text as Any)
					self.heartrate = nil
				}else{
					// if, guard などを使って切り分ける
					if let p = Double(text!){
						//print(p)
						self.heartrate = p
					}
				}
			}
		})
		///////////////////////////////////
		*/
		
		//if 画像が取得できたら画像詳細画面へ遷移(画像のurl情報を引き継ぎ）
		if PhotoDATA != nil{
			//print("if")
			//選択された画像の詳細
			performSegue(withIdentifier: "DetailPhotoViewController", sender: nil)
		}
		//print(self.selectImage)
	}
	
	/*
	//画像データ取得関数
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
			self.selectImage = image
			print(self.selectImage as Any)
		}
	}
	*/
	/*
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
				/*
				//print(text)
				//text -> double変換
				if(text == nil){
					//print(text as Any)
					self.heartrate = nil
				}else{
					// if, guard などを使って切り分ける
					if let p = Double(text!){
						//print(p)
						self.heartrate = p
					}
				}
				*/
			}
		})
	}
	*/
	
	
	
}

