package gameModes.maps {
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import flash.geom.Point;
	
	
	public class MapMB extends Map {
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * Tilemap över den aktuella banan.
		 * spawnpunkter för elementen.
		 * spawnpunkter för ammunition.
		 */
		public function MapMB() {
			super();
			data = new Array(
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,7,8,7,9,8,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,10,12,10,11,12,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,11,10,12,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,
				0,7,8,9,7,8,9,0,0,0,0,0,0,0,0,0,0,0,7,8,9,7,8,9,0,
				0,10,11,12,10,11,12,0,0,0,0,0,0,0,0,0,0,0,11,12,10,11,12,11,0,
				0,0,0,0,0,0,0,0,7,8,0,0,0,0,0,9,8,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				1,3,2,0,0,0,0,0,0,0,0,2,1,3,0,0,0,0,0,0,0,0,1,3,2,
				5,0,0,0,1,2,3,0,0,0,1,0,0,0,2,0,0,0,1,3,2,0,0,0,4,
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
				1,2,3,0,0,0,3,2,1,0,2,1,0,3,2,0,3,2,1,0,0,0,1,3,2
			);
			
			elements = new Array(
				new Point(380, 345),
				new Point(750, 345),
				new Point(50, 345),
				new Point(510, 535),
				new Point(260, 535)
			);
			
			ammunition = new Array(
				new Point(260, 250),
				new Point(490, 250),
				new Point(385, 65),
				new Point(40, 535),
				new Point(720, 535)
			);
		}
	}
}


