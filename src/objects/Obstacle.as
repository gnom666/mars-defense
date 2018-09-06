package objects
{
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class Obstacle extends Sprite
	{
		private var _type:int;
		private var _speed:int;
		private var _distance:int;
		private var _watchOut:Boolean;
		private var _alreadyHit:Boolean;
		private var _position:String;
		private var _timeToShow:Number;
		private var obstacleImage:Image;
		private var obstacleCrashImage:Image;
		private var obstacleAnimation:MovieClip;
		private var watchOutAnimation:MovieClip;
		private var _obstacleBounds:Rectangle;
		//public var soundManager:SoundManager;
		
		
		public function Obstacle(_type:int, _distance:int, _watchOut:Boolean, _speed:int)
		{
			super();
			
			this._type = _type;
			this._distance = _distance;
			this._watchOut = _watchOut;
			this._speed = _speed;
			
			_alreadyHit = false;
			//soundManager = new SoundManager();
			
						
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		public function get timeToShow():Number
		{
			return _timeToShow;
		}

		public function set timeToShow(value:Number):void
		{
			_timeToShow = value;
		}

		public function get obstacleBounds():Rectangle
		{
			return _obstacleBounds;
		}

		public function set obstacleBounds(value:Rectangle):void
		{
			_obstacleBounds = value;
		}

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get distance():int
		{
			return _distance;
		}

		public function set distance(value:int):void
		{
			_distance = value;
		}

		public function get position():String
		{
			return _position;
		}

		public function set position(value:String):void
		{
			_position = value;
		}

		public function get alreadyHit():Boolean
		{
			return _alreadyHit;
		}

		public function set alreadyHit(value:Boolean):void
		{
			if (_alreadyHit == false) {
				_alreadyHit = value;
				_timeToShow = Constants.TIME_TO_SHOW;
				
				if (value) {
					AssetsSounds.soundManager.playSound("blowed", AssetsSounds.getVolume());
					obstacleCrashImage.visible = true;
					if (_type <= 5) {
						obstacleAnimation.visible = false;
					}	else {
						obstacleImage.visible = false;
					}
					
				}
			}
		}

		public function get watchOut():Boolean
		{
			return _watchOut;
		}

		public function set watchOut(value:Boolean):void
		{
			_watchOut = value;
			
			if (watchOutAnimation) { 
				if (value) watchOutAnimation.visible = true;
				else watchOutAnimation.visible = false;
			}
		}

		private function onAddedToStage (event:Event):void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			createObstacleArt();
			createObstacleCrashArt();
			createWatchOutAnimation();
		}
		
		private function createWatchOutAnimation():void
		{
			watchOutAnimation = new MovieClip(Assets.getAtlas().getTextures("watch_out_"), 6);
			//watchOutAnimation.width = watchOutAnimation.width * 0.8;
			//watchOutAnimation.height = watchOutAnimation.height * 0.8;
			var tmp:Number  = Math.floor(stage.stageHeight / 6);
			watchOutAnimation.width = Math.floor(watchOutAnimation.width * tmp / watchOutAnimation.height);
			watchOutAnimation.height = Math.floor(tmp);
			Starling.juggler.add(watchOutAnimation);
			
			if (_type <= 5) {
				watchOutAnimation.x = - watchOutAnimation.width;
				watchOutAnimation.y = Math.ceil(obstacleAnimation.y + (obstacleAnimation.height * 0.5) - (watchOutAnimation.height * 0.5));
			}	else {
				watchOutAnimation.x = -watchOutAnimation.width;
				watchOutAnimation.y = Math.ceil(obstacleImage.y + (obstacleImage.height * 0.5) - (watchOutAnimation.height * 0.5));
			}
			
			this.addChild(watchOutAnimation);
		}
		
		private function createObstacleCrashArt():void
		{
			var tmp:Number  = Math.floor(stage.stageHeight / 6);
			obstacleCrashImage = new Image(Assets.getAtlas().getTexture("crash.png"));
			obstacleCrashImage.width = Math.ceil((obstacleCrashImage.width * tmp / obstacleCrashImage.height) * 1.2);
			obstacleCrashImage.height = Math.ceil(tmp * 1.2);
			obstacleCrashImage.visible = false;
			this.addChild(obstacleCrashImage);
		}
		
		private function createObstacleArt():void
		{
			var tmp:Number  = Math.floor(stage.stageHeight / 6);
			if (_type <= 5) {
				obstacleAnimation = new MovieClip(Assets.getAtlas().getTextures("obstacle_" + _type), 8);
				obstacleAnimation.width = Math.ceil(obstacleAnimation.width * tmp / obstacleAnimation.height);
				obstacleAnimation.height = tmp;
				Starling.juggler.add(obstacleAnimation);
				obstacleAnimation.x = 0;
				obstacleAnimation.y = 0;
				_obstacleBounds = new Rectangle(0, 0, obstacleAnimation.width - 20, obstacleAnimation.height);
				this.addChild(obstacleAnimation);
			}	else {
				obstacleImage = new Image(Assets.getAtlas().getTexture("obstacle_" + _type + ".png"));
				obstacleImage.x = 0;
				obstacleImage.y = 0;
				this.addChild(obstacleImage);
			}
		}
		
		public function updateBounds (xPos:int, yPos:int):void {
			_obstacleBounds.setTo(xPos, yPos, _obstacleBounds.width, _obstacleBounds.height);
		}
	}
}