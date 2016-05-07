
var http  = require('http'),
    gesture = require('./gesture')

var pf = gesture.info
var recognize = gesture.mainThread

// https server request handler
function handler (req, res) {
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(pf));
}
// var server = https.createServer(option, handler);
http.createServer(handler).listen(10086);
console.log("Server running at http://localhost:10086")
