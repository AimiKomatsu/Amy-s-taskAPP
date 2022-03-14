//
//  ViewController.swift
//  taskapp
//
//  Created by komatsuaimi on 2022/03/07.
//

import UIKit
import RealmSwift
import UserNotifications


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    
       let realm = try! Realm()
       var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)

    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           tableView.fillerRowHeight = UITableView.automaticDimension
           tableView.delegate = self
           tableView.dataSource = self
           search.delegate = self
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return taskArray.count
       }

 
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

           let task = taskArray[indexPath.row]
           cell.textLabel?.text = task.title

           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm"

           let dateString:String = formatter.string(from: task.date)
           cell.detailTextLabel?.text = dateString

           return cell
       }

 
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "cellSegue",sender: nil)
       }


       func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
           return .delete
       }

       // Delete ボタンが押された時に呼ばれるメソッド
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               let task = self.taskArray[indexPath.row]
               
               let center = UNUserNotificationCenter.current()
               center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
               try! realm.write {
                   self.realm.delete(self.taskArray[indexPath.row])
                   tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
               }
               center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                   for request in requests {
                       print("/---------------")
                       print(request)
                       print("---------------/")
                   }
               }
           }
       }
               

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController

        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()

            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }

            inputViewController.task = task
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            //if empty in searchbox
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath:"date", ascending: true)
            print("!!!!!!!!%@",taskArray)
            tableView.reloadData()
            return
        }
        if searchText == "" {
                    //if empty in searchbox
                    taskArray = try! Realm().objects(Task.self).sorted(byKeyPath:"date", ascending: true)
                    print("!!!!!!!!%@",taskArray)
                    tableView.reloadData()
                    return
                }
        //if word in searchbox
        taskArray = try! Realm().objects(Task.self).filter(NSPredicate(format: "category == %@", searchText))
        print("searchText = %@", searchText)
        print("========%@",taskArray)
        tableView.reloadData()
        }
}
