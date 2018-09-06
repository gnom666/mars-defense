package objects
{
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Hero extends Sprite
	{
		
		private var _heroArt:MovieClip;
		//private var fire:Image;
		public var particleFire:PDParticleSystem;
		public var particleItem:PDParticleSystem;
		private var _heroBounds:Rectangle;
		//private var _hitCount:Number;
		private var _lifeCount:Number;
		private var _noBounds:Boolean;
		private var _timePrevious:Number; // No Bounds
		private var _noDamaged:Boolean;
		private var _noVisible:Boolean;
		private var _noXMov:Boolean;
		private var _noXYMov:Boolean;
		private var _noBat:Boolean;
		private var _noFuel:Boolean;
		private var _firewall:Boolean;
		private var _fullBat:Boolean;
		private var _fullFuel:Boolean;
		private var _timePreviousND:Number; // No Damage
		private var _timePreviousNV:Number; // Not Visible
		private var _timePreviousNX:Number; // No X Mov
		private var _timePreviousNXY:Number; // No XY Mov
		private var _timePreviousLB:Number; // Low Bat
		private var _timePreviousLF:Number; // Low Fuel
		private var _timePreviousFW:Number; // Firewall
		private var _timePreviousFB:Number; // Full Bat
		private var _timePreviousFF:Number; // Full Fuel
		
		
		
		public function Hero()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get fullFuel():Boolean
		{
			return _fullFuel;
		}

		public function set fullFuel(value:Boolean):void
		{
			_fullFuel = value;
		}

		public function get timePreviousFF():Number
		{
			return _timePreviousFF;
		}

		public function set timePreviousFF(value:Number):void
		{
			_timePreviousFF = value;
		}

		public function get timePreviousFB():Number
		{
			return _timePreviousFB;
		}

		public function set timePreviousFB(value:Number):void
		{
			_timePreviousFB = value;
		}

		public function get fullBat():Boolean
		{
			return _fullBat;
		}

		public function set fullBat(value:Boolean):void
		{
			_fullBat = value;
		}

		public function get timePreviousFW():Number
		{
			return _timePreviousFW;
		}

		public function set timePreviousFW(value:Number):void
		{
			_timePreviousFW = value;
		}

		public function get firewall():Boolean
		{
			return _firewall;
		}

		public function set firewall(value:Boolean):void
		{
			_firewall = value;
		}

		public function get timePreviousLF():Number
		{
			return _timePreviousLF;
		}

		public function set timePreviousLF(value:Number):void
		{
			_timePreviousLF = value;
		}

		public function get timePreviousLB():Number
		{
			return _timePreviousLB;
		}

		public function set timePreviousLB(value:Number):void
		{
			_timePreviousLB = value;
		}

		public function get timePreviousNXY():Number
		{
			return _timePreviousNXY;
		}

		public function set timePreviousNXY(value:Number):void
		{
			_timePreviousNXY = value;
		}

		public function get timePreviousNX():Number
		{
			return _timePreviousNX;
		}

		public function set timePreviousNX(value:Number):void
		{
			_timePreviousNX = value;
		}

		public function get noFuel():Boolean
		{
			return _noFuel;
		}

		public function set noFuel(value:Boolean):void
		{
			_noFuel = value;
		}

		public function get noBat():Boolean
		{
			return _noBat;
		}

		public function set noBat(value:Boolean):void
		{
			_noBat = value;
		}

		public function get noXYMov():Boolean
		{
			return _noXYMov;
		}

		public function set noXYMov(value:Boolean):void
		{
			_noXYMov = value;
		}

		public function get noXMov():Boolean
		{
			return _noXMov;
		}

		public function set noXMov(value:Boolean):void
		{
			_noXMov = value;
		}

		public function get timePreviousNV():Number
		{
			return _timePreviousNV;
		}

		public function set timePreviousNV(value:Number):void
		{
			_timePreviousNV = value;
		}

		public function get noVisible():Boolean
		{
			return _noVisible;
		}

		public function set noVisible(value:Boolean):void
		{
			_noVisible = value;
		}

		public function set heroArt(value:MovieClip):void
		{
			_heroArt = value;
		}

		public function get heroArt():MovieClip
		{
			return _heroArt;
		}

		public function get timePreviousND():Number
		{
			return _timePreviousND;
		}

		public function set timePreviousND(value:Number):void
		{
			_timePreviousND = value;
		}

		public function get noDamaged():Boolean
		{
			return _noDamaged;
		}

		public function set noDamaged(value:Boolean):void
		{
			_noDamaged = value;
		}

		public function get timePrevious():Number
		{
			return _timePrevious;
		}

		public function set timePrevious(value:Number):void
		{
			_timePrevious = value;
		}

		public function get noBounds():Boolean
		{
			return _noBounds;
		}

		public function set noBounds(value:Boolean):void
		{
			_noBounds = value;
		}

		public function get lifeCount():Number
		{
			return _lifeCount;
		}

		public function set lifeCount(value:Number):void
		{
			if (value <= 10)
				_lifeCount = value;
		}

		public function get heroBounds():Rectangle
		{
			return _heroBounds;
		}

		public function set heroBounds(value:Rectangle):void
		{
			_heroBounds = value;
		}

		private function onAddedToStage (event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createHeroArt();
		}
		
		private function createHeroArt ():void {
			this.lifeCount = Constants.MAX_HIT;
			this.noBounds = false;
			this.noDamaged = false;
			this.noBat = false;
			this.noFuel = false;
			this.noXMov = false;
			this.noXYMov = false;
			this.noBat = false;
			this.noFuel = false;
			this.firewall = false;
			this.fullBat = false;
			this.fullFuel = false;
			
			heroArt = new MovieClip(Assets.getAtlas().getTextures("hero_"), 12);
			var tmp:Number  = Math.floor(stage.stageHeight / 6);
			var tmpheight:Number = heroArt.height;
			var tmpwidth:Number = heroArt.width;
			
			heroArt.width = heroArt.width * tmp / heroArt.height;
			heroArt.height = tmp;
			_heroBounds = new Rectangle(this.x + 10, this.y + 10, heroArt.width-10, heroArt.height - 10);
			starling.core.Starling.juggler.add(heroArt);
			
			/*fire = new Image(Assets.getAtlas().getTexture("fire.png"));
			fire.x = heroArt.x + heroArt.width - (15 * 100 / heroArt.width);
			fire.y = heroArt.y + (30 * 100 / heroArt.height);
			fire.width = fire.width * heroArt.width / tmpwidth;
			fire.height = fire.height * heroArt.height / tmpheight;
			fire.visible = false;*/
			
			particleFire = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLFire()), Texture.fromBitmap(new AssetsParticles.ParticleTextureBullet()));
			Starling.juggler.add(particleFire);
			particleFire.x = heroArt.x + heroArt.width - 1;
			particleFire.scaleY = heroArt.height / 100;
			particleFire.y = heroArt.y + heroArt.height / 2;
			particleFire.stop(true);
			
			particleItem = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLgetItem()), Texture.fromBitmap(new AssetsParticles.ParticleTexturegetItem()));
			Starling.juggler.add(particleItem);
			particleItem.x = heroArt.x + heroArt.width / 3;
			particleItem.scaleY = heroArt.height / 100;
			particleItem.y = heroArt.y + heroArt.height / 2;
			particleItem.stop(true);
			
			
			this.addChild(heroArt);
			this.addChild(particleItem);
			this.addChild(particleFire);
			
			
		}
		
		public function updateBounds ():void {
			_heroBounds.setTo(this.x + 10, this.y + 10, heroArt.width-10, heroArt.height - 10);
		}
		
		public function setFireVisible(value:Boolean):void {
			
			//fire.visible = value;
			if (value) {
				particleFire.start();
			}	else {
				particleFire.stop();
			}
		}
		
		public function noPowers ():void {
			this.noBounds = false;
			this.noDamaged = false;
			this.noVisible = false;
			this.noXMov = false;
			this.noXYMov = false;
			this.noBat = false;
			this.noFuel = false;
			this.firewall = false;
			this.fullBat = false;
			this.fullFuel = false;
		}
		
		public function updatePowersTime(timePaused:Number):void
		{
			if (_noBounds) {
				timePrevious += timePaused;
			}
			if (_noDamaged) {
				_timePreviousND += timePaused;
			}
			if (_noVisible) {
				_timePreviousNV += timePaused;
			}
			if (_noXMov) {
				_timePreviousNX += timePaused;
			}
			if (_noXYMov) {
				_timePreviousNXY += timePaused;
			}
			if (_noBat) {
				_timePreviousLB += timePaused;
			}
			if (_noFuel) {
				_timePreviousLF += timePaused;
			}
			if (_firewall) {
				_timePreviousFW += timePaused;
			}
			if (_fullBat) {
				_timePreviousFB += timePaused;
			}
			if (_fullFuel) {
				_timePreviousFF += timePaused;
			}	
		}
	}
}