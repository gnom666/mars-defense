package
{
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	
	import starling.core.starling_internal;
	import starling.display.Sprite;

	public class Utils extends Sprite
	{
		public function getX(x:Number):Number
		{
			return (x / 800) * stage.stageWidth;
		}
	}
}