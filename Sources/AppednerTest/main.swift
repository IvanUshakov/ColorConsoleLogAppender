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
import ColorConsoleLogAppender

let logAppender = ConsoleLogAppender()
let logger = Logger(name: "testLogger", appender:logAppender)
struct TestError: ErrorProtocol { let description: String }
logger.log("Stuff failed pretty badly", error: TestError(description: "Everything failed badly"))
