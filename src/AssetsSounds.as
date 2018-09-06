package
{
	import flash.utils.Dictionary;

	public class AssetsSounds
	{
		[Embed(source="..\\media\\sounds\\shoot.mp3")]
		public static var sfxShoot:Class;
		
		[Embed(source="..\\media\\sounds\\blowed.mp3")]
		public static var sfxBlowed:Class;
		
		[Embed(source="..\\media\\sounds\\bgSound1.mp3")]
		public static var sfxBGSound1:Class;
		
		[Embed(source="..\\media\\sounds\\bgSound2.mp3")]
		public static var sfxBGSound2:Class;
		
		[Embed(source="..\\media\\sounds\\item_point.mp3")]
		public static var sfxPoints:Class;
		
		[Embed(source="..\\media\\sounds\\item_good.mp3")]
		public static var sfxGood:Class;
		
		[Embed(source="..\\media\\sounds\\item_bad.mp3")]
		public static var sfxBad:Class;
		
		[Embed(source="..\\media\\sounds\\item_ray.mp3")]
		public static var sfxRay:Class;
		
		[Embed(source="..\\media\\sounds\\power_nobounds.mp3")]
		public static var sfxPowerNoBounds:Class;
		
		[Embed(source="..\\media\\sounds\\power_nodamaged.mp3")]
		public static var sfxPowerNoDamaged:Class;
		
		public static var gameVolume:int = 2;
		
		public static var soundManager:SoundManager = new SoundManager();
		
		soundManager.addSound("shoot", new AssetsSounds.sfxShoot());
		soundManager.addSound("blowed", new AssetsSounds.sfxBlowed());
		soundManager.addSound("bg1", new AssetsSounds.sfxBGSound1());
		soundManager.addSound("bg2", new AssetsSounds.sfxBGSound2());
		soundManager.addSound("points", new AssetsSounds.sfxPoints());
		soundManager.addSound("good", new AssetsSounds.sfxGood());
		soundManager.addSound("bad", new AssetsSounds.sfxBad());
		soundManager.addSound("ray", new AssetsSounds.sfxRay());
		soundManager.addSound("noBounds", new AssetsSounds.sfxPowerNoBounds());
		soundManager.addSound("noDamaged", new AssetsSounds.sfxPowerNoDamaged());
		
		public static function setVolume():void
		{
			var sounds:Dictionary = AssetsSounds.soundManager.currPlayingSounds;
			var id:String = "";
			switch (gameVolume) {
				case 0: {
					for (id in sounds) {
						AssetsSounds.soundManager.tweenVolume(id, 0, 1);
					}
					break;
				}
				case 1: {
					for (id in sounds) {
						AssetsSounds.soundManager.tweenVolume(id, 0.3, 1);
					}
					break;
				}
				case 2: {
					for (id in sounds) {
						AssetsSounds.soundManager.tweenVolume(id, 1, 1);
					}
					break;
				}
			}
		}
		
		public static function getVolume():Number
		{
			var vol:Number = 0;
			switch (gameVolume) {
				case 0: {
					vol = 0;
					break;
				}
				case 1: {
					vol = 0.3;
					break;
				}
				case 2: {
					vol = 1;
					break;
				}					
			}
			return vol;
		}
	}
}