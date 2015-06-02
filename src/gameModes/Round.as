package gameModes
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Round extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till textfältet.
		 */
		public var graph:TextField;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Den aktuella spelaren.
		 */
		private var _roundCount:int;
		
		/**
		 * Grafisk representation för flaggan.
		 */
		private var round:String;
		
		/**
		 * Font
		 */
		[Embed(source="../../asset/fonts/visitor2.ttf", fontName = "visitor", mimeType = "application/x-font", embedAsCFF="false")]
		private var visitor:Class;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * @para numPlayer 			Referens till den specifika spelaren.
		 */
		public function Round(roundCount:int)
		{
			super();
			_roundCount = roundCount;
		}
		
		/**
		 * Överskriver init metoden.
		 */
		override public function init():void {
			initRound();
			initGraphics();
		}
		
		
		//----------------------------------------------------------------------
		// private properties
		//----------------------------------------------------------------------
		
		/**
		 * Sätter texten för textfälltet beroende på vilken
		 * runda spelarna befinner sig på.
		 */
		private function initRound():void {
			switch (_roundCount) {
				case 0:
					round = "Round one!";
					break;
				case 1:
					round = "Round two!";
					break;
				case 2:
					round = "Final Round!";
					break;
				case 3:
					round = "Round four!";
					break;
				case 4:
					round = "Round five!";
					break;
			}
		}
		
		/**
		 * Skapar ett textfält som läggs ut på
		 * spelarlagret.
		 */
		private function initGraphics():void {
			graph = new TextField();
			
			var form:TextFormat = new TextFormat();
			form.color = 0x000000;
			form.size = 70;
			graph.embedFonts = true;
			form.font = "visitor";
			
			graph.defaultTextFormat = form;
			graph.text = round;
			graph.width = 400;
			
			addChild(graph);
		}
	}
}

