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
	var selectedImage: UIImage?

	
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
		
	}
	
}

extension ViewController :UICollectionViewDataSource{
	
	//
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
		//選択された画像の詳細
		performSegue(withIdentifier: "DetailPhotoViewController", sender: nil)
		print("select")
		print(indexPath.row)
		print(photoAssets[indexPath.row])
		
	}
	
	
	
}

