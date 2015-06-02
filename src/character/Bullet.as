package character
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import flash.display.MovieClip;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	
	public class Bullet extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till plattformens grafiska representation
		 */
		public var skin:MovieClip;
		
		/**
		 * Kontroller för att se om kulan är aktiv.
		 */
		public var activeBullet:Boolean = false;
		
		/**
		 * Kontroller för att se om kulan går åt 
		 * vänster eller höger.
		 */
		public var bulletLeft:Boolean;
		
		/**
		 * Kulans hastighet.
		 */
		public var bulletSpeed:int = 3;
		
	
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
		 * 
		 * @param target 			Referens till kartlagret.
		 */
		public function Bullet(numPlayer:int)
		{
			super();
			_numPlayer = numPlayer;
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			super.init();
			initBullet();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av objektet.
		 */
		private function initBullet():void {
			if(_numPlayer == 0) {
				skin = new P2_Weapon_Axe_GFX;
			}
			if(_numPlayer == 1) {
				skin = new P1_Weapon_ShurikenGFX;
			}
		}
		
		/**
		 * Kallas på från entity, lägger ut objektet på
		 * spelplanen.
		 */
		public function shootBullet():void {
			addChild(skin);
		}
		
		/**
		 * Kallas på från entity, tar bort objektet
		 * från spelplanen.
		 */
		public function removeBullet():void {
			removeChild(skin);
		}
		
		/**
		 * Rensar upp alla bullet-objekt.
		 */
		override public function dispose():void {
			if(skin.parent) {
				removeChild(skin);
			}
			skin = null;
		}
	}
}

