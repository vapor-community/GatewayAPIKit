# GatewayAPIKit

### GatewayAPIKit is a Swift package used to send text messages (SMS) with [GatewayAPI](https://gatewayapi.com/) for Server Side Swift.

## Installation
To use GatewayAPI, please add the following to your `Package.swift` file.

~~~~swift
.package(url: "https://github.com/madsodgaard/GatewayAPIKit.git", from: "0.1.0")
~~~~

## How to use
All you need to send a text message is to initialize a `GatewayAPIClient`:

~~~~swift
let elg = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let client = GatewayAPIClient(eventLoopGroup: elg, apiKey: "apikey")
~~~~

Please store your API key in storage such as environment variables and not directly in code.

You can now send a simple text message:
~~~~swift
client.send("My text message", to: ["4510203040"], from: "Mads")
~~~~
