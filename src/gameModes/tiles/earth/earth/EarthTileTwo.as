package gameModes.tiles.earth.earth
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	
	public class EarthTileTwo extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till kartlagret.
		 */
		private var _target:DisplayStateLayer;
		
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till plattformens grafiska representation
		 */
		public var _skin:MovieClip;
		
		
		//----------------------------------------------------------------------
		// Konstructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * @param target 			Referens till kartlagret.
		 */
		public function EarthTileTwo(target:DisplayStateLayer)
		{
			super();
			_target = target;
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			super.init();
			initTile();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av bitmap-objectet och
		 * lägger ut den på lagret.
		 */
		private function initTile():void {
			_skin = new Tile_Ground_Base_GFX;
			addChild(_skin);
			_skin.gotoAndStop(5);
		}
		
		/**
		 * Rensar upp alla tile-objekt.
		 */
		override public function dispose():void {
			if(_skin.parent) {
				removeChild(_skin);
			}
			_skin = null;
		}
	}
}

