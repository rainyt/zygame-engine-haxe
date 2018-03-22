import zygame.ui.ScrollView;
import zygame.layout.VerticalLayout;
import zygame.layout.VerticalLayoutData;
import zygame.ui.Button;
import zygame.core.GameCore;

/**
 *  竖向模板
 */
class VLayout extends ScrollView
{
    private var _layoutData:VerticalLayoutData;

    public function new(){
        super(new VerticalLayout());
        _layoutData = new VerticalLayoutData();
    }

    override public function onInit():Void
    {
        super.onInit();
        var arr:Array<String> = ["生成角色","生成方块","打开窗口"];
        var i:Int = 0;
        while(i < arr.length)
        {
            var button:Button = new Button(arr[i],GameCore.getTexture("btn"));
            this.addChildToLayout(button,_layoutData);
            i++;
        }
        this.useScorllH = false;
    }
}