package gameModes
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import flash.display.Sprite;
	import character.PlayerManager;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class PointsManager
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till PlayerManager.
		 */
		private var _playerManager:PlayerManager;
		
		/**
		 * Nummer för den aktuella spelaren.
		 */
		private var _numPlayer:int;
		
		/**
		 * Referens till motspelarens flagga.
		 */
		private var _targetFlag:Sprite;
		
		/**
		 * Referens till den grafiska representationen av spelaren.
		 */
		private var _player:Sprite;
		
		/**
		 * Håller poängen för båda spelarna.
		 */
		public var _points:vector.<Points> = new Vector.<Points>;
		
		
		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		
		/**
		 * Lager för spelarobjekt.
		 */
		protected var _target:DisplayStateLayer;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @param playerManager 				Referens till playerManager-klassen.
		 * @param target 						Lager för spelarobjekt
		 */
		public function PointsManager(playerManager:PlayerManager, target:DisplayStateLayer)
		{
			_target = target;
			_playerManager = playerManager
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------

		/**
		 * Skapar en ny instans av Flag-klassen och placerar 
		 * den på den specifika spelarens bas.
		 */
		public function addPoints(numPlayer:int):void {
			var points:Points = new Points(numPlayer, _playerManager.players);
			
			if(numPlayer == 0) {
				points.x = 215;
				points.y = 45;
			}
			if(numPlayer == 1) {
				points.x = 570;
				points.y = 45;
			}
			points.scaleX = 1;
			points.scaleY = 1;
			
			_points.push(points);
			_target.addChild(points);
		}
	}
}