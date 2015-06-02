package utils.elements
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import character.Player;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class Wind extends Element
	{
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * Skickar med grafiken för elementet
		 * till superklassen.
		 */
		public function Wind()
		{
			super(Potions_Speed_Rotate_GFX);
		}
		
		/**
		 * Överskriver superklassens activate metod.
		 * Uppdaterar värden i superklassen till player.
		 */
		override public function activate(currentPlayer:Player, tag:DisplayStateLayer, numPlayer:int):void {
			target = tag;
			player = currentPlayer;
			if(player.hasFlag) {
				player.speed = 4;
			} else {
				player.speed = 5;
			}
			
			removeSkin();
			elementTimer();
			setHudElement(Potions_Speed_Idle_GFX, numPlayer);
			setElementEffect("Speed");
		}
	}
}

