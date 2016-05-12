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
    password:'',
    database:'chatdb'
});

io.sockets.on('connection', function(socket){
    socket['joined'] = false;
    socket.on('room-change', function(data) {
        //
        // VALIDATE INPUT
        // check data exists at all
        if(data == undefined){
            logAndEmit(socket, "Critical error: no data received on room-change event!");
            return;
        }
        // check data contains expected properties
        if(!data.hasOwnProperty('user')){
            console.log("Got data with no user property; rejected.");
            socket.emit('new message', "User name data was missing!");
            return;
        }
        if(!data.hasOwnProperty('room')){
            console.log("Got data with no room property; rejected.");
            socket.emit('new message', "Room name data was missing!");
            return;
        }
        // check data not just white space
        if(/^\s*$/.test(data['user'])){
            console.log("Got user name with only white space; rejected.");
            socket.emit('new message', "User name can't be only white space!");
            return;
        }
        if(/^\s*$/.test(data['room'])){
            console.log("Got message for room with name only white space; rejected.");
            socket.emit('new message', "Room name can't be only white space!");
            return;
        }
        // check data only contains alphanumerics
        if(!/^[a-zA-Z0-9]*$/.test(data['user'])){
            console.log("Got user name with invalid characters; rejected.");
            socket.emit('new message', "User name can only have letters and numbers!");
            return;
        }
        if(!/^[a-zA-Z0-9]*$/.test(data['room'])){
            console.log("Got room name with invalid characters; rejected.");
            socket.emit('new message', "Room name can only have letters and numbers!");
            return;
        }
        // check data valid length
        if(data['user'].length > 16){
            console.log("Got user name longer than 16 characters; rejected.");
            socket.emit('new message', "User name maximum length is 16!");
            return;
        }
        if(data['room'].length > 16){
            console.log("Got room name longer than 16 characters; rejected.");
            socket.emit('new message', "Room name maximum length is 16!");
            return;
        }
        // VALIDATE INPUT
        
        console.log("A user attempted to log into '" + data['room'] + "' as '" + data['user'] + "'");
        connection.query({sql:"SELECT `room_id` FROM rooms WHERE `name`='" + data['room'] + "';"}, function(err, rows, fields){
            if(err) {
                var errMsg = "ERROR attempting to get room info from DB. " + err;
                console.log(errMsg);
                socket.emit('new message', errMsg);
                return;
            }
            else if(rows.length == 0) {
                connection.query({sql:"INSERT INTO rooms (name) VALUES('" + data['room'] + "');"}, function(err, row, fields){
				    if (err){
                        logAndEmit("Error creating new room; aborting.");
                        return;
                    }
                    var output = "- system message - Room '" + data['room'] + "' did not exist, so we've created it for you!  Have fun in your new room!<br>- -";
                    
                    socket.emit('clear-chat');
                    socket.emit('new message', output);
                    
                    validateUserOnRoomChange(socket, data);
				});
				return;
            }
            else {
                connection.query({sql:"SELECT a.name, b.msg_body FROM users a, messages b WHERE a.user_id=b.user_id AND `room_id`=" + rows[0]["room_id"] + " ORDER BY `time_utc` DESC LIMIT 15;"}, function(err, rows, fields){
                    if(err){
                        console.log("Couldn't get existing messages from database.");
                        console.log(err);
                        socket.emit(err);
						return;
                    }
                    socket.emit('clear-chat');
                    var output = ""
                    //for(item of rows) {
                    for(var i = 0; i < rows.length; i++) {
                        var item = rows[i];
                        if(i == 0){
                            output = "<strong>" + item["name"] + ":</strong> " + item["msg_body"] + output;
                        }
                        else {
                            output = "<strong>" + item["name"] + ":</strong> " + item["msg_body"] + "<br>" + output;
                        }
                    }
                    output = "- system message - Welcome to " + data['room'] + "!  Let's start you off with the most recent ten messages (or up to ten if fewer exist in our database).<br>- -<br>" + output;
                    if(rows.length == 0) {
                        output += "- system message - No messages in this room, yet.  Be the first!<br>- -";
                    }

                    socket.emit('new message', output);
                    
                    validateUserOnRoomChange(socket, data);
                });
            }
        });
    });
    
	socket.on('send-message', function(data){
        console.log("A user tried to send a message.");

        if(socket['joined'] == false || !socket.hasOwnProperty('user') || !socket.hasOwnProperty('room')){
            console.log('User has not correctly joined a room yet.');
            socket.emit('new message', "You must join a room before sending messages!");
            return;
        }
        
        if(!data.hasOwnProperty('msg')){
            console.log("Got data with no message property; rejected.");
            socket.emit('new message', "Message data was missing!");
            return;
        }
        
        if(/^\s*$/.test(data['msg'])){
            console.log("User sent message with only white space; rejected.");
            socket.emit('new message', "You can't send a message with only white space!");
            return;
        }
        
        getUserIdByName(socket, data);
    });
});

