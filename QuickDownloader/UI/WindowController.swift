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

extension NSStoryboard.SceneIdentifier {
    static let titlebarAccessoryVC = NSStoryboard.SceneIdentifier(rawValue: "TitlebarAccessoryViewController")
}

class MainWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        self.titleVisibility = .hidden
        //self.titlebarAppearsTransparent = true
        //self.isMovableByWindowBackground = true
        //self.styleMask.insert(.fullSizeContentView)
        self.styleMask.insert(.unifiedTitleAndToolbar)
        //self.backgroundColor = NSColor.white
        //self.center()
    }
}

class WindowController: NSWindowController {

    var titlebarAccessoryViewController: TitlebarAccessoryViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        self.titlebarAccessoryViewController = storyboard.instantiateController(withIdentifier: .titlebarAccessoryVC) as? TitlebarAccessoryViewController
        self.titlebarAccessoryViewController!.layoutAttribute = .bottom
        self.window?.addTitlebarAccessoryViewController(self.titlebarAccessoryViewController!)
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let vc = segue.destinationController as? NewTaskViewController {
            vc.aria2 = Aria2.global
        }
    }
}
