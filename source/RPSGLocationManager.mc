using Toybox.Position as Position;
using Toybox.System as System;

class RPSGLocationManager {
	hidden const MAX_DIST = 1.0;

	hidden var mobs = new [3];
	
	function initialize() {
		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, :posUpdate);
	}
	
	function posUpdate(info) {
		for (i = 0; i < 3; i++) {
			if (mobs[i] == null) {
				
			}
		}
	}
	
	function genMob() {
		
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
	}
}