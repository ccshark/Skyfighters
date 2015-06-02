package utils.elements
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import character.Player;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class Earth extends Element
	{
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * Skickar med grafiken för elementet
		 * till superklassen.
		 */
		public function Earth()
		{
			super(Potions_Shield_Rotate_GFX);
		}
		
		/**
		 * Överskriver superklassens activate metod.
		 * Uppdaterar värden i superklassen till player.
		 */
		override public function activate(currentPlayer:Player, tag:DisplayStateLayer, numPlayer:int):void {
			target = tag;
			player = currentPlayer;
			player._hit = false;
			player.activeElement = true;
			removeSkin();
			elementTimer();
			setHudElement(Potions_Shield_Idle_GFX, numPlayer);
			setElementEffect("Immortal");
			immortal();
		}
	}
}

