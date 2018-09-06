package
{
	import events.NavigationEvent;
	
	import screens.About;
	import screens.Welcome;
	import screens.inGame;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite 
	{
		private var screenWelcome:Welcome;
		private var screenInGame:inGame;
		private var screenAbout:About;
		
		public function Game()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage); 
		}
		
		private function onAddedToStage(event:Event):void {
			trace("starling framework inicializado");
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
			/*screenInGame = new inGame();
			screenInGame.disposeTemporarily();
			this.addChild(screenInGame);*/
			
			screenAbout = new About();
			screenAbout.disposeTemporarily();
			this.addChild(screenAbout);
			
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
			screenWelcome.initialize();
		}
		
		private function onChangeScreen (event:NavigationEvent):void {
			switch(event.params.id)
			{
				case "play":
				{
					screenWelcome.disposeTemporarily();
					
					if (screenInGame) {
						//screenInGame.disposeTemporarily();
						this.removeChild(screenInGame);
						screenInGame.dispose();
					}
					screenInGame = new inGame();
					screenInGame.disposeTemporarily();
					this.addChild(screenInGame);
					AssetsSounds.soundManager.stopAllSounds();
					screenInGame.initialize();
					
					break;
				}
					
				case "about":
				{
					screenWelcome.disposeTemporarily();
					if (screenInGame) {
						screenInGame.disposeTemporarily();
					}
					screenAbout.initialize();
					screenAbout.setAboutConditions();
					
					break;
				}
					
				case "options":
				{
					screenWelcome.disposeTemporarily();
					if (screenInGame) {
						screenInGame.disposeTemporarily();
					}
					screenAbout.initialize();
					screenAbout.setOptionsConditions();
					
					break;
				}
					
				case "menuAbout":
				{
					screenAbout.disposeTemporarily();
					if (screenInGame) {
						screenInGame.disposeTemporarily();
					}	
					AssetsSounds.soundManager.stopAllSounds();
					screenWelcome.initialize();
					break;
				}
					
				case "menuPlay": 
				{
					if (screenInGame) {
						//screenInGame.disposeTemporarily();
						this.removeChild(screenInGame);
						screenInGame.dispose();
					}
					screenAbout.disposeTemporarily();
					AssetsSounds.soundManager.stopAllSounds();
					screenWelcome.initialize();
					
				}
				
				default:
				{
					break;
				}
			}
		}
	}
}