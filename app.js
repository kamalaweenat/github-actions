//========================================
//Dima
//23/3/22
//dima branch
//========================================
var http = require('http');
var formidable = require('formidable');
var fs = require('fs');
const  url_test = 'http://rt-dev.xyz:3001';
const  url_rt = 'http://rt-ed.co.il';

http.createServer(function (req, res) {
    console.log(req.url);
    if (req.url == '/test') {
           res.end('<H1>hello test 5</h1>');        
    }
    else {
        console.log(url_rt);
        res.writeHead(307, {
            Location: url_rt
        }).end();
    }
}).listen(80);



