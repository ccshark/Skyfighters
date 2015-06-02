package utils.elements
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import character.Player;
	
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.system.Session;
	
	public class Element extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till plattformens grafiska representation
		 */
		public var skin:MovieClip;
		
		/**
		 * Referens till spelarlagret.
		 */
		public var target:DisplayStateLayer;
		
		/**
		 * Referens till spelaren.
		 */
		public var player:Player;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Buffer för den grafiska representationen.
		 */
		private var _skinBuffer:Class;
		
		/**
		 * Representation i HUD'en av det 
		 * aktuella elementet.
		 */
		private var _hudElement:MovieClip;
		
		/**
		 * Text representation när en spelare tar ett element.
		 */
		private var _text:TextField;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @param skinc 			Grafik för det aktuella elementet.
		 */
		public function Element(skinc:Class)
		{
			_skinBuffer = skinc;
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			super.init();
			initSkin();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av objektet.
		 */
		public function initSkin():void {
			skin = new _skinBuffer();
			addChild(skin);
		}
		
		/**
		 * Överskrivs från dem underliggande klasserna.
		 */
		public function activate(_player:Player, target:DisplayStateLayer, numPlayer:int):void {

		}
		
		/**
		 * Aktiverar elementet under en intervall.
		 */
		public function elementTimer():void {
			Session.timer.create(7000, flashTimer);
		}
		
		/**
		 * Lägger ut en representation av vilket element spelaren
		 * har tagit i hud'en.
		 */
		public function setHudElement(element:Class, numPlayer:int):void {
			_hudElement = new element();
			_hudElement.scaleX = 0.5;
			_hudElement.scaleY = 0.5;
			
			if(numPlayer == 0) {
				_hudElement.x = 190;
				_hudElement.y = 70;
			}
			if(numPlayer == 1) {
				_hudElement.x = 600;
				_hudElement.y = 70;
			}
			
			target.addChild(_hudElement);
		}
		
		/**
		 * Skapar en representation för spelaren när ett element
		 * är aktivt.
		 */
		public function setElementEffect(elementText:String):void {
			_text = new TextField();
			
			var form:TextFormat = new TextFormat();
			form.color = 0x000000;
			form.size = 10;
			_text.embedFonts = true;
			form.font = "emulogic";
			
			_text.defaultTextFormat = form;
			_text.text = elementText;
			_text.x = player.x;
			_text.y = player.y;
			target.addChild(_text);
			Session.timer.create(1000, removeText);
		}
		
		/**
		 * Tar bort elementet från spelplanen
		 */
		public function removeSkin():void {
			removeChild(skin);
		}
		
		/**
		 * Aktiverar en flash effekt på elementet i HUD en.
		 */
		private function flashTimer():void {
			Session.effects.add(new Flicker(_hudElement, 2000));
			Session.timer.create(2000, removeElement);
		}
		
		/**
		 * Avaktiverar elementet och tar bort det
		 * från spelplanen, när tiden har gått ut.
		 */
		private function removeElement():void {
			player.damage = 25;
			if(!player.hasFlag) {
				player.speed = 4;
			}
			player._hit = true;
			target.removeChild(_hudElement);
		}
		
		/**
		 * Tar bort textelementet från spelplanen.
		 */
		private function removeText():void {
			target.removeChild(_text);
		}
		
		/**
		 * Gör så att spelaren blinkar när den
		 * har tagit immortal elementet.
		 */
		public function immortal():void {
			Session.effects.add(new Flicker(player, 9000));
		}
		
		/**
		 * Överskriver update metoden.
		 * Förflyttar textelementet uppåt.
		 */
		override public function update():void {
			if(_text) {
				_text.y -= 0.7;
			}
		}
	}
}