package zygame.ui;

import zygame.ui.ListItemRender;
import starling.text.TextField;
import zygame.layout.FreeLayoutData;

@:keep
class DefalutItemRender extends ListItemRender {

    private var _text:TextField;

    public function new(){
        super();
    }

    override public function onInit():Void
    {
        super.onInit();
        _text = new TextField(100,32,"null");
        this.addChildToLayout(_text,new FreeLayoutData(0,0,Math.NaN,Math.NaN,Math.NaN,Math.NaN));
    }

    override public function setData(data:Dynamic):Void
    {
        super.setData(data);
        if(data != null)
            _text.text = Std.string(data);
    }

}