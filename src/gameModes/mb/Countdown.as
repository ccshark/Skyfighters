package gameModes.mb
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import character.Player;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	public class Countdown extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------

		/**
		 * Beräkning för markörens possition
		 */
		public var counter:int = 0;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Grafik för den röda boxen.
		 */
		private var _redBox:Sprite;
		
		/**
		 * Grafik för den blåa boxen.
		 */
		private var _blueBox:Sprite;
		
		/**
		 * Grafik för markören.
		 */
		private var _marker:MovieClip;
		
		/**
		 * Kontroller för nedräkningen.
		 */
		private var _counted:Boolean = false;
		
		/**
		 * Nummer för den aktuella spelaren som 
		 * håller markören.
		 */
		private var _numPlayer:int;
		
		
		//----------------------------------------------------------------------
		// Konstruktor
		//----------------------------------------------------------------------
		
		public function Countdown(players:Vector.<Player>) {

		}
		
		/**
		 * Skriver över init metoden.
		 */
		override public function init():void {
			super.init();
			initCountBox();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Kontrollerar om counter parametern är större än 0.
		 */
		public function startCounter(numPlayer:int):void {
			_numPlayer = numPlayer;
			if(!_counted) {
				countdown();
			}
		}
		
		/**
		 * Återställer counter parametern när rundan är
		 * avslutad och uppdaterar possitionen för markören
		 */
		public function resetRound():void {
			counter = 0;
			_marker.x = counter;
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar Hp mätare för spelaren.
		 */
		private function initCountBox():void {
			_blueBox  = new Sprite();
			_blueBox.graphics.beginFill(0x0000ff);
			_blueBox.graphics.drawRect(0, 0, 60, 10);
			_blueBox.graphics.endFill();
			_blueBox.x = -60;
			
			addChild(_blueBox);
			
			_redBox  = new Sprite();
			_redBox.graphics.beginFill(0xff0000);
			_redBox.graphics.drawRect(0, 0, 60, 10);
			_redBox.graphics.endFill();
			
			addChild(_redBox);
			
			_marker = new Madball_Object_Base_GFX;
			_marker.scaleX = 0.5;
			_marker.scaleY = 0.5;
			
			addChild(_marker);	
		}
		
		/**
		 * Minskar counter parametern om kontrollern för
		 * counter är satt till false, startar timer för att sätta den 
		 * till false.
		 */
		private function countdown():void {
			if(!_counted) {
				if(_numPlayer == 0) {
					counter--;
				}
				if(_numPlayer == 1) {
					counter++;
				}
				_counted = true;
				_marker.x = counter;
				Session.timer.add(new Timer(250, setCountdown));
			}
		}
		
		/**
		 * Aktiverar så att tiden kan räknas ner efter 1 sekund.
		 */
		private function setCountdown():void {
			_counted = false;
		}
	}
}