package gameModes.maps
{
	public class Map
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Array med en tilemap som används för att 
		 * placera ut alla tiles.
		 */
		public var data:Array;
		
		/**
		 * Array med spawnpunkterna för alla element
		 */
		public var elements:Array;
		
		/**
		 * Array med spawnpunkterna för ammunition.
		 */
		public var ammunition:Array;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function Map()
		{
			
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Städar upp klassen.
		 */
		public function dispose():void {
			for (var i:int = 0; i < data.length; i++) {
				data[i] = null;
			}
		}
	}
}