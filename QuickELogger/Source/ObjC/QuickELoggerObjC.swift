//Copyright (c) 2019 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the
//"Software"), to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

@objc
public enum ObjCDirectory: Int {
    case documents
    case temp
    case caches
    case library
}

@objc
public enum ObjCLogType: Int {
    case verbose
    case info
    case debug
    case warn
    case error
}

@objc
public class QuickELoggerObjC: NSObject {
    // MARK: - Public properties
    
    let engine: QuickELoggerEngine
    
    // MARK: - Init methods
    
    @objc
    public convenience override init() {
        self.init(filename: "QuickELogger", directory: .documents)
    }
    
    @objc
    public convenience init(filename: String) {
        self.init(filename: filename, directory: .documents)
    }
    
    @objc
    public init(filename: String, directory: ObjCDirectory) {
        let transformedDirectory = transformDirectory(objcDirectory: directory)
        
        engine = QuickELoggerEngine(filename: filename, directory: transformedDirectory)
        
        super.init()
    }
    
    // MARK: - Public methods
    
    @objc
    public func log(message: String, type: ObjCLogType) {
        let transformedLogType = transformLogType(objcLogType: type)
        
        engine.log(message: message, type: transformedLogType, currentDate: Date())
    }
}
