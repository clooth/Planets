//
//  ViewController.swift
//  Planets
//
//  Created by Nico Hämäläinen on 16/03/15.
//  Copyright (c) 2015 sizeof.io. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let skView = self.view as SKView
    skView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    
    let scene = GameScene()
    scene.size = view.bounds.size
    scene.scaleMode = .AspectFill
    skView.presentScene(scene)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

