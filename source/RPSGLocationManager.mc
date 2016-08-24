using Toybox.Position as Position;
using Toybox.Math as Math;
using Toybox.System as System;

class RPSGLocationManager {
	hidden const MAX_DIST = 10.0;		// Max distance that an NPC can spawn from the player, which will be 1 / MAX_DIST degrees (of latitude or longitude)
	hidden const MOVE_SPEED = 0.001;	// Determines the distance that an NPC will move on each update
	hidden const TURN_SPEED = 0.0006;	// Determines the speed at which each NPC will turn as it moves

	hidden var mobs = new [3];
	
	function initialize() {
		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, :posUpdate);
	}
	
	function posUpdate(info) {
		for (i = 0; i < 3; i++) {
			if (mobs[i] == null || (dist(info, mobs[i]) > 1.0 / MAX_DIST)) {
				mobs[i] = genMob(info);
			}
			else {
				setPos(mobs[i]);
			}
			System.println(i.toString() + ": " + mobs[i].toString());
		}
	}
	
	function dist(info, mob) {
		var playPos = info.position.toDegrees();
		var mobPos = mob.getAttr();
		
		return Math.sqrt(Math.pow(playPos[0] - mobPos[0], 2), Math.pow(playPos[1], mobPos[1]));
	}
	
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