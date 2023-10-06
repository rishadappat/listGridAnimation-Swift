//
//  ViewController.swift
//  ListGridAnimation
//
//  Created by Rishad Appat on 25/05/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var changeLayoutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var colors = ["480032", "005792", "4a1c40", "962d2d", "233e8b", "1eae98",
                  "564a4a", "4aa96c", "f55c47", "393e46", "344fa1", "325288", "206a5d"]
    
    var isGridFlowLayoutUsed: Bool = true {
        didSet {
            updateButtonAppearance()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView()
    {
        collectionView.collectionViewLayout = Layout.gridCompositionalLayout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func updateButtonAppearance() {
        self.changeLayoutButton.isEnabled = false
        self.collectionView.reloadData()
        self.title = isGridFlowLayoutUsed ? "Grid" : "List"
        let layout = isGridFlowLayoutUsed ? Layout.gridCompositionalLayout : Layout.listCompositionalLayout
        let buttonImage = isGridFlowLayoutUsed ? #imageLiteral(resourceName: "list") : #imageLiteral(resourceName: "grid")
        self.changeLayoutButton.image = buttonImage
        self.collectionView.startInteractiveTransition(to: layout, completion: {_,_ in
            self.changeLayoutButton.isEnabled = true
        })
        self.collectionView.finishInteractiveTransition()
    }

    @IBAction func changeLayoutClicked(_ sender: Any) {
        isGridFlowLayoutUsed = !isGridFlowLayoutUsed
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colorName = "#\(colors[indexPath.row])"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        cell.bind(colorName: colorName, isGridFlowLayoutUsed: isGridFlowLayoutUsed)
        return cell
    }
}
