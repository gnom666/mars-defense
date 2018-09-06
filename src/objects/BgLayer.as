package objects
{
	import starling.display.Sprite;
	
	import starling.display.Image;
	import starling.events.Event;
	
	public class BgLayer extends Sprite
	{
		private var image1:Image;
		private var image2:Image;
		
		private var _layer:int;
		private var _parallax:Number;
		
		public function BgLayer(layer:int)
		{
			super();
			this._layer = layer;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage (event:Event):void {
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			/*if (_layer == 1) {
				image1 = new Image(Assets.getAtlas().getTexture("bg_" + _layer + ".png"));
				image2 = new Image(Assets.getAtlas().getTexture("bg_" + _layer + ".png"));
			} 	else {
				image1 = new Image(Assets.getAtlas().getTexture("bg_" + _layer + ".png"));
				image2 = new Image(Assets.getAtlas().getTexture("bg_" + _layer + ".png"));
			}*/
			image1 = new Image(Assets.getAtlas().getTexture("bg_" + _layer + ".png"));
			image2 = new Image(Assets.getAtlas().getTexture("bg_" + _layer + ".png"));
			
			//if (_layer == 1) {
				//image1.width = image1.width * stage.stageHeight / 600;
				image1.height = image1.height * stage.stageHeight / 600;
				image1.width = image1.width * stage.stageWidth / 800;
				
				image2.height = image1.height;
				image2.width = image1.width;
				
			//}
			
			image1.x = 0;
			image1.y = stage.stageHeight - image1.height;
			
			image2.x = image2.width - 5;
			image2.y = image1.y ;
			
			this.addChild(image1); 
			this.addChild(image2);
		}
		
		public function get parallax():Number {
			return _parallax;
		}
		
		public function set parallax(value:Number):void {
			_parallax = value;
		}
	}
}