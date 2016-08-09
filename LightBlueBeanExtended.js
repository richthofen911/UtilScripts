const Bleacon = require('bleacon');
const os = require('os');
const pathCreateDB = '/query?q=CREATE%20DATABASE%20cengn';
const pathWriteData = '/write?db=cengn';
const hostname = os.hostname();

var http = require('http');
var scanThisTime = new Map();
var scanLastTime;
var options = {
  hostname: 'localhost',
  port: 8086,
  path: pathCreateDB,
  method: 'POST',
  headers: {'Content-Type': 'content-type plain/text'}
};

function start() {
    scanLastTime = new Map(scanThisTime);
    scanThisTime.clear();

    Bleacon.startScanning();
}

function stop() {
    Bleacon.stopScanning();
    /*
    console.log("\nLAST: ---------------");
    for(let key of scanLastTime.keys()){
        let tmp = scanLastTime.get(key);
        console.log("LAST: " + tmp.major + " " + tmp.minor);
    }
    console.log("THIS: ---------------");
    for(let key of scanThisTime.keys()){
        let tmp = scanThisTime.get(key);
        console.log("THIS: " + tmp.major + " " + tmp.minor);
    }
    */
    console.log("IN: -----------------");
    for(let key of scanThisTime.keys()){
        if(scanLastTime.get(key) === undefined){
            let tmp = scanThisTime.get(key);
            console.log("IN: " + tmp.toString("IN"));
            postData(tmp.toString("IN"))
        }
    }
    console.log("OUT: -----------------");
    for(let key of scanLastTime.keys()){
        if(scanThisTime.get(key) === undefined){
            let tmp = scanLastTime.get(key);
            console.log("OUT: " + tmp.toString("OUT"));
            postData(tmp.toString("OUT"));
        }
    }
}

function BeaconData(timestamp, uuid, major, minor) {
    this.uuid = uuid;
    this.timestamp = timestamp;
    this.major = major;
    this.minor = minor;
    this.toString = (status) => `scans,hostname=${hostname},status=${status} uuid="${uuid}",major=${major},minor=${minor} ${timestamp}`;
}

function postData(data){
    var req = http.request(options);
    req.on('error', (e) => console.log('problem with request: ' + e.message));
    req.write(data);
    req.end();
}

Bleacon.on('discover', (beacon) => {
    const timestamp = new Date().getTime();
    const uuid = beacon.uuid;
    const major = beacon.major.toString(10);
    const minor = beacon.minor.toString(10);
    const key = major + minor;
    let infoFormat = `${timestamp} | ${uuid} | ${major} | ${minor}`;
    if(beacon.uuid.match('e2c56db5dffb48d2b060d0f5a71096e0')){
        if(scanThisTime.get(key) === undefined){
            console.log('found: ' + infoFormat);
            scanThisTime.set(key, new BeaconData(timestamp, uuid, major, minor));
        }
    }
});

postData(''); // create db if not exist
options.path = pathWriteData;
setInterval(() => {start(); setTimeout(() => stop(), 2000);}, 5000);  // scan 2 seconds and pause 5 seconds, loop
