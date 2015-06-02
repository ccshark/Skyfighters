package utils
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import character.BulletManager;
	import character.Player;
	import character.PlayerManager;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	import utils.ammunition.Ammunition;
	import utils.elements.Earth;
	import utils.elements.Element;
	import utils.elements.Fire;
	import utils.elements.Wind;
	import utils.elements.Water;
	
	public class UtilManager
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Håller alla positioner som ett element
		 * kan placeras på.
		 */
		private var _elementSpawns:Array = new Array();
		
		/**
		 * Håller alla positioner som ammunitionen
		 * kan placeras på.
		 */
		private var _ammunitionSpawns:Array = new Array();
		
		/**
		 * Referens till elementobjektet.
		 */
		private var _element:Element;
		
		/**
		 * Referens till amunition.
		 */
		private var _ammunition:Ammunition;
		
		/**
		 * Referens till PlayerManager.
		 */
		private var _playerManager:PlayerManager;
		
		/**
		 * Referens till BulletManager.
		 */
		private var _bulletManager:BulletManager;
		
		/**
		 * Referens till den aktuella spelaren
		 */
		private var _numPlayer:int;
		
		/**
		 * Referens till den aktuella spelarens hitbox.
		 */
		private var _player:Sprite;
		
		
		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		
		/**
		 * Lager för spelarobjekt.
		 */
		protected var _target:DisplayStateLayer;
		
		[Embed(source="../../asset/sound/SFX_Element_Spawn.mp3")]
		public static const ADD_ELEMENT_SRC:Class;
		
		[Embed(source="../../asset/sound/SFX_Element_Pickup.mp3")]
		public static const PICKUP_ELEMENT_SRC:Class;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @param playerManager 				Referens till playerManager-klassen.
		 * @param target 						Lager för spelarobjekt.
		 * @param elementSpawns					Possition för vart de olika elementen kan placeras.
		 */
		public function UtilManager(playerManager:PlayerManager, target:DisplayStateLayer, elementSpawns:Array, bulletManager:BulletManager, ammunitionSpawns:Array)
		{
			_target = target;
			_playerManager = playerManager;
			_elementSpawns = elementSpawns;
			_ammunitionSpawns = ammunitionSpawns;
			_bulletManager = bulletManager;
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Slumpar fram ett värde för elementet, samt vilken position 
		 * elementet ska ha.
		 */
		public function addElement():void {
			var randomElement:int = Math.random() * 4;
			initElements(randomElement);
			
			var randomSpawn:int = Math.random() * 5;
			var spawn:Point = _elementSpawns[randomSpawn];
			
			_element.scaleX = 1;
			_element.scaleY = 1;
			_element.x = spawn.x;
			_element.y = spawn.y;
			
			_target.addChild(_element);
			
			//Sound
			Session.sound.soundChannel.sources.add("addElement", ADD_ELEMENT_SRC);
			var addElementSound:SoundObject = Session.sound.soundChannel.get("addElement"); 
			addElementSound.play();
			addElementSound.volume = 0.1;
		}
		
		/**
		 * Skapar en ny instans av ett element, beroende på värdet från
		 * numElement.
		 */
		public function initElements(numElement:int):void {
			switch (numElement) {
				case 0:
					var wind:Wind = new Wind();
					_element = wind;
					break;
				case 1:
					var fire:Fire = new Fire();
					_element = fire;
					break;
				case 2:
					var earth:Earth = new Earth();
					_element = earth;
					break;
				case 3:
					var water:Water = new Water();
					_element = water;
					break;
			}
		}
		
		/**
		 * Slumpar fram vilken possition ammunitionen ska placeras
		 * på och lägger ut den på spelplanen.
		 */
		public function addAmmunition():void {
			var randomSpawn:int = Math.random() * 5;
			var spawn:Point = _ammunitionSpawns[randomSpawn];
			_ammunition = new Ammunition();
			
			_ammunition.scaleX = 1;
			_ammunition.scaleY = 1;
			_ammunition.x = spawn.x;
			_ammunition.y = spawn.y;
			
			_target.addChild(_ammunition);
			
			//Sound
			Session.sound.soundChannel.sources.add("addElement", ADD_ELEMENT_SRC);
			var addElementSound:SoundObject = Session.sound.soundChannel.get("addElement"); 
			addElementSound.play();
			addElementSound.volume = 0.1;
		}
		
		/**
		 * Kollisionshantering för elementen, kontrollerar om en spelare
		 * interagerar med ett element.
		 */
		public function initCollision(numPlayer:int):void {
			_numPlayer = numPlayer;
			_player = _playerManager.players[numPlayer].bodyHitbox;
			var player:Player = _playerManager.players[numPlayer]
			
			//Hitcheck för element
			if(_player.hitTestObject(_element)) {
				//Sound
				Session.sound.soundChannel.sources.add("pickupElement", PICKUP_ELEMENT_SRC);
				var pickElementSound:SoundObject = Session.sound.soundChannel.get("pickupElement"); 
				pickElementSound.play();
				pickElementSound.volume = 0.2;
				
				_element.activate(player, _target, numPlayer);
				Session.timer.add(new Timer(10000, addElement));
			}
			
			//Hitcheck för ammunition
			if(_player.hitTestObject(_ammunition)) {
				//Sound
				Session.sound.soundChannel.sources.add("pickupElement", PICKUP_ELEMENT_SRC);
				var pickAmmunitionSound:SoundObject = Session.sound.soundChannel.get("pickupElement"); 
				pickAmmunitionSound.play();
				pickAmmunitionSound.volume = 0.2;
				
				_ammunition.activate(_bulletManager, _target, numPlayer);
				Session.timer.add(new Timer(20000, addAmmunition));
			}
			
		}
	}
}

