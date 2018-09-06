package screens
{
	import events.NavigationEvent;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import objects.Bullet;
	import objects.GameBackground;
	import objects.Hero;
	import objects.Item;
	import objects.Obstacle;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class inGame extends Sprite
	{
		private var startBtn:Button;
		private var bg:GameBackground;
		private var hero:Hero;
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		private var timePaused:Number = 0;
		
		private var gameState:String;
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		
		private var scoreDistance:int;
		private var scoreGame:int;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		private var obstaclesToAnimate:Vector.<Obstacle>;
		private var bulletsToAnimate:Vector.<Bullet>;
		private var itemsToAnimate:Vector.<Item>;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		private var tapCount:Number;
		private var fire:Number;
		private var timeToNextFire:Number;
		private var timeShowingFire:Number;
		
		private var scoreText:TextField;
		private var lifeText:TextField;
		private var debugText:TextField;
		private var killThemAll:Boolean;
		
		private var phantomSignal:Image;
		private var starSignal:Image;
		private var invisibleSignal:Image;
		private var lowBatSignal:Image;
		private var lowFuelSignal:Image;
		private var lockXSignal:Image;
		private var lockXYSignal:Image;
		private var firewallSignal:Image;
		private var fullBatSignal:Image;
		private var fullFuelSignal:Image;
		
		private var menuBtn:Button;
		private var playagainBtn:Button;
		
		private var particleBoom:PDParticleSystem;
		private var particleSmoke:PDParticleSystem;
		private var particleField:PDParticleSystem;
		private var particleFirewall:PDParticleSystem;
		private var particleRain:PDParticleSystem;
		
		private var gameOverCount:Number;
		private var noLoose:Boolean;
		private var pauseBtn:Button;
		private var continueBtn:Button;
		
		private var playerSpeedContainer:Number = 0;
		private var gameSpeedContainer:Number = 0;
		private var bgSpeedContainer:Number = 0;
		private var maxVolBtn:Button;
		private var minVolBtn:Button;
		private var muteBtn:Button;
		
		
		public function inGame()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage (event:Event):void { // hay que cambiar aqui
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();
			scoreText = new TextField(300, 100, "ScOrE: 0", Assets.getFont().name, 20, 0xffff00);
			lifeText = new TextField(200, 100, "LiVeS: " + Constants.MAX_HIT, Assets.getFont().name, 20, 0xffff00);
			debugText = new TextField(300, 100, "MinSpeed: " + Constants.MIN_SPEED, Assets.getFont().name, 20, 0x000000);
			scoreText.x = 100;
			lifeText.x = 400;
			debugText.x = 300;
			debugText.y = 460;
			this.addChild(scoreText);
			this.addChild(lifeText);
			this.addChild(debugText);
		}
		
		private function drawGame():void {
			bg = new GameBackground() ;
			//bg.speed = 10;
			this.addChild(bg);
			
			particleBoom = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLBoom()), Texture.fromBitmap(new AssetsParticles.ParticleTextureBoom()));
			Starling.juggler.add(particleBoom);
			particleBoom.x = -400;
			particleBoom.y = -300;
			//particleBoom.scaleX = 0.5 * stage.stageHeight / 600;
			//particleBoom.scaleY = 0.5 * stage.stageHeight / 600;
			this.addChild(particleBoom);
			
			particleSmoke = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLSmoke()), Texture.fromBitmap(new AssetsParticles.ParticleTextureSmoke()));
			Starling.juggler.add(particleSmoke);
			particleSmoke.x = -400;
			particleSmoke.y = -300;
			particleSmoke.scaleX = 1;
			particleSmoke.scaleY = 1;
			this.addChild(particleSmoke);
			
			particleField = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLField()), Texture.fromBitmap(new AssetsParticles.ParticleTextureField()));
			Starling.juggler.add(particleField);
			particleField.x = -400;
			particleField.y = -300;
			particleField.scaleX = 1;
			particleField.scaleY = 1;
			this.addChild(particleField);
			
			particleFirewall = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLFirewall()), Texture.fromBitmap(new AssetsParticles.ParticleTextureFirewall()));
			Starling.juggler.add(particleFirewall);
			particleFirewall.x = stage.stageWidth / 2;
			particleFirewall.y = -1;
			particleFirewall.scaleX = stage.stageWidth / 1000;
			particleFirewall.scaleY = stage.stageHeight / 500;
			this.addChild(particleFirewall);
			
			particleRain = new PDParticleSystem(XML(new AssetsParticles.ParticleXMLRain()), Texture.fromBitmap(new AssetsParticles.ParticleTextureRain()));
			Starling.juggler.add(particleRain);
			particleRain.x = stage.stageWidth / 2;
			particleRain.y = stage.stageHeight / 2;
			//particleRain.scaleX = stage.stageWidth / 1000;
			//particleRain.scaleY = stage.stageHeight / 500;
			this.addChild(particleRain);
			
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageHeight/2;
			this.addChild(hero);
			
			startBtn = new Button(Assets.getAtlas().getTexture("startBtn.png"));
			startBtn.width = Math.ceil(startBtn.width*0.65);
			startBtn.height = Math.ceil(startBtn.height*0.65);
			startBtn.x = stage.stageWidth / 2 - startBtn.width / 2;
			startBtn.y = stage.stageHeight / 2 - startBtn.height / 2;
			this.addChild(startBtn);
			
			
			
			var tmpsignalheight:Number = stage.stageHeight / 12;
			phantomSignal = new Image(Assets.getAtlas().getTexture("item_3.png"));
			starSignal = new Image(Assets.getAtlas().getTexture("item_2.png"));
			invisibleSignal = new Image(Assets.getAtlas().getTexture("item_9.png"));
			lockXSignal = new Image(Assets.getAtlas().getTexture("item_10.png"));
			lockXYSignal = new Image(Assets.getAtlas().getTexture("item_11.png"));
			lowBatSignal = new Image(Assets.getAtlas().getTexture("item_13.png"));
			lowFuelSignal = new Image(Assets.getAtlas().getTexture("item_12.png"));
			firewallSignal = new Image(Assets.getAtlas().getTexture("item_14.png"));
			fullBatSignal = new Image(Assets.getAtlas().getTexture("item_15.png"));
			fullFuelSignal = new Image(Assets.getAtlas().getTexture("item_16.png"));
			
			this.addChild(phantomSignal);
			this.addChild(starSignal);
			this.addChild(invisibleSignal);
			this.addChild(lockXSignal);
			this.addChild(lockXYSignal);
			this.addChild(lowBatSignal);
			this.addChild(lowFuelSignal);
			this.addChild(firewallSignal);
			this.addChild(fullBatSignal);
			this.addChild(fullFuelSignal);
			
			phantomSignal.scaleX = tmpsignalheight / phantomSignal.height;
			phantomSignal.height = tmpsignalheight;
			starSignal.width = starSignal.width * tmpsignalheight / starSignal.height;
			starSignal.height = tmpsignalheight;
			invisibleSignal.width = invisibleSignal.width * tmpsignalheight / invisibleSignal.height;
			invisibleSignal.height = tmpsignalheight;
			lockXSignal.width = lockXSignal.width * tmpsignalheight / lockXSignal.height;
			lockXSignal.height = tmpsignalheight;
			lockXYSignal.width = lockXYSignal.width * tmpsignalheight / lockXYSignal.height;
			lockXYSignal.height = tmpsignalheight;
			lowBatSignal.width = lowBatSignal.width * tmpsignalheight / lowBatSignal.height;
			lowBatSignal.height = tmpsignalheight;
			lowFuelSignal.width = lowFuelSignal.width * tmpsignalheight / lowFuelSignal.height;
			lowFuelSignal.height = tmpsignalheight;
			firewallSignal.width = firewallSignal.width * tmpsignalheight / firewallSignal.height;
			firewallSignal.height = tmpsignalheight;
			fullBatSignal.width = fullBatSignal.width * tmpsignalheight / fullBatSignal.height;
			fullBatSignal.height = tmpsignalheight;
			fullFuelSignal.width = fullFuelSignal.width * tmpsignalheight / fullFuelSignal.height;
			fullFuelSignal.height = tmpsignalheight;
			
			phantomSignal.x = stage.stageWidth / 80;
			phantomSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			starSignal.x = 2 * stage.stageWidth / 80 + starSignal.width;
			starSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			invisibleSignal.x = 3 * stage.stageWidth / 80 + 2 * invisibleSignal.width;
			invisibleSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			lockXSignal.x = 4 * stage.stageWidth / 80 + 3 * lockXSignal.width;
			lockXSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			lockXYSignal.x = 5 * stage.stageWidth / 80 + 4 * lockXYSignal.width;
			lockXYSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			lowBatSignal.x = 6 * stage.stageWidth / 80 + 5 * lowBatSignal.width;
			lowBatSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			lowFuelSignal.x = 7 * stage.stageWidth / 80 + 6 * lowFuelSignal.width;
			lowFuelSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			firewallSignal.x = 8 * stage.stageWidth / 80 + 7 * firewallSignal.width;
			firewallSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			fullBatSignal.x = 9 * stage.stageWidth / 80 + 8 * fullBatSignal.width;
			fullBatSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			fullFuelSignal.x = 10 * stage.stageWidth / 80 + 9 * fullFuelSignal.width;
			fullFuelSignal.y = stage.stageHeight - tmpsignalheight - (stage.stageHeight / 120);
			
			signalsOff(); 
			
			
			menuBtn = new Button(Assets.getAtlas().getTexture("mainBtn.png"));
			menuBtn.width = Math.ceil(menuBtn.width*0.4);
			menuBtn.height = Math.ceil(menuBtn.height*0.4);
			menuBtn.x = stage.stageWidth - menuBtn.width;
			menuBtn.y = stage.stageHeight - menuBtn.height;
			this.addChild(menuBtn);
			
			pauseBtn = new Button(Assets.getAtlas().getTexture("pauseBtn.png"));
			pauseBtn.width = Math.ceil(pauseBtn.width*0.4);
			pauseBtn.height = Math.ceil(pauseBtn.height*0.4);
			pauseBtn.x = stage.stageWidth - pauseBtn.width;
			pauseBtn.y = 0;
			pauseBtn.visible = false;
			this.addChild(pauseBtn);
			
			continueBtn = new Button(Assets.getAtlas().getTexture("continueBtn.png"));
			continueBtn.width = Math.ceil(continueBtn.width*0.4);
			continueBtn.height = Math.ceil(continueBtn.height*0.4);
			continueBtn.x = stage.stageWidth - continueBtn.width;
			continueBtn.y = 0;
			continueBtn.visible = false;
			this.addChild(continueBtn);
			
			maxVolBtn = new Button(Assets.getAtlas().getTexture("volMaxBtn.png"));
			maxVolBtn.width = Math.ceil(maxVolBtn.width*0.4);
			maxVolBtn.height = Math.ceil(maxVolBtn.height*0.4);
			maxVolBtn.x = stage.stageWidth - 2*maxVolBtn.width;
			maxVolBtn.y = 0;
			maxVolBtn.visible = false;
			this.addChild(maxVolBtn);
			
			minVolBtn = new Button(Assets.getAtlas().getTexture("volMinBtn.png"));
			minVolBtn.width = Math.ceil(minVolBtn.width*0.4);
			minVolBtn.height = Math.ceil(minVolBtn.height*0.4);
			minVolBtn.x = stage.stageWidth - 2*minVolBtn.width;
			minVolBtn.y = 0;
			minVolBtn.visible = false;
			this.addChild(minVolBtn);
			
			muteBtn = new Button(Assets.getAtlas().getTexture("muteBtn.png"));
			muteBtn.width = Math.ceil(muteBtn.width*0.4);
			muteBtn.height = Math.ceil(muteBtn.height*0.4);
			muteBtn.x = stage.stageWidth - 2*muteBtn.width;
			muteBtn.y = 0;
			muteBtn.visible = true;
			this.addChild(muteBtn);
			
			playagainBtn = new Button(Assets.getAtlas().getTexture("playagainBtn.png"));
			playagainBtn.width = Math.ceil(playagainBtn.width*0.7);
			playagainBtn.height = Math.ceil(playagainBtn.height*0.7);
			playagainBtn.x = Math.ceil(stage.stageWidth * 0.5 - playagainBtn.width * 0.5);
			playagainBtn.y = Math.ceil(stage.stageHeight * 0.5 - playagainBtn.height * 0.5);
			playagainBtn.visible = false;
			this.addChild(playagainBtn);
				
			this.addEventListener(starling.events.Event.TRIGGERED, onMenuClick);
			var tmp:Number = Math.floor(stage.stageHeight / 6);
			gameArea = new Rectangle(0, tmp, stage.stageWidth, stage.stageHeight - (2 * tmp));
		}
		
		private function onMenuClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			if ((buttonClicked as Button) == menuBtn) {
				continueBtn.visible = false;
				Constants.MIN_SPEED = Constants.FIX_MIN_SPEED;
				timeCurrent = getTimer();
				gameState = Constants.STATE_OVER;
				AssetsSounds.gameVolume = 2;
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "menuPlay"}, true));
			}
			if ((buttonClicked as Button) == playagainBtn) {
				
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "play"}, true));
			}
			if ((buttonClicked as Button) == pauseBtn) {
				continueBtn.visible = true;
				pauseBtn.visible = false;
				this.playerSpeedContainer = playerSpeed;
				playerSpeed = 0;
				this.gameSpeedContainer = Constants.MIN_SPEED;
				Constants.MIN_SPEED = 0;	
				if (bg) {
					this.bgSpeedContainer = bg.speed;
					bg.speed = 0;
				}
				particlesOff();
				gameState = Constants.STATE_PAUSED;
				timePaused = getTimer();
			}	
			if ((buttonClicked as Button) == continueBtn) {
				particlesOn();
				continueBtn.visible = false;
				pauseBtn.visible = true;
				playerSpeed = this.playerSpeedContainer;
				Constants.MIN_SPEED = this.gameSpeedContainer;
				bg.speed = this.bgSpeedContainer;
				if (playagainBtn.visible == false && startBtn.visible == false)
					gameState = Constants.STATE_FLYING;
				timePaused = getTimer() - timePaused;
				hero.updatePowersTime(timePaused);
			}
			if ((buttonClicked as Button) == muteBtn) {
				AssetsSounds.gameVolume = 0;
				minVolBtn.visible = true;
				muteBtn.visible = false;
				AssetsSounds.setVolume();
			}
			if ((buttonClicked as Button) == minVolBtn) {
				AssetsSounds.gameVolume = 1;
				minVolBtn.visible = false;
				maxVolBtn.visible = true;
				AssetsSounds.setVolume();
			}
			if ((buttonClicked as Button) == maxVolBtn) {
				AssetsSounds.gameVolume = 2;
				maxVolBtn.visible = false;
				muteBtn.visible = true;
				AssetsSounds.setVolume();
			}
		}
		
		public function disposeTemporarily ():void {
			if (starSignal) starSignal.visible = false;
			if (phantomSignal) phantomSignal.visible = false;
			//this.removeChildren();
			this.visible = false;
		}
		
		public function initialize ():void{
			this.visible = true;
			
			this.addEventListener(Event.ENTER_FRAME, checkElapsed);
			
			hero.x = -stage.stageWidth * 0.5;
			hero.y = stage.stageHeight * 0.5;
						
			gameState = Constants.STATE_IDLE;
			
			playerSpeed = 0;
			hitObstacle = 0;
			bg.speed = 0;
			
			scoreDistance = 0;
			scoreGame = 0;
			obstacleGapCount = 0;
			tapCount = 0;
			fire = 0;
			timeToNextFire = getTimer();
			timeShowingFire = 0;
			killThemAll = false;
			gameOverCount = 0;
			noLoose = true;
			
			AssetsSounds.gameVolume = 2;
			AssetsSounds.soundManager.playSound("bg2", AssetsSounds.getVolume(), 1000);
			
			obstaclesToAnimate = new Vector.<Obstacle>();
			bulletsToAnimate = new Vector.<Bullet>();
			itemsToAnimate = new Vector.<Item>();
			
			startBtn.addEventListener(Event.TRIGGERED, onStartButtonClick);
		}
		
		private function onStartButtonClick (event:Event):void {
			startBtn.visible = false;
			startBtn.removeEventListener(Event.TRIGGERED, onStartButtonClick);
			
			launchHero();
		}
		
		private function launchHero ():void {
			
			//particleBoom.start();
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onTick);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			touchX = touch.globalX;
			touchY = touch.globalY;
			tapCount = touch.tapCount;
		}
		
		private function onTick (event:Event):void {
			if (noLoose && hero.lifeCount <= 0) {
				gameState = Constants.STATE_OVER;
				gameOverCount = Constants.TIME_TO_GAMEOVER;
				noLoose = false;
				pauseBtn.visible = false;
			}
			switch(gameState)
			{
				case Constants.STATE_IDLE:{
					if (hero.x < stage.stageWidth * 0.01) {
						hero.x += ((stage.stageWidth * 0.1 + 10) - hero.x) * 0.01;
						hero.y = stage.stageHeight * 0.5;
						
						playerSpeed += (Constants.MIN_SPEED - playerSpeed) * 0.02;
						bg.speed = playerSpeed * elapsed;
					}	else {
						Constants.init();
						gameState = Constants.STATE_FLYING;
						pauseBtn.visible = true;
					}
					
					break;
				}
				case Constants.STATE_FLYING:{ //flying
					
					if (hitObstacle <= 0) {
						
						if (particleSmoke.isEmitting) {
							particleSmoke.stop();
						}
						
						if (hero.noFuel) {
							if ((getTimer() - hero.timePreviousLF) > Constants.POWERS_TIME) {
								hero.noFuel = false;
								lowFuelSignal.alpha = 1;
								lowFuelSignal.visible = false;
							}	else {
								touchY = gameArea.bottom - 1;
								lowFuelSignal.alpha = 1 - (getTimer() - hero.timePreviousLF) / (Constants.POWERS_TIME * 1.5);
							}
						}
						
						if (hero.fullFuel) {
							if ((getTimer() - hero.timePreviousFF) > Constants.POWERS_TIME) {
								hero.fullFuel = false;
								Constants.XMOV_DELAY = 0.1;
								Constants.YMOV_DELAY = 0.3
								fullFuelSignal.alpha = 1;
								fullFuelSignal.visible = false;
							}	else {
								fullFuelSignal.alpha = 1 - (getTimer() - hero.timePreviousFF) / (Constants.POWERS_TIME * 1.5);
							}
						}
						
						if (hero.noXMov) {
							if ((getTimer() - hero.timePreviousNX) > Constants.POWERS_TIME) {
								hero.noXMov = false;
								lockXSignal.alpha = 1;
								lockXSignal.visible = false;
							}	else {
								lockXSignal.alpha = 1 - (getTimer() - hero.timePreviousNX) / (Constants.POWERS_TIME * 1.5);
							}
						}
						
						if (hero.noXYMov) {
							if ((getTimer() - hero.timePreviousNXY) > Constants.POWERS_TIME) {
								hero.noXYMov = false;
								lockXYSignal.alpha = 1;
								lockXYSignal.visible = false;
							}	else {
								lockXYSignal.alpha = 1 - (getTimer() - hero.timePreviousNXY) / (Constants.POWERS_TIME * 1.5);
							}
						}	else {
							if (hero.noXMov == false) {
								hero.x -= ((hero.x - touchX) + hero.width / 2) * Constants.XMOV_DELAY;
							}
							hero.y -= ((hero.y - touchY) + hero.height / 2) * Constants.YMOV_DELAY;
						}
						
						
						
						//hero.updateBounds();
						
						if (-(hero.y - touchY) - hero.height / 2 < stage.stageHeight / 6 && -(hero.y - touchY) - hero.height / 2 > -stage.stageHeight / 6) 
							hero.rotation = deg2rad((-(hero.y - touchY) - hero.height / 2) * 0.2);
						
						if (hero.y < gameArea.top) {
							hero.rotation = 0;
							hero.y = gameArea.top;
						}
						if (hero.y > gameArea.bottom - hero.height + 1) {
							hero.rotation = 0;
							hero.y = gameArea.bottom - hero.height;
						}
						
						if (hero.x < 0) hero.x = 0;
						if (hero.x > gameArea.width - 2 * hero.heroArt.width) hero.x = gameArea.width - 2 * hero.heroArt.width;
						hero.updateBounds();
						
						if (tapCount >= 1 && distance(hero.x + hero.width / 2, hero.y + hero.height / 2, touchX, touchY) <= hero.height) {
							tapCount = 0;
							fire++;
						}
						if (hero.noBat) {
							if ((getTimer() - hero.timePreviousLB) > Constants.POWERS_TIME) {
								hero.noBat = false;
								lowBatSignal.alpha = 1;
								lowBatSignal.visible = false;
							}	else {
								lowBatSignal.alpha = 1 - (getTimer() - hero.timePreviousLB) / (Constants.POWERS_TIME * 1.5);	
								fire = 0;
							}
						}
						if (hero.fullBat) {
							if ((getTimer() - hero.timePreviousFB) > Constants.POWERS_TIME) {
								hero.fullBat = false;
								fullBatSignal.alpha = 1;
								fullBatSignal.visible = false;
								Constants.TIME_TO_SHOOT = Constants.FIX_CADENSE;
							}	else {
								fullBatSignal.alpha = 1 - (getTimer() - hero.timePreviousFB) / (Constants.POWERS_TIME * 1.5);							
							}
						}
						if (fire >= 1 && hero.noBat == false) {
							fire = 0;
							var tmpShoot:Number = getTimer();
							if (tmpShoot - timeToNextFire >= Constants.TIME_TO_SHOOT) {
								createBullet();
								timeToNextFire = tmpShoot;
							}
						}
						
					}	else {
						hitObstacle--;
						cameraShake();
					}
					
					playerSpeed -= (playerSpeed - Constants.MIN_SPEED) * 0.01;
					bg.speed = playerSpeed * elapsed;
					
					scoreDistance += (playerSpeed * elapsed) * 0.1;
					
					initObstacle();	
					createItems();
					animateBullets();
					animateObstacles();
					animateItems();

					if (scoreGame < 0) scoreGame = 0;
					scoreText.text = "ScOrE: " + scoreGame;
					lifeText.text = "LiVeS: " + hero.lifeCount;
					
					if (hero.noBounds) {
						if ((getTimer() - hero.timePrevious) > Constants.POWERS_TIME) {
							AssetsSounds.soundManager.stopSound("noBounds");
							hero.noBounds = false;
							phantomSignal.visible = false;
							phantomSignal.alpha = 1;
							if (hero.noVisible == false) hero.alpha = 1;
							else hero.alpha = 0;
						}	else {
							phantomSignal.alpha = 1 - (getTimer() - hero.timePrevious) / (Constants.POWERS_TIME * 1.5);
						}
					}
					
					if (hero.noDamaged) {
						if ((getTimer() - hero.timePreviousND) > Constants.POWERS_TIME) {
							AssetsSounds.soundManager.stopSound("noDamaged");
							hero.noDamaged = false;
							starSignal.visible = false;
							starSignal.alpha = 1;
							particleField.stop(true);
						}	else {
							starSignal.alpha = 1 - (getTimer() - hero.timePreviousND) / (Constants.POWERS_TIME * 1.5);
							particleField.x = hero.x + hero.width / 2;
							particleField.y = hero.y + hero.height / 2;
							
						}						
					}
					if (hero.noVisible) {
						if ((getTimer() - hero.timePreviousNV) > Constants.POWERS_TIME) {
							AssetsSounds.soundManager.stopSound("noBounds");
							hero.noVisible = false;
							invisibleSignal.visible = false;
							invisibleSignal.alpha = 1;
							if (hero.noBounds == false) hero.alpha = 1;
							else hero.alpha = .4;
						}	else {
							invisibleSignal.alpha = 1 - (getTimer() - hero.timePreviousNV) / (Constants.POWERS_TIME * 1.5);
						}
					}
					if (hero.firewall) {
						if ((getTimer() - hero.timePreviousFW + 1000) > Constants.POWERS_TIME) {
							particleFirewall.stop();
						}
						if ((getTimer() - hero.timePreviousFW) > Constants.POWERS_TIME) {
							hero.firewall = false;
							firewallSignal.visible = false;
							firewallSignal.alpha = 1;
						}	else {
							firewallSignal.alpha = 1 - (getTimer() - hero.timePreviousFW) / (Constants.POWERS_TIME * 1.5);
						}
					}
					
					
					break;	
				}
				case Constants.STATE_OVER: {
					
					if (gameOverCount <= 0) {
						//particleBoom.stop();
					
						playerSpeed = 0;
						bg.speed = 0;
						playagainBtn.visible = true;
						AssetsSounds.soundManager.stopAllSounds();
						Constants.MIN_SPEED = Constants.FIX_MIN_SPEED;
						if (this.x != 0) {
							this.x = 0;
							this.y = 0;
						}
						
					}	else {
						if (gameOverCount == Constants.TIME_TO_GAMEOVER) {
							if (particleSmoke.isEmitting) {
								particleSmoke.stop();
							}
							if (particleFirewall.isEmitting) particleFirewall.stop(true);
							if (particleField.isEmitting) particleField.stop(true);
							if (particleRain.isEmitting) particleRain.stop(true);
							
							particleBoom.x = hero.x + hero.width / 2;
							particleBoom.y = hero.y + hero.height / 2;
							particleBoom.scaleX = hero.height / 95;
							particleBoom.scaleY = hero.height / 100;
							particleBoom.start(0.07);
							AssetsSounds.soundManager.playSound("blowed", AssetsSounds.getVolume());
							
							
							removeAllFromScreen();
							
							scoreText.text = "ScOrE: " + scoreGame;
							lifeText.text = "LiVeS: " + hero.lifeCount;
							//cameraShake();
							
						}
						gameOverCount--;
						cameraShake();
					}
					
					break;
					
				}			
				case "paused": {
					break;
				}
			}
		}
		
		private function removeAllFromScreen():void
		{
			hero.noPowers();
			this.removeChild(hero);
			var obstacleIter:Obstacle;
			for (var i:uint = 0; i < obstaclesToAnimate.length; i++) {
				obstacleIter = obstaclesToAnimate[i];
				//obstaclesToAnimate.splice(i, 1);
				this.removeChild(obstacleIter); 
			}
			var itemtoTrack:Item;
			for (i = 0; i < itemsToAnimate.length; i++) {
				itemtoTrack = itemsToAnimate[i];
				//itemsToAnimate.splice(i, 1);
				this.removeChild(itemtoTrack);
			}
			var bulletIter:Bullet;
			for (i = 0; i < bulletsToAnimate.length; i++) {
				bulletIter = bulletsToAnimate[i];
				//bulletsToAnimate.splice(i, 1);
				this.removeChild(bulletIter);
			}
			obstaclesToAnimate.splice(0,obstaclesToAnimate.length-1);
			itemsToAnimate.splice(0, itemsToAnimate.length-1);
			bulletsToAnimate.splice(0, bulletsToAnimate.length-1);
			signalsOff();
		}
		
		private function signalsOff():void
		{
			phantomSignal.visible = false;
			starSignal.visible = false;
			invisibleSignal.visible = false;
			lockXSignal.visible = false;
			lockXYSignal.visible = false;
			lowBatSignal.visible = false;
			lowFuelSignal.visible = false;
			firewallSignal.visible = false;
			fullBatSignal.visible = false;	
			fullFuelSignal.visible = false;
		}
		
		private function particlesOff():void
		{
			for (var i:uint = 0; i < bulletsToAnimate.length; i++) {
				bulletsToAnimate[i].visible = false;
			}
			hero.particleFire.stop();
		}
		
		private function particlesOn():void
		{
			for (var i:uint = 0; i < bulletsToAnimate.length; i++) {
				bulletsToAnimate[i].visible = true;
			}			
		}
		
		private function createItems():void
		{
			if (Math.random() > 0.985) {
				var itemToTrack:Item;
				var tmp:Number = Math.random();
				if (tmp < 0.74) {
					itemToTrack = new Item(Math.ceil(Math.random() * 3) + 3); // 4,5 y6
				}
				if (tmp >=0.74 && tmp < 0.9) {
					var tmp1:Number = Math.ceil(Math.random() * 10);
					switch(tmp1) {
						case 1: {
							itemToTrack = new Item(2); //2
							break;
						}
						case 2: {
							itemToTrack = new Item(3); //3
							break;
						}
						case 3: {
							itemToTrack = new Item(7); //7
							break;
						}
						case 4: {
							itemToTrack = new Item(9); //9
							break;
						}
						case 5: {
							itemToTrack = new Item(10); //10
							break;
						}
						case 6: {
							itemToTrack = new Item(11); //11
							break;
						}
						case 7: {
							itemToTrack = new Item(12); //12
							break;
						}
						case 8: {
							itemToTrack = new Item(13); //13
							break;
						}
						case 9: {
							itemToTrack = new Item(15); //15
							break;
						}
						case 10: {
							itemToTrack = new Item(16); //16
							break;
						}
					}
				}
				if (tmp >= 0.9) {
					var tmp2:Number = Math.ceil(Math.random() * 3);
					switch(tmp2) {
						case 1: {
							itemToTrack = new Item(1); //1
							break;
						}
						case 2: {
							itemToTrack = new Item(8); //8
							AssetsSounds.soundManager.playSound("ray", AssetsSounds.getVolume());
							break;
						}
						case 3: {
							itemToTrack = new Item(14); //14
							break;
						}
					}
				}
				//itemToTrack = new Item(Math.ceil(Math.random() * 8));
				itemToTrack.height = stage.stageHeight / 12;
				itemToTrack.width = itemToTrack.height;
				itemToTrack.x = stage.stageWidth + itemToTrack.width;
				itemToTrack.y = int (Math.random() * (gameArea.bottom - gameArea.top - itemToTrack.height)) + gameArea.top;
				itemToTrack.yPos = itemToTrack.y;
				this.addChild(itemToTrack);
				itemsToAnimate.push(itemToTrack);
			}
		}
		
		private function animateItems():void
		{
			var itemtoTrack:Item;
			for (var i:uint = 0; i < itemsToAnimate.length; i++) {
				itemtoTrack = itemsToAnimate[i];
				itemtoTrack.x -= (playerSpeed * elapsed);
				itemtoTrack.y = itemtoTrack.yPos + Math.ceil(Math.cos(itemtoTrack.x * 0.04) * 10);
				itemtoTrack.updateBounds();
				
				if (itemtoTrack.itemBounds.intersects(hero.heroBounds)) {
					
					hero.particleItem.start(0.5);
					switch(itemtoTrack.itemType)
					{
						case Constants.ITEM_LIFE:
						{
							hero.lifeCount++;
							AssetsSounds.soundManager.playSound("good", AssetsSounds.getVolume());
							break;
						}
						case Constants.ITEM_DESTROYER:
						{
							hero.lifeCount--;
							AssetsSounds.soundManager.playSound("bad", AssetsSounds.getVolume());
							break;
						}
						case Constants.ITEM_POINTS_10:
						{
							scoreGame += 10;
							AssetsSounds.soundManager.playSound("points", AssetsSounds.getVolume());
							break;
						}
							
						case Constants.ITEM_POINTS_50:
						{
							scoreGame += 50;
							AssetsSounds.soundManager.playSound("points", AssetsSounds.getVolume());
							break;
						}
							
						case Constants.ITEM_POINTS_100:
						{
							scoreGame += 100;
							AssetsSounds.soundManager.playSound("points", AssetsSounds.getVolume());
							break;
						}
							
						case Constants.ITEM_PHANTOM:
						{
							hero.noBounds = true;
							phantomSignal.visible = true;
							hero.timePrevious = getTimer();
							if (hero.alpha != 0) hero.alpha = .4;
							AssetsSounds.soundManager.playSound("good", AssetsSounds.getVolume());
							if (AssetsSounds.soundManager.soundIsPlaying("noBounds") == false) {
								AssetsSounds.soundManager.playSound("noBounds", AssetsSounds.getVolume());
							}
							break;
						}
							
						case Constants.ITEM_INVISIBLE:
						{
							hero.noVisible = true;
							invisibleSignal.visible = true;
							hero.timePreviousNV = getTimer();
							hero.alpha = 0;
							AssetsSounds.soundManager.playSound("bad", AssetsSounds.getVolume());
							if (AssetsSounds.soundManager.soundIsPlaying("noBounds") == false) {
								AssetsSounds.soundManager.playSound("noBounds", AssetsSounds.getVolume());
							}
							break;
						}
							
						case Constants.ITEM_KILL:
						{
							//particleRain.start(2);
							bg.alpha = 0;
							killThemAll = true;
							AssetsSounds.soundManager.playSound("good", AssetsSounds.getVolume());
							if (AssetsSounds.soundManager.soundIsPlaying("ray")) {
								AssetsSounds.soundManager.stopSound("ray");
							}
							break;
						}
							
						case Constants.ITEM_STAR:
						{
							hero.noDamaged = true;
							particleField.x = hero.x + hero.width / 2 - hero.width / 15;
							particleField.y = hero.y + hero.height / 2;
							particleField.scaleX = hero.height / 100;
							particleField.scaleY = hero.height / 100;
							particleField.start();
							starSignal.visible = true;
							hero.timePreviousND = getTimer();
							AssetsSounds.soundManager.playSound("good", AssetsSounds.getVolume());
							if (AssetsSounds.soundManager.soundIsPlaying("noDamaged") == false) {
								AssetsSounds.soundManager.playSound("noDamaged", AssetsSounds.getVolume());
							}
							break;
						}
							
						case Constants.ITEM_LOCK_X:
						{
							hero.noXMov = true;
							AssetsSounds.soundManager.playSound("bad", AssetsSounds.getVolume());
							hero.timePreviousNX = getTimer();
							lockXSignal.visible = true;
							break;
						}
							
						case Constants.ITEM_LOCK_XY:
						{
							hero.noXYMov = true;
							AssetsSounds.soundManager.playSound("bad", AssetsSounds.getVolume());
							hero.timePreviousNXY = getTimer();
							lockXYSignal.visible = true;
							break;
						}
							
						case Constants.ITEM_LOW_BAT:
						{
							hero.noBat = true;
							AssetsSounds.soundManager.playSound("bad", AssetsSounds.getVolume());
							hero.timePreviousLB = getTimer();
							lowBatSignal.visible = true;
							break;
						}
							
						case Constants.ITEM_FULL_BAT:
						{
							hero.fullBat = true;
							AssetsSounds.soundManager.playSound("good", AssetsSounds.getVolume());
							hero.timePreviousFB = getTimer();
							fullBatSignal.visible = true;
							Constants.TIME_TO_SHOOT = Constants.FIX_CADENSE / 4;
							break;
						}
							
						case Constants.ITEM_FULL_FUEL:
						{
							hero.fullFuel = true;
							AssetsSounds.soundManager.playSound("good", AssetsSounds.getVolume());
							hero.timePreviousFF = getTimer();
							fullFuelSignal.visible = true;
							Constants.XMOV_DELAY = 0.8;
							Constants.YMOV_DELAY = 1;
							break;
						}
							
						case Constants.ITEM_LOW_FUEL:
						{
							hero.noFuel = true;
							AssetsSounds.soundManager.playSound("bad", AssetsSounds.getVolume());
							hero.timePreviousLF = getTimer();
							lowFuelSignal.visible = true;
							break;
						}
							
						case Constants.ITEM_FIREWALL:
						{
							hero.firewall = true;
							AssetsSounds.soundManager.playSound("good", AssetsSounds.getVolume());
							hero.timePreviousFW = getTimer();
							particleFirewall.start();
							firewallSignal.visible = true;
							break;
						}
							
						default:
						{
							break;
						}
					}
					
					itemsToAnimate.splice(i, 1);
					this.removeChild(itemtoTrack);
				}
				
				if (itemtoTrack.x < -itemtoTrack.width) {
					itemsToAnimate.splice(i, 1);
					this.removeChild(itemtoTrack);
				}
			}
		}
		
		private function cameraShake():void
		{
			if (hitObstacle > 0) {
				this.x = Math.random() * hitObstacle;
				this.y = Math.random() * hitObstacle;
			}	else {
				if (this.x != 0) {
					this.x = 0;
					this.y = 0;
				}
			}
			
		}
		
		private function animateBullets():void {
			var bulletIter:Bullet;
			
			for (var i:uint = 0; i < bulletsToAnimate.length; i++) {
				var noHitted:Boolean = true;
				bulletIter = bulletsToAnimate[i];
				
				bulletIter.x += (playerSpeed + Constants.MIN_SPEED) * 2 * elapsed;//(Constants.MIN_SPEED / 25);
				bulletIter.updateBounds();
				
				var obstacleIter:Obstacle;
				for (var j:uint = 0; j < obstaclesToAnimate.length && noHitted; j++) {
					obstacleIter = obstaclesToAnimate[j];
					if (obstacleIter.alreadyHit == false && obstacleIter.x < stage.stageWidth - bulletIter.width && obstacleIter.obstacleBounds.intersects(bulletIter.bulletBounds)) {
						//bulletIter.destroy();
						obstacleIter.alreadyHit = true;
						obstacleIter.watchOut = false;
						scoreGame += 30;
						noHitted = false;
						j = 0;
					}					
				}
				
				if (noHitted == false) {
					bulletsToAnimate.splice(i, 1);
					bulletIter.destroy();
					this.removeChild(bulletIter);
					i=0;
				}
				
				if (noHitted && bulletIter.x >= stage.stageWidth) {
					bulletsToAnimate.splice(i, 1);
					i=0;
					bulletIter.destroy();
					this.removeChild(bulletIter);
				}
			}
			
			if (timeShowingFire > 0) {
				timeShowingFire--;
			}	else {
				timeShowingFire = 0;
				hero.setFireVisible(false);
			}
		}
		
		private function animateObstacles():void
		{
			var obstacleIter:Obstacle;
			
			for (var i:uint = 0; i < obstaclesToAnimate.length; i++) {
				obstacleIter = obstaclesToAnimate[i];
				var hitted:Boolean = false;
				
				var bulletIter:Bullet;
				for (var j:uint = 0; j < bulletsToAnimate.length; j++) {
					bulletIter = bulletsToAnimate[j];
					if (obstacleIter.alreadyHit == false && obstacleIter.x < stage.stageWidth - bulletIter.width && obstacleIter.obstacleBounds.intersects(bulletIter.bulletBounds)) {
						
						bulletsToAnimate.splice(j, 1);
						this.removeChild(bulletIter);
						//bulletIter.dispose();//
						obstacleIter.alreadyHit = true;
						obstacleIter.watchOut = false;
						scoreGame += 20;
						//hitted = true;
						j = 0;
					}					
				}
				if (killThemAll && obstacleIter.x < stage.stageWidth && obstacleIter.alreadyHit == false) {
					
					obstacleIter.alreadyHit = true;
					obstacleIter.watchOut = false;
					scoreGame += 20;
				}
				if (hero.firewall && obstacleIter.x <= (stage.stageWidth / 2) && (obstacleIter.x + obstacleIter.width) > (stage.stageWidth / 2) && obstacleIter.alreadyHit == false) {
					obstacleIter.alreadyHit = true;
					obstacleIter.watchOut = false;
					scoreGame += 20;
				}
				
				if (obstacleIter.alreadyHit == false && hero.noBounds <= 0 && obstacleIter.obstacleBounds.intersects(hero.heroBounds)) {
					
					obstacleIter.alreadyHit = true;
					obstacleIter.watchOut = false;
					//obstacleIter.rotation = deg2rad(-30);
					hitObstacle = 20;
					if (hero.noDamaged == false) {
						playerSpeed *= 0.5;
						scoreGame -= 20;
						hero.lifeCount--; 
						particleSmoke.x = hero.x + hero.width / 2;
						particleSmoke.y = hero.y + hero.height - 20;
						particleSmoke.scaleX = hero.height / 100;
						particleSmoke.scaleY = hero.height / 100;
						particleSmoke.start();
					}	else {
						scoreGame += 20;
					}					
				}
				
				if (obstacleIter.alreadyHit) {
					if (obstacleIter.timeToShow <= 0) {
						hitted = true;
					}	else {
						obstacleIter.timeToShow--;
					}
				}
				
				if (obstacleIter.distance < 300) obstacleIter.watchOut = true;
				else obstacleIter.watchOut = false;
				
				if (obstacleIter.distance > 0) {
					obstacleIter.distance -= playerSpeed * elapsed;
				}	else {
					if (obstacleIter.watchOut) {
						obstacleIter.watchOut = false;
					}	
					obstacleIter.x -= (playerSpeed + obstacleIter.speed) * elapsed;
				}
				obstacleIter.updateBounds(obstacleIter.x, obstacleIter.y);
				if (obstacleIter.x < -obstacleIter.width || gameState == Constants.STATE_OVER || hitted) {
					if (obstacleIter.alreadyHit == false) scoreGame -= 100;
					obstaclesToAnimate.splice(i, 1);
					this.removeChild(obstacleIter); 
					obstacleIter.dispose();
					i--;
					if (hitted == false) hitObstacle = 10;
					
				}
			}
			killThemAll = false;
			bg.alpha = 1;
		}
		
		private function initObstacle():void
		{
			if (obstacleGapCount < 700) {
				obstacleGapCount += playerSpeed * elapsed;
			}	else {
				if (obstacleGapCount != 0) {
					obstacleGapCount = 0;
					createObstacle(Math.ceil(Math.random()*5), Math.random() * 1000 + 500);
				}
			}
		}
		
		private function createBullet():void {
			if (bulletsToAnimate.length < 8) {
				var bullet:Bullet = new Bullet(/*hero.x+90, hero.y+30*/);
				bullet.x = hero.x + hero.width - hero.width / 10;
				bullet.y = hero.y + 2 * hero.height / 3;
				AssetsSounds.soundManager.playSound("shoot", AssetsSounds.getVolume());
				this.addChild(bullet);
				bulletsToAnimate.push(bullet);
				timeShowingFire = 5;
				hero.setFireVisible(true);
			}
		}
		
		private function createObstacle(type:Number, distance:Number):void
		{
			var obstacle:Obstacle = new Obstacle(type, distance, false, 1);
			obstacle.x = stage.stageWidth;
			this.addChild(obstacle);
			var p:int;
			
			if (type <= 2) { // bombas
				p = Math.ceil(Math.random() * 2);
				if (p == 1) { //top
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}	else { // middle1
					obstacle.y = gameArea.top + Math.ceil(stage.stageHeight / 6);
					obstacle.position = "middle";
				}
			}
			
			if (type == 3) { // helicoptero middle2
				obstacle.y = gameArea.top + 2 * Math.ceil(stage.stageHeight / 6);
				obstacle.position = "middle";
			}
			
			if (type == 4) {
				p = Math.ceil(Math.random() * 2);
				if (p == 2) { //middle2
					obstacle.y = gameArea.top + 2 * Math.ceil(stage.stageHeight / 6);
					obstacle.position = "middle";
				}	else { // middle1
					obstacle.y = gameArea.top + Math.ceil(stage.stageHeight / 6);
					obstacle.position = "middle";
				}
			}
			
			if (type == 5) { //tanque bottom
				obstacle.y = gameArea.bottom - Math.ceil(stage.stageHeight / 6);
				obstacle.position = "bottom";
			}
						
			/*if (type <= 4) { // todos menos el tanque
				var p:int = Math.ceil(Math.random() * 3);
				if (p == 1) { // top
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}	else { // middle
					if (p == 2) {
						obstacle.y = gameArea.top + Math.ceil(stage.stageHeight / 6);
					}	else {
						obstacle.y = gameArea.top + 2 * Math.ceil(stage.stageHeight / 6);
					}
					obstacle.position = "middle";
				}
			}	else { // este es el tanque y se pone en el bottom
				obstacle.y = gameArea.bottom - Math.ceil(stage.stageHeight / 6);
				obstacle.position = "bottom";
			}*/
			
			obstaclesToAnimate.push(obstacle);
			changeSpeed();
		}
		
		private function changeSpeed():void
		{
			if (Constants.MIN_SPEED < 450) {
				Constants.MIN_SPEED += 1;
			}	else {
				if (Constants.MIN_SPEED >= 450 && Constants.MIN_SPEED < 500) {
					Constants.MIN_SPEED += .5;
				}	else {
					if (Constants.MIN_SPEED >= 500 && Constants.MIN_SPEED < 650) {
						Constants.MIN_SPEED += .2;
					}	else {
						if (Constants.MIN_SPEED >= 650 && Constants.MIN_SPEED < 700) {
							Constants.MIN_SPEED += .1;
						}
					}
				}
			}
			debugText.text = "MinSpeed: " + Constants.MIN_SPEED;
		}
		
		private function checkElapsed(event:Event):void {
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001; 
		}
		
		private function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.ceil(Math.sqrt(Math.pow(x1-x2, 2) + Math.pow(y1-y2, 2)));
		}
		
	}
}