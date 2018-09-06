package objects
{
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Item extends Sprite
	{
		private var _itemType:int;
		private var itemImage:Image;
		private var _xPos:int;
		private var _yPos:int;
		private var _itemBounds:Rectangle;	
		
		public function Item(_itemType:int)
		{
			
			super();
			
			this.itemType = _itemType;
		}

		

		public function get itemBounds():Rectangle
		{
			return _itemBounds;
		}

		public function get yPos():int
		{
			return _yPos;
		}

		public function set yPos(value:int):void
		{
			_yPos = value;
		}

		public function get itemType():int
		{
			return _itemType;
		}

		public function set itemType(value:int):void
		{
			_itemType = value;
			itemImage = new Image(Assets.getAtlas().getTexture("item_"+_itemType+".png"));
			
			itemImage.x = 0;
			itemImage.y = 0;
			itemImage.visible = true;
			this.addChild(itemImage);
			_itemBounds = new Rectangle(this.x+5, this.y+5, 40, 40); 
		}
		
		public function updateBounds():void {
			_itemBounds.setTo(this.x+5, this.y+5, 40, 40);
		}

	}
}