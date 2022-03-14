//
//  ViewController.swift
//  taskapp
//
//  Created by komatsuaimi on 2022/03/07.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    func tableView(_tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    func tableView(_tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
    }
    // 各セルを選択した時に実行されるメソッド
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "cellSegue",sender: nil) // ←追加する
    }
}
