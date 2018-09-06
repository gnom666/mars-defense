package
{
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", width="700", height="500", backgroudColor="0x333333")]
	public class MarsDefense extends Sprite
	{
		private var stats:Stats;
		private var myStarling:Starling;
		
		public function MarsDefense()
		{
			trace("algo pasa");
			stats = new Stats();
			this.addChild(stats);
			
			myStarling = new Starling(Game, stage);
			myStarling.antiAliasing = 1;
			myStarling.start();
		}
	}
}