package gameModes.ctf
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Flag extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Grafisk representation för flaggan.
		 */
		public var flag:MovieClip;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Den aktuella spelaren.
		 */
		private var _numPlayer:int;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * @para numPlayer 			Referens till den specifika spelaren.
		 */
		public function Flag(numPlayer:int)
		{
			super();
			_numPlayer = numPlayer;
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			initFlag();
		}
		
		
		//----------------------------------------------------------------------
		// private properties
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av den grafiska representationen
		 * för flaggan.
		 */
		private function initFlag():void {
			if(_numPlayer == 0) {
				flag = new Blue_Flag_Base_GFX;
				flag.gotoAndStop(2);
			}
			if(_numPlayer == 1) {
				flag = new Red_Flag_Base_GFX;
				flag.gotoAndStop(2);
			}
			addChild(flag);
		}
	}
}