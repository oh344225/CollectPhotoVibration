//
//  DetailPhotoViewController.swift
//  PhotoBiberation201802
//
//  Created by oshitahayato on 2018/10/19.
//  Copyright © 2018年 oshitahayato. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {

	//写真詳細
	@IBOutlet weak var DetailImage: UIImageView!
	var selectImg: UIImage!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		DetailImage.image = selectImg
		// 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
		DetailImage.contentMode = UIViewContentMode.scaleAspectFit
	
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
