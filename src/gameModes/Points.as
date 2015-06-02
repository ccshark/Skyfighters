package gameModes
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import character.Player;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Points extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Vector som håller alla spelarna.
		 */
		private var _players:Vector.<Player>;
		
		/**
		 * Referens till spelaren.
		 */
		private var _player:Player;
		
		/**
		 * Spelarens gamla hälsa.
		 */
		private var _oldScore:int;
		
		/**
		 * Textelement som presenterar poängen.
		 */
		private var _p:TextField;
		
		/**
		 * Mätare för den totala poängen.
		 */
		private var _score:int = 0;
		
		//Font
		[Embed(source="../../asset/fonts/emulogic.ttf", fontName = "emulogic", mimeType = "application/x-font", embedAsCFF="false")]
		private var visitor:Class;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function Points(numPlayers:int,  players:Vector.<Player>) {
			_players = players;
			_player = _players[numPlayers];
			_oldScore = _player.wins;
		}
		
		/**
		 * Skriver över init metoden.
		 */
		override public function init():void {
			super.init();
			initPointBar();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Överskriver update metoden.
		 * 
		 * Uppdaterar poängen.
		 */
		override public function update():void {
			super.update();
			updateScore();
		}
		
		/**
		 * Kontrollerar om spelarens hälsa förändras
		 * och ändrar storleken på hpmätaren vid förändring.
		 */
		public function updateScore():void {
			if(_player.wins > _oldScore) {
				_score = _player.wins;
				_oldScore = _score;
				_p.text = _score.toString();
			}
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar Hp mätare för spelaren.
		 */
		private function initPointBar():void {
			_p = new TextField();
			
			var form:TextFormat = new TextFormat();
			form.color = 0x000000;
			form.size = 16;
			_p.embedFonts = true;
			form.font = "emulogic";
			
			_p.defaultTextFormat = form;
			_p.text = _score.toString();
			addChild(_p);
		}
	}
}