//
//  NewsDetailController.swift
//  SentiTable
//
//  Created by 이승용 on 2021/06/21.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var IamgeMain: UIImageView!
    @IBOutlet var LabelMain: UILabel!
    
    // 1. image url
    // 2. desc
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //값이 있다면
        if let img = imageUrl {
            //이미지를 추출한다.
            //Data
            if let data = try? Data(contentsOf: URL(string: img)!) {
                DispatchQueue.main.async {
                    self.IamgeMain.image = UIImage(data: data)
                }
                 //unwrap
            }
        }
        
        if let d = desc {
            //본문을 추출한다.
            self.LabelMain.text = d
        }
    }
    
}
