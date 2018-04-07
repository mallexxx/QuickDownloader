// The MIT License (MIT)
//
// Copyright (c) 2018 zqqf16
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusController: StatusBarControler?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.statusController = StatusBarControler()
        let defaults = UserDefaults.standard
        let host = defaults.object(forKey: "aria2Host") as? String ?? "127.0.0.1"
        let port = defaults.object(forKey: "aria2Port") as? String ?? "6800"
        let secret = defaults.object(forKey: "aria2Secret") as? String
        
        guard defaults.object(forKey: "aria2DontAutoConnect") as? Bool != true else { return }
        Aria2.global = Aria2(host: host, port: port, secret: secret)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(sender)
            }
        }
        
        return true
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        Aria2.global?.addTorrents(atPaths: filenames, options: nil, position: nil) { (result, error) in
            print("AddTorrents completed with \(result ?? "<nil>")")
            if let error = error {
                DispatchQueue.main.async {
                    NSAlert(error: error).runModal()
                }
            } else if UserDefaults.standard.object(forKey: "keepTorrentFile") as? Bool != true {
                for path in filenames {
                    try? FileManager.default.trashItem(at: URL(fileURLWithPath: path), resultingItemURL: nil)
                }
            }
        }
    }
}

