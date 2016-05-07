var server = require('../server.js');
var http   = require('http');
var assert = require('assert');
var url = 'http://localhost:10086';

describe('server', function () {
  before(function () {
    server.listen(10086);
  });
  after(function () {
    server.close();
  });
});

describe('/', function() {
    it('should return 200', function(done) {
        http.get(url, function(res) {
            assert.equal(200, res.statusCode);
            done();
        });
    });
    it('should returl 0 for pinchTimeStramp', function(done) {
        http.get(url, function(res) {
            res.on('data', function(data) {
                var json = JSON.parse(data);
                assert.equal(0, json.pinchTimeStramp);
                done();
            });
        });
    });
    it('should returl -1 for pinchIndex', function(done) {
        http.get(url, function(res) {
            res.on('data', function(data) {
                var json = JSON.parse(data);
                assert.equal(-1, json.pinchIndex);
                done();
            });
        });
    });
    it('should returl 0 for pinchStrength', function(done) {
        http.get(url, function(res) {
            res.on('data', function(data) {
                var json = JSON.parse(data);
                assert.equal(0, json.pinchStrength);
                done();
            });
        });
    });
    it('should returl 0 for grabStrength', function(done) {
        http.get(url, function(res) {
            res.on('data', function(data) {
                var json = JSON.parse(data);
                assert.equal(0, json.grabStrength);
                done();
            });
        });
    });
    it('should returl 0 for forceValue', function(done) {
        http.get(url, function(res) {
            res.on('data', function(data) {
                var json = JSON.parse(data);
                assert.equal(0, json.forceValue);
                done();
            });
        });
    });
});
