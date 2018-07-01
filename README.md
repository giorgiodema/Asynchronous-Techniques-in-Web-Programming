# Asynchronous Techniques in Web Programming

## Index

### WebWorkersTris
Example of asynchronous programming with Javascript and WebWorkers. It's a WebApp that lets you play tetris against computer.

### HTTPChat
WebChat realized with http. Messages forwarding is asynchronous, using AJAX. The comunication between client and server is synchronous instead, so reloading the entire page is the only way to get updates.

### PollingChat
Example of WebChat realized with polling technique. Polling is a primitive and inefficient way to simulate asynchronous comunication between client and server.

### WebSocketChat
WebChat realized with WebSocket protocol. WebSocket provides a full-duplex channel betweens client and server for the whole session, so they can communicate asynchronously.

## SetUp
- Make sure you have postgresql server running (the applications assumes postgresql running on localhost and listening on port: 5432)
- Run `$ bundle install` to install dependencies
- Run `$ rails db:create && rails db:migrate && rails db:seed` to set up database (WebWorkerTris doesn't need to set up database)
- Run `$ rails s` to run server
