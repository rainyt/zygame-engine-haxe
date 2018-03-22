package zygame.events;

import openfl.events.Event;

class GameCoreEvent extends Event{

    /**
     *  当游戏引擎初始化完毕触发
     */
    public static inline var INIT_COMPLETE:String = "init_complete";

    /**
     *  当游戏引擎初始化失败触发
     */
    public static inline var INIT_ERROR:String = "init_error";

    public function new(ptype:String)
    {
        super(ptype,false,false);
    }

}