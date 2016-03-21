// require('template/entry');

var http = require('http'),
    fs    = require('fs'),
    path  = require('path'),
    leap  = require('leapjs');

var hands = [];
var fingers = [];
var strenth;

var leapFrame;

function PinchFinger() {
    this.pinchIndex    = -1;
    this.pinchStrength = 0;
    this.grabStrength  = 0;
}
var pf = new PinchFinger();

var option = {
    key:  fs.readFileSync('./ssl/server.key'),
    cert: fs.readFileSync('./ssl/server.crt')
};
// https server request handler
function handler (req, res) {
    // console.log(req.headers.host);
    // console.log(req.url);
    // console.log(req.method);
    // console.log(req.httpVersion);

    // console.log(leapFrame);
    res.writeHead(200);
    // res.end(JSON.stringify(leapFrame));
    // res.end('hello world');
    res.end(JSON.stringify(pf));
}
// var server = https.createServer(option, handler);
http.createServer(handler).listen(10086);
console.log("Server running at http://locoalhost:5637")



// Leap Processing
// var controller = new leap.Controller({enableGesture: true});
// controller.on('gesture', function(gesture) {
//     console.log(gesture);
//     if (gesture.type === 'swipe' && gesture.state === 'stop') {
//         // && gesture.duration > 8000
//         handleSwipeGesture(gesture);
//     }
// });

// controller.connect();
// leap.loop(function (frame) {
//     if (frame.hands.length > 0) {
//         var hand   = frame.hand[0];
//         var finger = hand.fingers[0];
//         if (frame.hands[0].fingers.length > 3) {
//             // ...do something
//         }
//     }
// });

leap.loop({enableGesture: true},function(frame) {

    leapFrame = frame

    // 当 frame 中有手存在时才进行检测
    if(frame.hands.length > 0) {
        var hand = frame.hands[0];

        // 检测 pinch 手势
        if(hand.pinchStrength > 0) {
            var pinchingFinger = findPinchingFinger(hand);
            console.log('pinch strength: ', hand.pinchStrength);
            console.log('finger type: ', pinchingFinger.type);
            pf.pinchIndex = pinchingFinger.type;
            pf.pinchStrength = hand.pinchStrength;
        } else {
            console.log('no pinch finger')
            pf.pinchIndex = -1;
            pf.pinchStrength = 0;
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
    }



    // pinch gesture
    // calculate the distance to figure out which finger is pinched
    function findPinchingFinger(hand){
        var pincher;
        var closest = 500;
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
        return pincher;
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
});
