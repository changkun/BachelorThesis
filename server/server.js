// require('template/entry');

var http  = require('http'),
    fs    = require('fs'),
    path  = require('path'),
    leap  = require('leapjs'),
    ws    = require('nodejs-websocket');

// websocket?
// var server = ws.createServer(function (conn) {
//     console.log("New connection")
//     conn.on("text", function(str) {
//         console.log("received " + str);
//         conn.sendText(str.toUpperCase()+"!!!")
//     });
//     conn.on("close", function(code, reason) {
//         console.log("Connection closed")
//     });
// }).listen(12345);

var hands = [];
var fingers = [];
var strenth;

var leapFrame;

function PinchFinger() {
    this.pinchTimeStramp = 0;
    this.pinchIndex    = -1;
    this.pinchStrength = 0;
    this.grabStrength  = 0;
    this.forceValue = -1;
}
var pf = new PinchFinger();


// https server request handler
function handler (req, res) {
    res.writeHead(200);
    res.end(JSON.stringify(pf));
}
// var server = https.createServer(option, handler);
http.createServer(handler).listen(10086);
console.log("Server running at http://locoalhost:10086")





leap.loop({enableGesture: true},function(frame) {

    leapFrame = frame

    // 当 frame 中有手存在时才进行检测
    if(frame.hands.length > 0) {
        var hand = frame.hands[0];

        pf.pinchStrength = findPinchingStrength(hand);

        // 检测 pinch 手势
        if(pf.pinchStrength > 0) {
            var pinchingFinger = findPinchingFinger(hand, 500);
            console.log('pinch strength: ', hand.pinchStrength);
            console.log('finger type: ', pinchingFinger.type);
            pf.pinchIndex = pinchingFinger.type;
            // pf.pinchStrength = hand.pinchStrength;

            // console.log(pf.pinchTimeStramp);

            // 计算force touch
            if (leap.vec3.distance(hand.thumb.tipPosition, hand.fingers[pinchingFinger.type].tipPosition) < 500) {
                pf.forceValue = forceValue();
                console.log('force value: ', forceValue());
            }
        } else {
            console.log('no pinch finger')
            pf.pinchIndex = -1;
            pf.pinchStrength = 0;
            pf.forceValue = 0;
        }

        // 检测 Grab 手势
        // grabStrength > 0.85 时候可以认为当前为握拳状态，经验值
        // 这时候可以忽略 finger type 的计算
        console.log('grab strength: ',hand.grabStrength);
        pf.grabStrength = hand.grabStrength;

        // 检测 双手 手势
        if(frame.hands.length == 2) {
            var binualGesture = fingerMoving(frame.hands);
        }

        // 检测当前手势
        if (frame.gestures.length > 0) {
            frame.gestures.forEach(function(gesture){
                switch (gesture.type) {
                    case "circle":
                        console.log("Circle Gesture");
                        break;
                    default:
                        console.log("No Circle");
                }
            });
        }
    } else {
        pf.pinchIndex = -1;
        pf.pinchStrength = 0;
        pf.forceValue = 0;
    }

    // pinch gesture
    // calculate the distance to figure out which finger is pinched
    function findPinchingFinger(hand, closest){
        var pincher;
        //var closest = 500;
        for(var f = 1; f < 5; f++)
        {
            current = hand.fingers[f];
            distance = leap.vec3.distance(hand.thumb.tipPosition, current.tipPosition);
            if(current != hand.thumb && distance < closest)
            {
                closest = distance;
                pincher = current;
            }
        }
        if (pincher.type != pf.pinchIndex) {
            pf.pinchTimeStramp = Date.now();
        }
        return pincher;
    }

    function findPinchingStrength(hand) {
        var thumbDirection = hand.fingers[0].direction;
        var indexDirection = hand.fingers[1].direction;

        var dotProduct = leap.vec3.dot(thumbDirection, indexDirection);

        if (dotProduct < 0.7 && hand.grabStrength < 0.85) {
            return hand.pinchStrength;
        } else {
            return -1;
        }
    }

    // 实验性检测
    function fingerMoving(hands) {
        var leftHand = hands[0]
        var rightHand = hands[1]

        // 右手的indexFinger 在左手的 indexFinger 上滑动时
        // 这个距离在10~80之间
        distanceBetweenLeftRight = leap.vec3.distance(rightHand.indexFinger.tipPosition, leftHand.indexFinger.tipPosition)

        console.log(distanceBetweenLeftRight)
        return distanceBetweenLeftRight
    }

    function forceValue(){
        // pf is the global message protocol object
        if (pf.pinchTimeStramp === 0) {
            return -1;
        }

        var delay = 250;
        var duration = 1000;

        // calculate force touch value
        var value = ((Date.now() - pf.pinchTimeStramp) - delay)/duration;
        var force = (value >=1 ) ? 1 : value*value;

        return force;
    }
});
