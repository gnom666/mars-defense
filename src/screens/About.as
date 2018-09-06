package screens
{
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class About extends Sprite
	{
		private var bg:Image;
		private var title:Image;
		private var menuBtn:Button;
		private var madeBy:TextField;
		private var nameText:TextField;
		private var yearText:TextField;
		private var optionsBtn:Button;
		private var aboutBtn:Button;
		private var state:String; // options, about, 
		private var resumeText:TextField;
		
		public function About()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			drawScreen();
			madeBy = new TextField(stage.stageWidth / 2, 25, "AuThOr:", Assets.getFont().name, 20, 0xffff00);
			nameText = new TextField(stage.stageWidth / 2, 25, "JoRgE a. RiOs GaRcIa", Assets.getFont().name, 20, 0xffff00);
			yearText = new TextField(stage.stageWidth / 2, 25, "2013", Assets.getFont().name, 20, 0xffff00);
			var resume:String = "wHEN eARTH FORCES ARRIVE TO YOUR PLANET THE ONLY OPTION IS TO FIGHT THEM. " +
								"yOU HAVE ONLY ONE SHIP LEFT BUT MUST PROTECT YOUR CITY. " +
								"eLIMINATE AS MANY AS YOU CAN BEFORE THEY REACH YOUR CITY.";
			resumeText = new TextField(stage.stageWidth / 2, stage.stageHeight, resume, Assets.getFont().name, 20, 0x00ff00);
			madeBy.y = 0;
			nameText.y = madeBy.height;
			yearText.y = madeBy.height + nameText.height;
			madeBy.x = stage.stageWidth - madeBy.width;
			nameText.x = stage.stageWidth - nameText.width;
			yearText.x = stage.stageWidth - yearText.width;
			resumeText.x = 0;
			resumeText.y = 0;
			this.addChild(madeBy);
			this.addChild(nameText);
			this.addChild(yearText);
			this.addChild(resumeText);
		}
		
		private function drawScreen():void
		{
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
			//this.addChild(title);
			
			menuBtn = new Button(Assets.getAtlas().getTexture("mainBtn.png"));
			menuBtn.width = Math.ceil(menuBtn.width * (stage.stageHeight * 0.2 / menuBtn.height));
			menuBtn.height = Math.ceil(stage.stageHeight * 0.2);
			menuBtn.x = stage.stageWidth - menuBtn.width;
			menuBtn.y = stage.stageHeight - menuBtn.height;
			this.addChild(menuBtn);
			
			optionsBtn = new Button(Assets.getAtlas().getTexture("optionsBtn.png"));
			optionsBtn.width = Math.ceil(optionsBtn.width * (stage.stageHeight * 0.2 / optionsBtn.height));
			optionsBtn.height = Math.ceil(stage.stageHeight * 0.2);
			optionsBtn.x = stage.stageWidth - optionsBtn.width;
			optionsBtn.y = stage.stageHeight - 2 * optionsBtn.height;
			this.addChild(optionsBtn);
			
			aboutBtn = new Button(Assets.getAtlas().getTexture("aboutBtn.png"));
			aboutBtn.width = Math.ceil(aboutBtn.width * (stage.stageHeight * 0.2 / aboutBtn.height));
			aboutBtn.height = Math.ceil(stage.stageHeight * 0.2);
			aboutBtn.x = stage.stageWidth - aboutBtn.width;
			aboutBtn.y = stage.stageHeight - 2 * aboutBtn.height;
			aboutBtn.visible = false;
			this.addChild(aboutBtn);
			
			this.addEventListener(starling.events.Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onMainMenuClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			if ((buttonClicked as Button) == menuBtn) {
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "menuAbout"}, true));
			}
			if ((buttonClicked as Button) == optionsBtn) {
				//this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "menuAbout"}, true));
				setOptionsConditions();
			}
			if ((buttonClicked as Button) == aboutBtn) {
				//this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "menuAbout"}, true));
				setAboutConditions();
			}
		}
		
		public function setAboutConditions ():void {
			this.resumeText.visible = true;
			aboutBtn.visible = false;
			optionsBtn.visible = true;
		}
		
		public function setOptionsConditions ():void {
			this.resumeText.visible = false;
			aboutBtn.visible = true;
			optionsBtn.visible = false;
		}
		
		public function disposeTemporarily ():void {
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			this.addEventListener(Event.ENTER_FRAME, aboutAnimation);
			
		}
		
		private function aboutAnimation(event:Event):void
		{
			var currentDate:Date = new Date();
			menuBtn.y = stage.stageHeight - menuBtn.height + (Math.cos(currentDate.getTime() * 0.002) * 10);
			optionsBtn.y = stage.stageHeight - 2 * optionsBtn.height + (Math.cos(currentDate.getTime() * 0.002) * 10);
			aboutBtn.y = stage.stageHeight - 2 * aboutBtn.height + (Math.cos(currentDate.getTime() * 0.002) * 10);
		}
	}
}