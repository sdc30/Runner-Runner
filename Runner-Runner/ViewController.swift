//
//  ViewController.swift
//  Runner Runner
//
//  Created by Stephen Cartwright on 9/1/16.
//  Copyright © 2016 Ōmagatoki. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {
    
    let deleg = NSApplication.sharedApplication().delegate as! AppDelegate;
    var path: String = "";
    var pid: Int32 = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTextLabel.stringValue = "stopped.";
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.refresh(_:)), name: "refresh", object: nil);
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
            

        }
    }
    
    

    
    @IBOutlet var spinner: NSProgressIndicator!
    
    @IBOutlet var programTextField: NSTextField!
    @IBOutlet var argumentTextField: NSTextField!
    
    @IBOutlet var statusTextLabel: NSTextField!

    @IBOutlet var runButton: NSButton!
    @IBOutlet var haltButton: NSButton!
    
    @IBAction func runButtonClick(sender: AnyObject) {
        runButton.enabled = false;
        haltButton.enabled = true;
        print(path);
        pid = runTask();
    }
    @IBAction func haltButtonClick(sender: AnyObject) {
        runButton.enabled = true;
        haltButton.enabled = false;
        
        pid = haltTask(true);
    }
    
    func refresh (notification: NSNotification) throws {
        
        path = deleg.file;
        programTextField.stringValue = path;
        

    }
    


    
    func runTask() -> Int32 {
        
        
        statusTextLabel.stringValue = "running...";
        
        let script = programTextField.stringValue;
        print(script);
        
        let code = deleg.shell("/bin/sh/", args: script);
        
        
        let pTF = programTextField.stringValue.isEmpty;
        
        if !pTF
        {
            //print(pTF);
        }


        spinner.startAnimation(self);
        return code;
    }
    
    func haltTask(switc: Bool)  -> Int32 {
        
        statusTextLabel.stringValue = "stopped.";
        
        if pid != 0 {
            // get PID end task
            deleg.exitShell(pid);
            
        }
        
        
        spinner.stopAnimation(self);
        
        return 0;
    }


}

