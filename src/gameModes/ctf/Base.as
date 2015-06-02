package gameModes.ctf
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Base extends DisplayStateLayerSprite
	{
		//----------------------------------------------------------------------
		// private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till den aktuella spelaren,
		 */
		private var _numPlayer:int;
		
		/**
		 * Grafisk representation av basen.
		 */
		private var _base:Sprite;
		
		/**
		 * Grafik för basen.
		 */
		private var _basegfx:MovieClip;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * @param numPlayer 			Referens till den specifika spelaren.
		 */
		public function Base(numPlayer:int)
		{
			super();
			_numPlayer = numPlayer;
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			initBase();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en instans av den grafiska representationen för
		 * basen.
		 */
		private function initBase():void {
			_base = new Sprite();
			
			if(_numPlayer == 0) {
				_base.graphics.beginFill(0x0000ff, 0);
				_basegfx = new Blue_Flag_Base_GFX;
				_basegfx.scaleX = 0.7;
				_basegfx.scaleY = 0.7;
				_basegfx.x = 20;
				_basegfx.y = 40;
				_basegfx.gotoAndStop(3);
			}
			if(_numPlayer == 1) {
				_base.graphics.beginFill(0xff0000, 0);
				_basegfx = new Red_Flag_Base_GFX;
				_basegfx.scaleX = 0.7;
				_basegfx.scaleY = 0.7;
				_basegfx.x = 70;
				_basegfx.y = 40;
				_basegfx.gotoAndStop(3);
			}
			
			_base.graphics.drawRect(0, 0, 90, 40);
			_base.graphics.endFill();
			
			addChild(_base);
			addChild(_basegfx);
		}
	}
}