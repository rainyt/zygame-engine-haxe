
import zygame.ui.ListItemRender;
import starling.display.Quad;
import zygame.layout.FreeLayoutData;

@:keep
class DemoItem extends ListItemRender{

    public function new()
    {
        super();
    }

    override public function onInit():Void
    {
        super.onInit();
        var q:Quad = new Quad(100,100,0xff00ff);
        q.alpha = 0.3;
        this.addChildToLayout(q,new FreeLayoutData(0,0,Math.NaN,Math.NaN,Math.NaN,Math.NaN));
    }

    override public function setData(value:Dynamic):Void
    {
        super.setData(value);
       
    }

}