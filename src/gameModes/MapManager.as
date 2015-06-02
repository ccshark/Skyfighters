package gameModes
{	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.DisplayObject;
	import character.Player;
	import character.PlayerManager;
	import gameModes.maps.Map;
	import gameModes.tiles.earth.earth.EarthTileOne;
	import gameModes.tiles.earth.earth.EarthTileThree;
	import gameModes.tiles.earth.earth.EarthTileTwo;
	import gameModes.tiles.earth.grass.GrassEarthTileOne;
	import gameModes.tiles.earth.grass.GrassEarthTileThree;
	import gameModes.tiles.earth.grass.GrassEarthTileTwo;
	import gameModes.tiles.stone.grass.GrassStoneTileOne;
	import gameModes.tiles.stone.grass.GrassStoneTileThree;
	import gameModes.tiles.stone.grass.GrassStoneTileTwo;
	import gameModes.tiles.stone.stone.StoneTileOne;
	import gameModes.tiles.stone.stone.StoneTileThree;
	import gameModes.tiles.stone.stone.StoneTileTwo;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	
	public class MapManager  
	{
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till layerMap i GameState klassen
		 */
		public var target:DisplayStateLayer;
		
		/**
		 * Referens till PlayerManager klassen.
		 */
		public var players:PlayerManager;
		
		/**
		 * Array med data för possitionen för varje tile
		 */
		public var lvlArray:Array = new Array();
		
		/**
		 * Array med spawnpoints för alla element.
		 */
		public var elements:Array;
		
		/**
		 * Array med spawnpoints för ammunition.
		 */
		public var ammunition:Array;
		
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till den aktuella kartan.
		 * Beskriver vilka tiles som ska skapas.
		 */
		private var _currentMap:Map;
		
		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		
		/**
		 * Array som inehåller alla tiles som är skapade.
		 * Används för kollisionshantering.
		 */
		protected var _tile:Array = new Array();
		
		
		/**
		 * Referens till den aktuella spelaren.
		 * Används för kollisionshantering.
		 */
		protected var _playerTarget:Player;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @param targetLayer 			Displaylayer för att placera tiles.
		 * @param playerManager			Referens til PlayerManager-klassen.
		 */
		public function MapManager(targetLayer:DisplayStateLayer, playerManager:PlayerManager)
		{
			target = targetLayer;
			players = playerManager;
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Tar emot klassen för den aktuella kartan.
		 */
		public function initMap(map:Map):void {
			_currentMap = map;
			elements = _currentMap.elements;
			ammunition = _currentMap.ammunition;
			createTiles();
		}
		
		/**
		 * Skapar en ny instans av ett tileobjekt för det aktuella
		 * nummret i Map-klassen och placerar det på displaylagret.
		 */
		public function createTiles():void {
			var row:int = 0;
			var lvlColumns:int = Math.ceil(_currentMap.data.length/19);
			
			for(var i:int = 0; i < _currentMap.data.length; i++){
				if(i/lvlColumns == int(i/lvlColumns)){
					row ++;
				}
				if(_currentMap.data[i] != 0){
					
					var tile:DisplayObject;
					
					switch (_currentMap.data[i]) {
						case 1:
							tile = new GrassEarthTileOne(target);
							break
						case 2:
							tile = new GrassEarthTileTwo(target);
							break
						case 3:
							tile = new GrassEarthTileThree(target);
							break
						case 4:
							tile = new EarthTileOne(target);
							break
						case 5:
							tile = new EarthTileTwo(target);
							break
						case 6:
							tile = new EarthTileThree(target);
							break
						case 7:
							tile = new GrassStoneTileOne(target);
							break
						case 8:
							tile = new GrassStoneTileTwo(target);
							break
						case 9:
							tile = new GrassStoneTileThree(target);
							break
						case 10:
							tile = new StoneTileOne(target);
							break
						case 11:
							tile = new StoneTileTwo(target);
							break
						case 12:
							tile = new StoneTileThree(target);
							break
					}
					tile.x = (i-(row-1)*lvlColumns)*32;
					tile.y = (row-1)*32;
					_tile.push(tile);
					target.addChild(tile);
				}
			}
			row = 0;
		}
		
		
		/**
		 * Startar kollisionshanteringen.
		 * Kollar om spelaren kolliderar med en plattform.
		 */
		public function initCollision(player:int):void {
				_playerTarget = players.players[player];
			
			//Loop för att kolla vilken punkt på spelaren som träffar en tile
			for(var j:int = 0; j < _tile.length; j++) {
				var hitBlock:DisplayObject = _tile[j];
				if(hitBlock.hitTestPoint(_playerTarget.x + _playerTarget.botHitPoint.x, _playerTarget.y + _playerTarget.botHitPoint.y)) {
					_playerTarget.botHit(hitBlock);
				}
				if(hitBlock.hitTestPoint(_playerTarget.x + _playerTarget.topHitPoint.x, _playerTarget.y + _playerTarget.topHitPoint.y)) {
					_playerTarget.topHit(hitBlock);
				}
				if(hitBlock.hitTestPoint(_playerTarget.x + _playerTarget.leftHitPoint.x, _playerTarget.y + _playerTarget.leftHitPoint.y)) {
					_playerTarget.leftHit(hitBlock);
				}
				if(hitBlock.hitTestPoint(_playerTarget.x + _playerTarget.rightHitPoint.x, _playerTarget.y + _playerTarget.rightHitPoint.y)) {
					_playerTarget.rightHit(hitBlock);
				}
			}
			//Aktiverar gravitation om spelaren inte träffar någon tile
			_playerTarget.gravity();
		}
		
		/**
		 * Städar upp klassen.
		 */
		public function dispose():void {
			
			for (var i:int = 0; i < _tile.length; i++) {
				if(_tile[i].parent != null) {
					_tile[i].parent.removeChild(_tile[i]);
				}
				_tile[i].dispose();
				_tile[i] = null;
				_tile.splice(i, 1);
			}
			_tile.length = 0;
		}
	}
}

