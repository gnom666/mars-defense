package
{
	public class Constants
	{
		public static const STATE_IDLE:String = "idle";
		public static const STATE_FLYING:String = "flying";
		public static const STATE_OVER:String = "over";
		public static const STATE_PAUSED:String = "paused";
		public static var MIN_SPEED:Number = 290;
		public static const FIX_MIN_SPEED:Number = 290;
		public static var TIME_TO_SHOOT:Number = 400;
		public static const FIX_CADENSE:Number = 400;
		public static const TIME_TO_SHOW:Number = 10;
		public static const TIME_TO_GAMEOVER:Number = 30;
		public static const MAX_HIT:Number = 1;
		public static const ITEM_LIFE:int=1;
		public static const ITEM_PHANTOM:int=3;
		public static const ITEM_STAR:int=2;
		public static const ITEM_DESTROYER:int=7;
		public static const ITEM_POINTS_10:int=4;
		public static const ITEM_POINTS_50:int=5;
		public static const ITEM_POINTS_100:int=6;
		public static const ITEM_KILL:int=8;
		public static const ITEM_INVISIBLE:int=9;
		public static const ITEM_LOCK_X:int=10;
		public static const ITEM_LOCK_XY:int=11;
		public static const ITEM_LOW_BAT:int=13;
		public static const ITEM_LOW_FUEL:int=12;
		public static const ITEM_FIREWALL:int=14;
		public static const ITEM_FULL_BAT:int=15;
		public static const ITEM_FULL_FUEL:int=16;
		public static const POWERS_TIME:Number = 6000;
		public static var XMOV_DELAY:Number = 0.1;
		public static var YMOV_DELAY:Number = 0.3;
		public static const FIX_BG_SPEED:Number = 0;
		
		public static function init ():void {
			XMOV_DELAY = 0.1;
			YMOV_DELAY = 0.3;
			TIME_TO_SHOOT = FIX_CADENSE;
			MIN_SPEED = FIX_MIN_SPEED;
		}
	}
	
	
}