function validateUserOnRoomChange(socket, data){
    // get user id by name
    console.log("trying to get id for user based on name '" + data['user'] + "'");
    connection.query({sql:"SELECT user_id FROM users WHERE `name`='" + data['user'] + "';"}, function(err, rows, fields){
    // get user id by name callback
        
        // in case of error, kill this callback
        if(err){
            logAndEmit("err: " + err);
            return;
        }

        // in case of missing user, create user
        if(rows[0] == undefined){
            console.log("user '" + data['user'] + "' was missing from DB; creating.");
            connection.query({sql:"INSERT INTO users (name, password) VALUES('" + data['user'] + "','nothing');"}, function(err, rows, fields){
            // insert new user callback
                if(err){
                    logAndEmit("failed creating new user in DB: " + err);
                    return;
                }
                logAndEmit(socket, "Your user name was not found in our DB, so a new user was created!");
                validateUserOnRoomChange(socket, data);
            // end insert new user callback
            });
            // if user was missing, don't continue to try and get user id from a row! just quit this function
            return;
        }
        var user_id = rows[0]['user_id'];
        console.log("got user id " + user_id + " for user " + data['user']);
        
        socket['joined'] = true;
        socket['user'] = data['user'];
        socket['room'] = data['room'];
        socket.emit('update-roomname', data);
    // end get user id by name callback
    });
}

function getUserIdByName(socket, data) {
    // get user id by name
    console.log("trying to get id for user '" + socket['user'] + "'");
    connection.query({sql:"SELECT user_id FROM users WHERE `name`='" + socket['user'] + "';"}, function(err, rows, fields){
    // get user id by name callback
        
        // in case of error, kill this callback
        if(err){
            console.log("err: " + err);
            return;
        }

        // in case of missing user, create user
        if(rows[0] == undefined){
            logAndEmit("Fatal error: uncaught user account error!");
            return;
            /*
            console.log("user '" + data['user'] + "' was missing from DB; creating.");
            connection.query({sql:"INSERT INTO users (name, password) VALUES('" + data['user'] + "','nothing');"}, function(err, rows, fields){
            // insert new user callback
                if(err){
                    console.log("failed creating new user in DB: " + err);
                    return;
                }
                logAndEmit(socket, "User not found in DB, so a new user was created!");
                getUserIdByName(socket, data);
            // end insert new user callback
            });
            // if user was missing, don't continue to try and get user id from a row! just quit this function
            return;
            */
        }

        var user_id = rows[0]['user_id'];
        console.log("got user id " + user_id + " for user " + data['user']);
        
        // user 'validated', validate room
        var targetRoomName = socket['room'];
        // get room id from name so we can post to correct room
        connection.query({sql:"SELECT room_id FROM rooms WHERE name='" + targetRoomName + "'"}, function(err,rows,fields){
            if(err) {
                logAndEmit(socket,"Error getting room id from room name. (DB error.)");
                return;
            }
            if(rows.length < 1){
                logAndEmit(socket,"Error getting room id from room name. (Mismatch error.)");
                return;
            }
            // room validated, post message
            handleMessage(user_id, rows[0]['room_id'], data);
        });
    // end get user id by name callback
    });
}

function handleMessage(user_id, room_id, data){
    connection.query({sql:"INSERT INTO messages SET `room_id`=" + room_id + ", `time_utc`=UNIX_TIMESTAMP(), `user_id`=" + user_id + ", `msg_body`=\"" + data['msg'] + "\";"}, function(err, rows, fields){
        if(err){
            console.log("Couldn't insert incoming message to DB; will not emit.");
            console.log(err);
            return;
        }
        console.log("Insert completed on incoming message.")
        io.sockets.emit('new message', "<strong>" + data['user'] + "</strong>: " + data['msg']);
    });    
}

function logAndEmit(socket, msg){
    console.log(msg);
    socket.emit('new message', msg);
}