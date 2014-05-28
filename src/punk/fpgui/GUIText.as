package punk.fpgui
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Copying
	 */
	public class GUIText extends Text
	{
		
		public function GUIText(text:String, width:Number = 0, height:Number = 0, options:Object = null, textScrollX:Number = 0, textScrollY:Number = 0, offsetX:Number = 0, offsetY:Number = 0)
		{
			if (!options) options = { size: 16, color: 0xFFFFFF, wordWrap: false, align: "left", resizable: true };
			_textScroll = new Point(textScrollX, textScrollY);
			_textRect = new Rectangle(0, 0, width, height);
			
			options.resizable = true;
			options.wordWrap = false;
			
			super(text, offsetX, offsetY, options);
			_field.multiline = true; //force to allow hte multi line even if it's rich text
		}
		
		override public function updateTextBuffer():void
		{
			if (_richText) {
				_form.color = _color;
				matchStyles();
			} else {
				_form.color = 0xFFFFFF;
				_field.setTextFormat(_form);
			}
			
			_field.width = _width;
			_field.width = _textWidth = Math.ceil(_field.textWidth + 4);
			_field.height = _textHeight = Math.ceil(_field.textHeight + 4);
			
			//always resizable
			if (_width < _textWidth)
				_width = _textWidth;
			if (_height < _textHeight)
				_height = _textHeight;
			
			if (_width > _source.width || _height > _source.height)
			{
				_source = new BitmapData(
					Math.max(_width, _source.width), Math.max(_height, _source.height), true, 0);
				
				_sourceRect = _source.rect;
				createBuffer();
			}
			else
			{
				_source.fillRect(_sourceRect, 0);
			}
			
			_richText ? _field.htmlText = _field.htmlText : _field.text = _field.text;
			
			_field.width = _width;
			_field.height = _height;
			
			_field.x = -(_field.transform.matrix.tx = _textScroll.x);
			_field.y = -(_field.transform.matrix.ty = _textScroll.y);
			
			_source.draw(_field, _field.transform.matrix, null, null, _textRect);
			
			
			updateBuffer();
		}
		
		//becouse matchStyles is a private function, i had to copy-paste it.
		private static var _styleIndices:Vector.<int> = new Vector.<int>;
		private static var _styleMatched:Array = new Array;
		private static var _styleFormats:Vector.<TextFormat> = new Vector.<TextFormat>;
		private static var _styleFrom:Vector.<int> = new Vector.<int>;
		private static var _styleTo:Vector.<int> = new Vector.<int>;
		
		private function matchStyles():void
		{
			var i:int, j:int;
			
			var fragments:Array = _richText.split("<");
			
			_styleIndices.length = 0;
			_styleMatched.length = 0;
			_styleFormats.length = 0;
			_styleFrom.length = 0;
			_styleTo.length = 0;
			
			for (i = 1; i < fragments.length; i++) {
				if (_styleMatched[i]) continue;
				
				var substring:String = fragments[i];
			
				var tagLength:int = substring.indexOf(">");
				
				if (tagLength > 0) {
					var tagName:String = substring.substr(0, tagLength);
					if (_styles[tagName]) {
						fragments[i] = substring.slice(tagLength + 1);
				
						var endTagString:String = "/" + tagName + ">";
				
						for (j = i + 1; j < fragments.length; j++) {
							if (fragments[j].substr(0, tagLength + 2) == endTagString) {
								fragments[j] = fragments[j].slice(tagLength + 2);
								_styleMatched[j] = true;
							
								break;
							}
						}
						
						_styleFormats.push(_styles[tagName]);
						_styleFrom.push(i);
						_styleTo.push(j);
						
						continue;
					}
				}
				
				fragments[i-1] = fragments[i-1].concat("<");
			}
			
			_styleIndices[0] = 0;
			j = 0;
			
			for (i = 0; i < fragments.length; i++) {
				j += fragments[i].length;
				_styleIndices[i+1] = j;
			}
			
			_field.text = _text = fragments.join("");
			
			_field.setTextFormat(_form);
			
			for (i = 0; i < _styleFormats.length; i++) {
				var start:int = _styleIndices[_styleFrom[i]];
				var end:int = _styleIndices[_styleTo[i]];
				
				if (start != end) _field.setTextFormat(_styleFormats[i], start, end);
			}
		}
		
		public function get lastLineMetrics():TextLineMetrics { return _field.getLineMetrics(_field.numLines - 1); }
		
		public function get textScrollX():Number { return _textScroll.x; }
		public function set textScrollX(x:Number):void
		{
			_textScroll.x = x;
			updateTextBuffer();
		}
		
		public function get textScrollY():Number { return _textScroll.y; }
		public function set textScrollY(y:Number):void
		{
			_textScroll.y = y;
			updateTextBuffer();
		}
		
		protected var _textRect:Rectangle;
		protected var _textScroll:Point;
	}

}