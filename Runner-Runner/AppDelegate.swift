//
//  AppDelegate.swift
//  Runner Runner
//
//  Created by Stephen Cartwright on 9/1/16.
//  Copyright © 2016 Ōmagatoki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        
    }


    
    func openDocument(sender: AnyObject){
        let w = NSApp.mainWindow;
        let op = NSOpenPanel();
        op.canChooseFiles = true;
        op.canChooseDirectories = true;
        op.allowsMultipleSelection = false;
        
        op.beginSheetModalForWindow(w!, completionHandler: { (res) -> Void in
            if res == NSFileHandlingPanelOKButton {
                
                    self.file = (op.URL?.path)!;
                    NSDocumentController.sharedDocumentController().noteNewRecentDocumentURL(op.URL!);
            }
        })
        
    }
    
    
    var file: String = String() {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil);
        }
    }
    
    var messages: String = String() {
        didSet{
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil);
        }
    }

    func shell(path: String, args: String...) -> Int32 {
        
         let task = NSTask();
        

         task.launchPath = path;
         task.arguments = args;
        
        
         task.launch();
        print("running...");  

        
        
        // task.waitUntilExit();
        // return task.terminationStatus;
        
        print(task.processIdentifier);
        
        return task.processIdentifier;
    }
    
    func standardOutputRouter(tsk: NSTask) {
        let pipe = NSPipe();
        
        tsk.standardOutput = pipe;
        
        _ = pipe.fileHandleForReading.waitForDataInBackgroundAndNotify();
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification, object: pipe.fileHandleForReading, queue: nil) {
            
            notification in
            
            let output = pipe.fileHandleForReading.availableData;
            let out: String? = (NSString(data: output, encoding: NSUTF8StringEncoding) as! String);
            
            
            dispatch_async(dispatch_get_main_queue(), {
                //let prevOut = out;
                self.messages = out!;
                
            })
        
            
        
            if out!.isEmpty {
                print("empty");
            }
            else{
                print(out);
            }
            
            pipe.fileHandleForReading.waitForDataInBackgroundAndNotify();
        
     }
        
    }

    func exitShell(pid: Int32) -> Int32{
        
        let s = String(pid);
        print(pid);
        system("kill -9 " + s);
        
        return 0;
        
    }

    
    
}

