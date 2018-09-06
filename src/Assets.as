package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		[Embed(source="..\\media\\graphics\\Welcome\\bgWelcome.png")]
		public static const bgWelcome:Class;
		
		[Embed(source="..\\media\\graphics\\Welcome\\bgGame1.png")]
		public static const BgGame1:Class;
		
		[Embed(source="..\\media\\graphics\\Welcome\\title.png")]
		public static const welcomeTitle:Class; 
		
		[Embed(source="..\\media\\graphics\\Welcome\\playBtn.png")]
		public static const welcomePlayBtn:Class;
		
		[Embed(source="..\\media\\graphics\\Welcome\\aboutBtn.png")]
		public static const welcomeAboutBtn:Class;
		
		[Embed(source="..\\media\\graphics\\Welcome\\hero.png")]
		public static const welcomeHero:Class;
		
		/*[Embed(source="..\\media\\graphics\\ovni2_1.png")]
		public static const hero_1:Class;
		
		[Embed(source="..\\media\\graphics\\ovni2_2.png")]
		public static const hero_2:Class;
		
		[Embed(source="..\\media\\graphics\\ovni2_3.png")]
		public static const hero_3:Class;*/
		
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source="..\\media\\graphics\\sprites.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="..\\media\\graphics\\sprites.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		[Embed(source="..\\media\\fonts\\bitmap\\myFont.png")]
		public static const FontTexture:Class;
		
		[Embed(source="..\\media\\fonts\\bitmap\\myFont.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		
		public static var MYFont:BitmapFont;
		
		[Embed(source="..\\media\\fonts\\JUNEBUG.TTF", fontFamily="myFontName", embedAsCFF="false")]
		public static var myFont:Class;
		
		public static function getFont():BitmapFont {
			var fonTexture:Texture = Texture.fromBitmap(new FontTexture());
			var fontXml:XML = XML(new FontXml());
			var font:BitmapFont = new BitmapFont(fonTexture, fontXml);
			TextField.registerBitmapFont(font);
			return font;
		}
		
		public static function getAtlas():TextureAtlas {
			if (gameTextureAtlas == null) {				
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas;
		}
		
		public static function getTexture (name:String):Texture {
			if (gameTextures[name] == undefined) {
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
				
			}
			return gameTextures[name];
		}
		
		
	}
}