var leap = require('leapjs');
var leapFrame;

var hands = [];
var fingers = [];
var strenth;

function PinchFinger() {
    this.pinchTimeStramp = 0;
    this.pinchIndex    = -1;
    this.pinchStrength = 0;
    this.grabStrength  = 0;
    this.forceValue = 0;
}
var pf = new PinchFinger();

// start leap action
var leapMain = leap.loop({enableGesture: true},function(frame) {

    leapFrame = frame

    // detect gesture only when hand in frame
    if(frame.hands.length > 0) {
        var hand = frame.hands[0];

        pf.pinchStrength = findPinchingStrength(hand);

        // detect pinch gesture
        if(pf.pinchStrength > 0) {
            var pinchingFinger = findPinchingFinger(hand, 500);
            console.log('pinch strength: ', hand.pinchStrength);
            console.log('finger type: ', pinchingFinger.type);
            pf.pinchIndex = pinchingFinger.type;

            // caculate force touch value
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

        // detect grab gesture
        // grab status means grabStrength > 0.85, empirical value
        // at this time we can ignore finger type
        console.log('grab strength: ',hand.grabStrength);
        pf.grabStrength = hand.grabStrength;

        // detect two hand
        if(frame.hands.length == 2) {
            var binualGesture = fingerMoving(frame.hands);
        }

        // detect pure gesture in leapmotion
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

    // experiment detect
    function fingerMoving(hands) {
        var leftHand = hands[0]
        var rightHand = hands[1]

        // when right hand index Finger swipe on left hand index finger
        // distance between 10~80
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
        var force = (value >= 1) ? 1 : value*value;

        return force;
    }
});

module.exports.mainThread = leapMain;
module.exports.info = pf
