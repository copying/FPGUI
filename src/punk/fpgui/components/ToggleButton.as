package punk.fpgui.components 
{
	import punk.fpgui.GUIEntity;
	import punk.fpgui.GUIGraphicList;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Copying
	 */
	public class ToggleButton extends GUIEntity
	{
		public var checked:Boolean = false;
		
		public function ToggleButton(x:Number = 0, y:Number = 0, normal:* = null, over:* = null, pressed:* = null, normalChecked:* = null, overChecked:* = null, pressedChecked:* = null, text:String = "", textOffsetX:Number = 0, textOffsetY:Number = 0, textOptions:Object = null) 
		{
			if (!textOptions) textOptions = { size: 16, color: 0x0000000, wordWrap: true, align: "center", resizable: true };
			_text = new Text(text, textOffsetX, textOffsetY, textOptions);
			
			_graphics = new GUIGraphicList([normal, over, pressed, normalChecked, overChecked, pressedChecked, _text], [[0, 1, 2, 3, 4, 5], [6, 6, 6, 6, 6, 6]], 6);
			super(x, y, _graphics);
		}
		
		override protected function updateReference():uint
		{
			return state + (checked ? 3 : 0); 
		}
		
		override protected function click():void
		{
			checked = !checked;
		}
		
		private var _graphics:GUIGraphicList;
		private var _text:Text;
		
	}

}