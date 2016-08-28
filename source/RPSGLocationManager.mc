using Toybox.Position as Position;
using Toybox.Math as Math;
using Toybox.System as System;

class RPSGLocationManager {
	hidden const MAX_DIST = 10.0;		// Max distance that an NPC can spawn from the player, which will be 1 / MAX_DIST degrees (of latitude or longitude)
	hidden const MOVE_SPEED = 0.001;	// Determines the distance that an NPC will move on each update
	hidden const TURN_SPEED = 0.0006;	// Determines the speed at which each NPC will turn as it moves

	// mobs contains a list of Mob objects (defined below) that represent nearby NPCs
	hidden var mobs = new [3];
	hidden var closest = 0;
	
	function initialize() {
		//Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:posUpdate));
		var p1 = new Position.Location({:latitude=>50.0, :longitude=>50.0, :format=>:degrees});
		var p = new TestInfo(p1, 0.0);
		System.print("Starting position: ");
		System.println(p.position.toGeoString(Position.GEO_DEG));
		posUpdate(p);
		System.println("Location events enabled");
	}
	
	
	// Testing purposes only (for custom locations)
	class TestInfo {
		var position;
		var heading;
		
		function initialize(p, h) {
			position = p;
			heading = h;
		}
	}
	
	// This function should be called whenever the GPS location of the wearer is updated
	function posUpdate(info) {
		System.println("Position update:");
		for (var i = 0; i < 3; i++) {
			// If NPC does not exist or exceeds maximum distance from player, generate new NPC...
			if (mobs[i] == null || (dist(info, mobs[i]) > 1.0 / MAX_DIST)) {
				mobs[i] = genMob(info);
			}
			// ...otherwise, move NPC 
			else {
				setPos(mobs[i]);
			}
			
			// Check to see if this NPC is closer to the player than the current closest NPC on record
			if (i != closest && dist(info, mobs[i]) < dist(info, mobs[closest])) {
				closest = i;
			}
			System.println(i.toString() + ": " + mobs[i].toString());
		}
		System.print("Go direction from ");
		System.print(closest);
		System.print(" ");
		System.println(goDirection());
	}
	
	/* Returns the angle at which the arrow should be directed. This value is expressed
	   in radians from the vector (0, 1) (ie straight up) clockwise */
	function goDirection() {
		var info = /*new TestInfo(new Position.Location({:latitude=>50.0, :longitude=>50.0, :format=>:degrees}), 0.0);*/Position.getInfo();
		var pos = info.position.toDegrees();
		
		// Get info for the closest NPC
		var attr = mobs[closest].getAttr();
		// Get the vector from the player to the closest NPC
		var v = [attr[0] - pos[0], attr[1] - pos[1]];
		// Convert vector into reference frame defined by wearer's current direction
		var v1 = rotate(v, -info.heading);
		
		return getAngle([0, 1], v1);
	}
	
	function rotate(v, ang) {
		return [(v[0] * Math.cos(ang)) - (v[1] * Math.sin(ang)), (v[0] * Math.sin(ang)) + (v[1] * Math.cos(ang))]; 
	}
	
	function getAngle(v1, v2) {
		var res = Math.acos( ((v1[0] * v2[0]) + (v1[1] * v2[1])) / (Math.sqrt(Math.pow(v1[0], 2) + Math.pow(v1[1], 2)) * Math.sqrt(Math.pow(v2[0], 2) + Math.pow(v2[1], 2))) );
		return (v2[0] < 0.0) ? (2 * Math.PI) - res : res;
	}
	
	// Get distance between player and selected npc (units arbitrary)
	function dist(info, mob) {
		var playPos = info.position.toDegrees();
		var mobPos = mob.getAttr();
		
		return Math.sqrt(Math.pow(playPos[0] - mobPos[0], 2), Math.pow(playPos[1], mobPos[1]));
	}
	
	// Generate new NPC according to player info (returned as new Mob object)
	function genMob(info) {
		var latDiff = Math.pow((Math.rand() % 100).toFloat() / (MAX_DIST * 100.0), 2);
		latDiff = latDiff * (Math.rand() % 100 > 50 ? 1.0 : -1.0);
		var longDiff = Math.pow((Math.rand() % 100).toFloat() / (MAX_DIST * 100.0), 2);
		longDiff = longDiff * (Math.rand() % 100 > 50 ? 1.0 : -1.0);
		var dir = (Math.rand() % 100).toFloat() / 100.0;
		var playPos = info.position.toDegrees();
		
		var mobPos = new [2];
		if (playPos[0] + latDiff > 90.0) {
			mobPos[0] = playPos[0] + latDiff - 180.0;
		}
		else if (playPos[0] + latDiff < -90.0) {
			mobPos[0] = playPos[0] + latDiff + 180.0;
		}
		else {
			mobPos[0] = playPos[0] + latDiff;
		}
		
		if (playPos[1] + longDiff > 180.0) {
			mobPos[1] = playPos[1] + longDiff - 360.0;
		}
		else if (playPos[1] + longDiff < -180.0) {
			mobPos[1] = playPos[1] + longDiff + 360.0;
		}
		else {
			mobPos[1] = playPos[1] + longDiff;
		}
		
		return new Mob(mobPos[0], mobPos[1], dir);
	}
	
	// Move the selected NPC according to its direction
	function setPos(mob) {
		var attr = mob.getAttr();
		var newLat = attr[0] + (Math.sin(attr[2] * 2 * Math.PI) * MOVE_SPEED);
		var newLong = attr[1] + (Math.cos(attr[2] * 2 * Math.PI) * MOVE_SPEED);
		
		if (newLat > 90.0) {
			newLat = newLat - 180.0;
		}
		else if (newLat < -90.0) {
			newLat = newLat + 180.0;
		}
		
		if (newLong > 180.0) {
			newLong = newLong - 360.0;
		}
		else if (newLong < -180.0) {
			newLong = newLong + 360.0;
		}
		
		var newDir = Math.rand() > 50 ? newDir + TURN_SPEED : newDir - TURN_SPEED;
		newDir = newDir > 1.0 ? 1.0 : newDir < 0.0 ? 0.0 : newDir;
		
		mob.setAttr([newLat, newLong, newDir]);
	}
	
	class Mob {
		hidden var lat, long, dir;
		
		function initialize(nLat, nLong, nDir) {
			lat = nLat;
			long = nLong;
			dir = nDir;
		}
		
		function getAttr() {
			return [lat, long, dir];
		}
		
		function setAttr(newAttr) {
			lat = newAttr[0];
			long = newAttr[1];
			dir = newAttr[2];
		}
		
		function toString() {
			return lat.toString() + " " + long.toString() + " " + dir.toString();
		}
	}
}