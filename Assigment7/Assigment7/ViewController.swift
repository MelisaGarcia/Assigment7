//
//  ViewController.swift
//  Assigment7
//
//  Created by Andrea Dancek on 2020-05-23.
//  Copyright © 2020 Melisa Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IB outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func actionToggleMenu(_ sender: AnyObject) {
        
        isMenuOpen = !isMenuOpen
        menuHeightConstraint.constant = isMenuOpen ? 200.0 : 88.0
        titleLabel.text = isMenuOpen ? "Add a Snack" : "Snacks"
        
        titleLabel.superview?.constraints.forEach({ constraint in
//            print(" -> \(constraint.description)\n")
            if constraint.firstItem === titleLabel && constraint.firstAttribute == .centerX {
                constraint.constant = isMenuOpen ? -100 : 0.0
                return
            }
            if constraint.identifier == "TitleCenterY" {
                constraint.isActive = false
                // add new constraint
                let newConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .centerY, relatedBy: .equal, toItem: titleLabel.superview!, attribute: .centerY, multiplier: isMenuOpen ? 0.67 : 1.0, constant: 5.0)
                newConstraint.identifier = "TitleCenterY"
                newConstraint.isActive = true
                return
            }
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            let angle: CGFloat = self.isMenuOpen ? CGFloat.pi / 4 : 0.0
            self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
        }, completion: nil)
        
        if isMenuOpen {
            slider = HorizontalItemList(inView: view)
            slider.didSelectItem = { index in
                print("add \(index)")
                self.items.append(index)
                self.tableView.reloadData()
                self.actionToggleMenu(self)
            }
            self.titleLabel.superview?.addSubview(slider)
        } else {
            slider.removeFromSuperview()
        }
    }
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    // MARK: further class variables
    
    var slider: HorizontalItemList!
    var isMenuOpen = false
    var items: [Int] = []
    let itemTitles = ["oreos", "pizza pockets", "pop tarts", "popsicle", "ramen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
    }
    
    func showItem(_ index: Int) {
//        print("tapped item \(index)")
        let imageView = UIImageView(image: UIImage(named: "Snack_0\(index).png"))
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let conX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let conBottom = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
        let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
        let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        
        NSLayoutConstraint.activate([conX, conBottom, conWidth, conHeight])
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            conBottom.constant = -imageView.frame.size.height / 2
            conWidth.constant = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: [], animations: {
            conBottom.constant = imageView.frame.size.height
            conWidth.constant = -50.0
            self.view.layoutIfNeeded()
        }) { _ in
            imageView.removeFromSuperview()
        }
    }
}

// MARK: - Table view methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.accessoryType = .none
        cell.textLabel?.text = itemTitles[items[indexPath.row]]
        cell.imageView?.image = UIImage(named: "Snack_0\(items[indexPath.row]).png")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItem(items[indexPath.row])
    }
}
