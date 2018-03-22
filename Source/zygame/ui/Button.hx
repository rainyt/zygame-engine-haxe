package zygame.ui;

import zygame.ui.BaseButton;
import starling.text.TextField;
import starling.textures.Texture;
import starling.display.Image;

class Button extends BaseButton {
    
    public var downTexture:Texture;
    public var upTexture:Texture;
    private var _image:Image;
    private var _textDisplay:TextField;

    /**
     *  实现简单的按钮
     *  @param text - 
     */
    public function new(text:String,downTexture:Texture = null,upTexture:Texture = null):Void
    {
        super();
        //图形
        this.upTexture = upTexture;
        this.downTexture = downTexture;
        if(this.upTexture == null && this.downTexture != null)
            this.upTexture = this.downTexture;
        if(this.upTexture != null)
        {
            _image = new Image(this.upTexture);
            this.addChild(_image);
        }
        //文本
        if(text != null)
        {
            _textDisplay = new TextField(_image != null?Std.int(_image.width):100,_image != null?Std.int(_image.height):100,text);
            this.addChild(_textDisplay);
        }
       
    }

    public var text(get,set):String;
    private function set_text(str:String):String
    {
        if(_textDisplay != null)
            _textDisplay.text = str;
        return str;
    }
    private function get_text():String
    {
        if(_textDisplay == null)
            return null;
        return _textDisplay.text;
    }

    override public function onUpAnime():Void
    {
        super.onUpAnime();
        if(_image != null && this.upTexture != null)
        {
            _image.texture = this.upTexture;
        }
    }

    override public function onDownAnime():Void
    {
        super.onDownAnime();
        if(_image != null && this.downTexture != null)
        {
            _image.texture = this.downTexture;
        }
    }

    

}