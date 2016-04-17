var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io').listen(server);
var mysql = require('mysql');
	
	users = [];
	connections = [];
	
server.listen(3000);
console.log('Server running...');

app.get('/', function(req, res){
	
	res.sendFile(__dirname + '/index.html');
	
});

var connection = mysql.createConnection({
    host:'127.0.0.1',
    user:'root',
    password:'secretpass',
    database:'chatdb'
});

io.sockets.on('connection', function(socket){
    socket.on('room-change', function(data) {
        console.log("A user attempted to change room to '" + data + "'");
        connection.query({sql:"SELECT * FROM messages WHERE `room_id`=1 ORDER BY `time_utc` DESC LIMIT 10;"}, function(err, rows, fields){
            if(err){
                console.log("Couldn't get existing messages from database.");
                console.log(err);
                socket.emit(err);
                return;
            }
            var output = ""
            for(item of rows) {
                output = "user " + item["user_id"] + ": " + item["msg_body"] + "<br>" + output;
            }
            output = "- system message - Welcome to Chat584!  Let's start you off with the most recent ten messages (or up to ten if fewer exist in our database).<br>- -<br>" + output;
            if(rows.length == 0) {
                output += "- system message - No messages in this room, yet.  Be the first!<br>- -";
            }

            socket.emit('new message', output);
        });
    });
    
	socket.on('send-message', function(data){
        connection.query({sql:"INSERT INTO messages SET `room_id`=1, `time_utc`=UNIX_TIMESTAMP(), `user_id`=1, `msg_body`=\"" + data + "\";"}, function(err, rows, fields){
            if(err){
                console.log("Couldn't insert incoming message to DB; will not emit.");
                console.log(err);
                return;
            }
            console.log("Insert completed on incoming message.")
		    io.sockets.emit('new message', data);
        });
    });
});