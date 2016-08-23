//
//  ConsoleLogAppender.swift
//  slackbot
//
//  Created by Иван Ушаков on 13.05.16.
//
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import Log

public final class ConsoleLogAppender: Appender {
    public var name: String = "Console Log Appender"
    public var closed: Bool = false
    public var level: Log.Level = .all
    
    public var colored = true
    public var coloredLines = false
    public var detailOutput = true
    public var loggerName = false
    public var levelString = LevelString()
    public var levelColor = LevelColor()
    
    public init () {}
    
    
    public struct LevelString {
        public var Trace = "TRACE"
        public var Debug = "DEBUG"
        public var Info = "INFO"
        public var Warning = "WARNING"
        public var Error = "ERROR"
        public var Fatal = "FATAL"
    }
    
    // For a colored log level word in a logged line
    // XCode RGB colors
    public struct LevelColor {
        public var Trace = "0;90m"       // silver
        public var Debug = "0;32m"        // green
        public var Info = "0;34m"         // blue
        public var Warning = "0;33m"      // yellow
        public var Error = "0;31m"         // red
        public var Fatal = "0;31m"         // red
    }
    
    var reset = "\u{001b}[0m"
    var escape = "\u{001b}["
    
    public func append(_ event: LoggingEvent) {
        
        let levelStr = formattedLevel(level: event.level)
        
        var msg = "\(event.message ?? "")"
        
        if let error = event.error {
            msg += ": \(error)"
        }
        
        let formattedMsg = coloredMessage(msg: msg, forLevel: level)

        var str = ""
        
        str += "[\(self.isoDateString(timestamp:event.timestamp) ?? "")]"
                
        if (loggerName) {
            str += " [\(event.name)]"
        }
        
        if detailOutput {
            let file = event.locationInfo.file.characters.split(separator: "/").map(String.init).last!.characters.split(separator: ".").map(String.init).first!
            str += " \(file).\(event.locationInfo.function):\(event.locationInfo.line)"
        }

        str += " \(levelStr): \(formattedMsg)"
        
        print(str)
    }
    
    /// returns color string for level
    func colorForLevel(level: Log.Level) -> String {
        var color = ""
        
        switch level {
        case Log.Level.trace:
            color = levelColor.Trace
            
        case Log.Level.debug:
            color = levelColor.Debug
            
        case Log.Level.info:
            color = levelColor.Info
            
        case Log.Level.warning:
            color = levelColor.Warning
            
        case Log.Level.error:
            color = levelColor.Error

        case Log.Level.fatal:
            color = levelColor.Fatal
            
        default:
            color = levelColor.Trace
        }
        
        return color
    }
    
    /// returns an optionally colored level noun (like INFO, etc.)
    func formattedLevel(level: Log.Level) -> String {
        let color = colorForLevel(level: level)
        var levelStr = ""
        
        switch level {
        case Log.Level.debug:
            levelStr = levelString.Debug
            
        case Log.Level.info:
            levelStr = levelString.Info
            
        case Log.Level.warning:
            levelStr = levelString.Warning
            
        case Log.Level.error:
            levelStr = levelString.Error
            
        default:
            // Verbose is default
            levelStr = levelString.Trace
        }
        
        if colored {
            levelStr = escape + color + levelStr + reset
        }
        return levelStr
    }
    
    /// returns the log message entirely colored
    func coloredMessage(msg: String, forLevel level: Log.Level) -> String {
        if !(colored && coloredLines) {
            return msg
        }
        
        let color = colorForLevel(level: level)
        let coloredMsg = escape + color + msg + reset
        return coloredMsg
    }
    
    func isoDateString(timestamp: Int) -> String? {
        var output = [Int8](repeating: 0, count: 40)
        var tt = time_t(timestamp)
        var t = tm()
        gmtime_r(&tt, &t)
        let len = strftime(&output, 40, "%FT%TZ", &t)
        
        if len > 0 {
            return String(validatingUTF8: output)
        }
        
        return nil
    }
}
