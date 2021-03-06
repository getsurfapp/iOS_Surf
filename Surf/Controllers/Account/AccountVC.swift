//
//  AccountVC.swift
//  Surf
//
//  Created by Liming on 30/11/2017.
//  Copyright © 2017 surf. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import SDWebImage

class AccountVC: ButtonBarPagerTabStripViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {

    @IBOutlet weak var barView: ButtonBarView!
    @IBOutlet weak var contentsView: UIScrollView!
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var photoBackImg: UIImageView!
    @IBOutlet weak var fnameLbl: UILabel!
    @IBOutlet weak var lnameLbl: UILabel!
    
    var isReload = false
    
    override func viewDidLoad() {
   
        self.settings.style.buttonBarHeight = 30
        self.settings.style.buttonBarTop = 236
        self.settings.style.selectedBarHeight = 3
        self.settings.style.selectedBarBackgroundColor = UIColor.white
        self.settings.style.buttonBarBackgroundColor = UIColor.clear
        self.settings.style.buttonBarItemBackgroundColor = UIColor.clear
        self.settings.style.buttonBarMinimumInteritemSpacing = 0
        self.settings.style.buttonBarItemTitleColor = UIColor.white
        self.settings.style.buttonBarItemFont = UIFont.init(name: "Brandon Grotesque", size: 8)!
        
        super.viewDidLoad()
        
        self.buttonBarView.backgroundColor = UIColor.clear
        
        self.fillUser(with: Auth.auth().currentUser!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillUser(with user: User) {
        self.photoImg.sd_setImage(with: user.photoURL, completed: nil)
        self.photoBackImg.sd_setImage(with: user.photoURL, completed: nil)
        
        let nameArray = user.displayName?.components(separatedBy: " ")
        
        self.fnameLbl.text = nameArray![0].uppercased()
        self.lnameLbl.text = nameArray![1].uppercased()
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC")
        searchVC?.modalPresentationStyle = .overCurrentContext
        self.present(searchVC!, animated: true, completion: nil)
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_0 = self.storyboard?.instantiateViewController(withIdentifier: "MyMediaVC")
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "MyChannelsVC")
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC")
        
        guard isReload else {
            return [child_0!, child_1!, child_2!]
        }
        
        var childViewControllers = [child_0, child_1, child_2]
        
        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childViewControllers.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems))) as! [UIViewController]
    }
    
    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }
    
    @IBAction func editPhotoAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //save image
            //display image
            self.photoImg.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
