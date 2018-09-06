package screens
{
	import com.greensock.TweenLite;
	
	import events.NavigationEvent;
	
	import objects.Bullet;
	import objects.Item;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
		
	public class Welcome extends Sprite
	{
		private var bg:Image;
		private var title:Image;
		private var hero:Image;
		
		private var playBtn:Button;
		private var aboutBtn:Button;
		private var optionsBtn:Button;
		private var test:Item;
		
		public function Welcome()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(event:Event):void {
			trace("welcome screen inicializado");
			
			drawScreen();
		}
		
		private function drawScreen ():void {
			bg = new Image(Assets.getTexture("bgWelcome")); 
			if (bg.texture.width < stage.stageWidth) {
				bg.height = bg.height * stage.stageWidth / bg.width;
				bg.width = stage.stageWidth;
			} else
				if (bg.texture.height < stage.stageHeight) {
					bg.width = bg.width * stage.stageHeight / bg.height;
					bg.height = stage.stageHeight;
				}
			this.addChild(bg);
			
			title = new Image(Assets.getTexture("welcomeTitle")); 
			title.width = title.width * ((stage.stageHeight * 0.4) / title.height);
			title.height = stage.stageHeight * 0.5;
			this.addChild(title);
			
			hero = new Image(Assets.getTexture("welcomeHero")); 
			hero.height = stage.stageHeight / 6 * 2;
			hero.width = hero.height;
			hero.x = -hero.height;
			hero.y = stage.stageHeight / 2;
			this.addChild(hero);
			
			aboutBtn = new Button(Assets.getAtlas().getTexture("aboutBtn.png"));
			aboutBtn.width =  Math.ceil(aboutBtn.width * (stage.stageHeight*0.2) / aboutBtn.height);
			aboutBtn.height = Math.ceil(stage.stageHeight*0.2);
			aboutBtn.x = stage.stageWidth - Math.ceil(stage.stageHeight * 0.3) * 0.75 - aboutBtn.width;
			aboutBtn.y = stage.stageHeight - aboutBtn.height;
									
			playBtn = new Button(Assets.getAtlas().getTexture("playBtn.png"));
			playBtn.width = Math.ceil(playBtn.width * (stage.stageHeight*0.3) / playBtn.height);
			playBtn.height = Math.ceil(stage.stageHeight * 0.3);
			playBtn.x = stage.stageWidth - playBtn.width;
			playBtn.y = stage.stageHeight - (aboutBtn.height * 0.75) - playBtn.height;
						
			optionsBtn = new Button(Assets.getAtlas().getTexture("optionsBtn.png"));
			optionsBtn.width = Math.ceil(optionsBtn.width * (stage.stageHeight*0.2) / optionsBtn.height);
			optionsBtn.height = Math.ceil(stage.stageHeight * 0.2);
			optionsBtn.x = stage.stageWidth - optionsBtn.width;
			optionsBtn.y = stage.stageHeight - (optionsBtn.height) - (playBtn.height * 0.75) - aboutBtn.height;
						
			this.addChild(aboutBtn);
			this.addChild(optionsBtn);
			this.addChild(playBtn);
			/*test = new Item(6);
			test.x = 300;
			test.y = 100;
			this.addChild(test);*/
			
			this.addEventListener(starling.events.Event.TRIGGERED, onMainMenuClick);	
			//if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, heroAnimation);
			this.addEventListener(Event.ENTER_FRAME, heroAnimation);
			
		} 
		
		private function onMainMenuClick(event:Event):void {
			//this.removeEventListener(starling.events.Event.TRIGGERED, onMainMenuClick);
			var buttonClicked:Button = event.target as Button;
			if ((buttonClicked as Button) == playBtn) {
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "play"}, true));
			}
			if ((buttonClicked as Button) == aboutBtn) {
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "about"}, true));
			}
			if ((buttonClicked as Button) == optionsBtn) {
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "options"}, true));
			}
		}
		
		public function initialize ():void{
			this.visible = true;
			hero.height = stage.stageHeight / 3;
			hero.width = hero.height + hero.height / 20;
			hero.x = -hero.height;
			hero.y = stage.stageHeight / 2;
			
			TweenLite.to(hero,  4, {x: stage.stageWidth / 6, y: stage.stageHeight / 2});
			
			if (AssetsSounds.soundManager.soundIsPlaying("bg1")){
				AssetsSounds.soundManager.stopSound("bg1");
			}	
			AssetsSounds.soundManager.playSound("bg1", AssetsSounds.getVolume(), 10);
			
			//if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, heroAnimation);
			//this.addEventListener(Event.ENTER_FRAME, heroAnimation);
			
		}
		
		private function heroAnimation(event:Event):void {
			var currentDate:Date = new Date();
			hero.y = stage.stageHeight / 2 + (Math.cos(currentDate.getTime() * 0.002) * stage.stageHeight / 12);
			//hero.x = 180 + (Math.sin(currentDate.getTime() * 0.002) * 50);	
			
			playBtn.y = stage.stageHeight - (aboutBtn.height * 0.75) - playBtn.height + (Math.cos(currentDate.getTime() * 0.002) * 14);
			aboutBtn.y = stage.stageHeight - aboutBtn.height + (Math.cos(currentDate.getTime() * 0.002) * 10);
			optionsBtn.y = stage.stageHeight - (optionsBtn.height) - (playBtn.height * 0.75) - aboutBtn.height + (Math.cos(currentDate.getTime() * 0.002) * 10);
		}
		
		public function disposeTemporarily ():void {
			this.visible = false;
			
			//if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, heroAnimation);
		}
	}
}