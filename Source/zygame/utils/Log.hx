package zygame.utils;

import openfl.text.TextField;
import openfl.display.Stage;

class Log extends TextField {

    private static var context:Log;

    /**
     *  将log输出测试
     */
    public static function debug(stage:Stage):Void
    {
        stage.addChild(new Log());
        context.width = stage.stageWidth;
        context.height = stage.stageHeight;
    }

    /**
     *  输出内容
     *  @param message - 消息
     */
    public static function print(message:String,isClean:Bool = false):Void
    {
        if(context != null)
        {
            if(isClean)
                context.text = message;
            else
                context.appendText(message + "\n");
            context.scrollV = context.maxScrollV;
        }
    }

    /**
     *  Log输出
     */
    public function new()
    {
        super();
        context = this;
    }


}