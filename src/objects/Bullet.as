package objects
{
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class Bullet extends Sprite
	{
		public var bulletAnimation:PDParticleSystem;
		private var _bulletBounds:Rectangle;
		private var _xPos:int;
		private var _yPos:int;
		
		public function Bullet()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get bulletBounds():Rectangle
		{
			return _bulletBounds;
		}

		public function set bulletBounds(value:Rectangle):void
		{
			_bulletBounds = value;
		}

		public function get xPos():int
		{
			return _xPos;
		}

		public function set xPos(value:int):void
		{
			_xPos = value;
			this.x = _xPos;
		}

		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);	
			createBulletArt();
			_bulletBounds = new Rectangle(this.x-10, this.y-10, 30, 30);
			
		}
		
		private function createBulletArt():void
		{
			bulletAnimation = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLBullet()), Texture.fromBitmap(new AssetsParticles.ParticleTextureBullet()));
			bulletAnimation.x = 0;
			bulletAnimation.y = 0;
			bulletAnimation.scaleY = stage.stageHeight / 600;
			bulletAnimation.scaleX = bulletAnimation.scaleY;
			Starling.juggler.add(bulletAnimation);
			this.addChild(bulletAnimation);
			bulletAnimation.start();
		}
		
		public function updateBounds():void {
			_bulletBounds.setTo(this.x-10, this.y-10, 30, 30);
		}
		
		public function destroy():void {
			bulletAnimation.stop();
		}
	}
}