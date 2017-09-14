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
            
            createMessageWith(text: "Hello, my name is Mark nice to meet you.....", friend: mark, context: context)
            
            let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            steve.name = "Steven Jobs"
            steve.profileImageName = "stevejobs"
            
            createMessageWith(text: "Good morning...", friend: steve, context: context)
            createMessageWith(text: "How are you?", friend: steve, context: context)
            createMessageWith(text: "Are you interested in buying an Apple divice?", friend: steve, context: context)
            
            let bill = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            bill.name = "Bill Gates"
            bill.profileImageName = "billgates"
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.friend = bill
            message.text = "Hello"
            message.date = NSDate(timeIntervalSinceNow: -60*60*24*7)
            do{
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        loadData()
    }
    
    private func createMessageWith(text: String, friend: Friend, context: NSManagedObjectContext){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate()
    }
    
    func loadData(){
        let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        if let friends = fetchFriend(){
            
            messages = [Message]()
            
            for friend in friends{
                
                if let context = container?.viewContext{
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do{
                        if let fetchedMessages = try context.fetch(fetchRequest) as? [Message]{
                            messages?.append(contentsOf: fetchedMessages)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            messages = messages?.sorted{$0.date!.timeIntervalSince1970 > $1.date!.timeIntervalSince1970}
        }
    }
    
    private func fetchFriend() -> [Friend]?{
        let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        
        if let context = container?.viewContext{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            
            do{
                return try context.fetch(fetchRequest) as? [Friend]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
