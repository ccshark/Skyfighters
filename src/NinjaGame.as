/**
 * Titel: 			Skyfighters
 * 
 * Version:			1.0 			
 * Programkod: 		Gustav Larsson
 * Grafik: 			Robin Frejd
 * Datum: 			2015
 */

package
{
	import flash.geom.Point;
	import se.lnu.stickossdk.system.Engine;
	import state.IntroState;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	
	public class NinjaGame extends Engine
	{
		public function NinjaGame()
		{
			
		}
		
		override public function setup():void {
			initId = 21;
			initSize= new Point(800, 600);
			initScale = new Point(1, 1);
			initDisplayState = IntroState;
			initBackgroundColor = 0x000000;
			initDebugger = true;
		}
	}
}