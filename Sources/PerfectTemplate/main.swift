//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectWebSockets
import PerfectLib

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.

//func handler(request: HTTPRequest, response: HTTPResponse) {
//	// Respond with a simple message.
//	response.setHeader(.contentType, value: "text/html")
//	response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
//	// Ensure that response.completed() is called when your processing is done.
//	response.completed()
//}

// Configure one server which:
//	* Serves the hello world message at <host>:<port>/
//	* Serves static files out of the "./webroot"
//		directory (which must be located in the current working directory).
//	* Performs content compression on outgoing data when appropriate.
//var routes = Routes()
//routes.add(method: .get, uri: "/", handler: handler)
//routes.add(method: .get, uri: "/**",
//		   handler: StaticFileHandler(documentRoot: "./webroot", allowResponseFilters: true).handleRequest)
//try HTTPServer.launch(name: "localhost",
//					  port: 8181,
//					  routes: routes,
//					  responseFilters: [
//						(PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)])

func makeRoutes() -> Routes {
    var routes = Routes()
    
    // Add the endpoint for the WebSocket example system
    routes.add(method: .get, uri: "/game", handler: {
        request, response in
        
        // To add a WebSocket service, set the handler to WebSocketHandler.
        // Provide your closure which will return your service handler.
        WebSocketHandler(handlerProducer: {
            (request: HTTPRequest, protocols: [String]) -> WebSocketSessionHandler? in
            
            // Return our service handler.
            return GameHandler()
        }).handleRequest(request: request, response: response)
    })
    
    return routes
}

do {
    // Launch the HTTP server on port 8181
    try HTTPServer.launch(name: "localhost", port: 8181, routes: makeRoutes())
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
