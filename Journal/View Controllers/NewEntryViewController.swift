//
//  NewEntryViewController.swift
//  Journal
//
//  Created by Edward Huang on 1/8/18.
//  Copyright © 2018 Eddie Huang. All rights reserved.
//

import UIKit
import MessageUI

class NewEntryViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Watch for any change to the journal
        NotificationCenter.default.addObserver(self, selector: #selector(receievedJournalChangeNotification), name: .journalChanged, object: nil)
        
        let journal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = journal.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let navVC = segue.destination as? UINavigationController {
            if let editEntryVC = navVC.childViewControllers.first as? EditEntryViewController {
                EntryHistorian.historian.addEntry(title: "", text: "", date: Date())
                editEntryVC.indexToEdit = 0
            }
        }
    }
    
    // MARK: IBActions
    @IBAction func downloadPressed(_ sender: Any) {
        guard let url = URL(string: "https://raw.githubusercontent.com/aigagror/Life-Journal/master/journals.txt?token=ATEr4wGVFoV8foHiRQ4KeD672DBi2ZtSks5aYBSCwA%3D%3D") else {
            fatalError("Could not get url")
        }
        Downloader.load(URL: url)
    }
    
    @IBAction func exportPressed(_ sender: Any) {
        //Check to see the device can send email.
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("Journal")
            mailComposer.setMessageBody("Here is your journal:", isHTML: false)
            
            // Create JSON object of current journals
            
            let librarian = JournalLibrarian.librarian
            let historian = EntryHistorian.historian
            
            
            
            if let filePath = Bundle.main.path(forResource: "swifts", ofType: "wav") {
                print("File path loaded.")
                
                if let fileData = NSData(contentsOfFile: filePath) {
                    print("File data loaded.")
                    mailComposer.addAttachmentData(fileData as Data, mimeType: "text/plain", fileName: "journalJSON")
                }
            }
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    
    // MARK: Private Functions
    @objc
    private func receievedJournalChangeNotification() {
        let currentJournal = JournalLibrarian.librarian.getCurrentJournal()
        navigationItem.title = currentJournal.name
    }
    
    // MARK: Mail Delegate
    private func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismiss(animated: true, completion: nil)
    }
}
