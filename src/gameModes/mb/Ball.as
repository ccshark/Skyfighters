package gameModes.mb
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Ball extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Den aktuella spelaren.
		 */
		private var _numPlayer:int;
		
		/**
		 * Grafisk representation för flaggan.
		 */
		private var _ball:MovieClip;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * @para numPlayer 			Referens till den specifika spelaren.
		 */
		public function Ball()
		{
			super();
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			initFlag();
		}
		
		
		//----------------------------------------------------------------------
		// private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av den grafiska representationen
		 * för flaggan.
		 */
		private function initFlag():void {
			_ball = new Madball_Object_Base_GFX;
			addChild(_ball);
		}
	}
}

