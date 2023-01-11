//
//  ViewController.swift
//  Dec-9-TableViewDEL-UPD
//
//  Created by Admin on 12/12/22.
//

import UIKit

class firstVC: UIViewController {

    @IBOutlet weak var taskTable: UITableView!
    
    @IBOutlet weak var newTask: UITextField!
        
    var idxPath: IndexPath?
    
    
    var tasks = Data.tasks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.next) {
            if let second = segue.destination as? secondVC {
                second.delegate = self
            }
        }
    }
    
    @IBAction func appendTask(_ sender: Any) {
        if let newTask = newTask {
            tasks.append(newTask.text!)
            newTask.text = ""
            taskTable.reloadData()
        }
    }
    
    func updateTask(value: String) {
        tasks[idxPath!.row] = value
        taskTable.reloadRows(at: [idxPath!], with: .fade)
    }
    
}


extension firstVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCell(withIdentifier: Constants.tempCell, for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].uppercased()
        
        return cell
    }
}


extension firstVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskTable.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { [weak self]
            _, _, _ in
            guard let self = self else {
                return
            }
            self.bookMark(indexPath: indexPath)
            //completion(true)
        }
        bookmarkAction.image = UIImage(systemName: "arrow.up")
        bookmarkAction.backgroundColor = .systemYellow
        
        let actions = UISwipeActionsConfiguration(actions: [bookmarkAction])
        
        return actions
    }
    
    func bookMark(indexPath: IndexPath) {
        let item = tasks.remove(at: indexPath.row)
        taskTable.deleteRows(at: [indexPath], with: .middle)
        tasks.insert(item, at: tasks.startIndex)
        taskTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else {
                return
            }
            self.handleDeleteAction(indexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        
        let updateAction = UIContextualAction(style: .normal, title: nil) { [weak self] _,_, completion in
            guard let self = self else {
                return
            }
            self.handleUpdateAction(indexPath: indexPath)
            completion(true)
        }
        updateAction.image = UIImage(systemName: "pencil")
        updateAction.backgroundColor = .systemGreen
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
        return swipeAction
    }
    
    func handleDeleteAction(indexPath: IndexPath) {
        taskTable.beginUpdates()
        
        tasks.remove(at: indexPath.row)
        taskTable.deleteRows(at: [indexPath], with: .fade)
        
        taskTable.endUpdates()
    }

    
    func handleUpdateAction(indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.next, sender: nil)
        idxPath = indexPath
    }
}
