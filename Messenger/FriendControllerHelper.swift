//
//  FriendControllerHelper.swift
//  Messenger
//
//  Created by Egor on 11.09.17.
//  Copyright © 2017 Egor. All rights reserved.
//

import UIKit
import CoreData

extension FriendsViewController{
    
    func clearData(){
        let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        if let context = container?.viewContext{

            do{
                let entityNames = ["Friend","Message"]
                
                for entity in entityNames{
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                    
                    let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
                    
                    for object in objects!{
                        context.delete(object)
                    }
                }
                
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupData(){
        
        clearData()
        
        let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        if let context = container?.viewContext{
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckerberg"
            
            let messageMark = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            messageMark.friend = mark
            messageMark.text = "Hello, my name is Mark nice to meet you....."
            messageMark.date = NSDate()
            
            let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            steve.name = "Steven Jobs"
            steve.profileImageName = "stevejobs"
            
            let messageSteve = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            messageSteve.friend = steve
            messageSteve.text = "Hello, my name is Steve nice to meet you. I hope you enjoy IOS enviroment"
            messageSteve.date = NSDate()
            
            do{
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        loadData()
    }
    
    func loadData(){
        let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        if let context = container?.viewContext{
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            do{
                messages = try context.fetch(fetchRequest) as? [Message]
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
