package utils.ammunition
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import character.BulletManager;
	import character.Player;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Ammunition extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till plattformens grafiska representation
		 */
		public var skin:MovieClip;
		
		/**
		 * Referens till den aktuella player-klassen.
		 */
		public var player:Player;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Representation i HUD'en av det 
		 * aktuella elementet.
		 */
		private var _hudElement:MovieClip;
		
		/**
		 * Referens till BulletManager-klassen.
		 */
		private var _bulletManager:BulletManager;
		
		/**
		 * Refens till lager som skotten kan appliceras på.
		 */
		public var _target:DisplayStateLayer;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function Ammunition()
		{
			
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			super.init();
			initSkin();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		
		/**
		 * Skapar en ny instans av objektet.
		 */
		public function initSkin():void {
			skin = new HUD_Weapon_GFX();
			addChild(skin);
		}
		
		/**
		 * Överskrivs från dem underliggande klasserna.
		 */
		public function activate(bulletManager:BulletManager, target:DisplayStateLayer, numPlayer:int):void {
			target = target;
			_bulletManager = bulletManager;
			bulletManager.addBullets(numPlayer);
			removeSkin();
		}
		
		/**
		 * Tar bort elementet från spelplanen
		 */
		public function removeSkin():void {
			removeChild(skin);
		}
	}
}

