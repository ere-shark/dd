//
//  ViewController.swift
//  mddy
//
//  Created by 스마트컨텐츠 on 2025/05/13.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var listbutton: UIButton!
    @IBOutlet var maintext: UILabel!
    @IBOutlet var dywrbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
                red: 1.00,
                green: 0.90,
                blue: 0.84,
                alpha: 1.0
            ) // #FFE5D4
        
        styleButtons()
        // Do any additional setup after loading the view.
        
        dywrbutton.setTitle("오늘의 일기\n쓰러가기", for: .normal)
        dywrbutton.titleLabel?.textAlignment = .center
        
        listbutton.setTitle("추억\n되세기기", for: .normal)
        listbutton.titleLabel?.textAlignment = .center
        
    }
    
    private func styleButtons() {
            // writeButton 스타일
        dywrbutton.backgroundColor = UIColor(red: 1.00, green: 0.43, blue: 0.38, alpha: 1.0) // #FF6E62
        dywrbutton.setTitleColor(.white, for: .normal)
        dywrbutton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        dywrbutton.layer.cornerRadius = 12
        dywrbutton.layer.shadowColor = UIColor.black.cgColor
        dywrbutton.layer.shadowOpacity = 0.2
        dywrbutton.layer.shadowOffset = CGSize(width: 0, height: 2)
        dywrbutton.layer.shadowRadius = 4

            // listButton 스타일
        listbutton.backgroundColor = UIColor(red: 0.38, green: 0.78, blue: 0.96, alpha: 1.0) // #61C7F5
        listbutton.setTitleColor(.white, for: .normal)
        listbutton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        listbutton.layer.cornerRadius = 12
        listbutton.layer.shadowColor = UIColor.black.cgColor
        listbutton.layer.shadowOpacity = 0.2
        listbutton.layer.shadowOffset = CGSize(width: 0, height: 2)
        listbutton.layer.shadowRadius = 4
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentTodywr" {
            if let destination = segue.destination as? DyWrController {
                destination.modalPresentationStyle = .fullScreen
            }
        } 
    }
    
    @IBAction func gowrdybutton(_ sender: UIButton) {
        performSegue(withIdentifier: "presentTodywr", sender: self)
    }
    
    
    @IBAction func listbuttontapped(_ sender: UIButton) {
    }
}
