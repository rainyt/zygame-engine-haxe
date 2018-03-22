package zygame.core;

import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import zygame.display.KeyDisplayObject;

/**
	 * 键控管理系统，唯一键控，记录按下了什么键，反馈等。 
	 * @author grtf
	 */
class KeyCore
{
    /**
     *  记录所有用了键控的对象
     */
    private var _keys : Array<KeyDisplayObject> = new Array<KeyDisplayObject>();

    /**
     *  按下的键控实现
     */
    private var _keyDown : Array<Dynamic> = [];

    /**
     *  当前的按下的键
     */
    private var _key : Int = -1;

    /**
     *  记录舞台
     */
    private var _stage : Stage;
    
    /**
     *  初始化一个键控事件
     *  @param stage - 传入本机舞台
     */
    public function new(stage : Stage)
    {
        _stage = stage;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }
    
    /**
		 * 添加键控事件 
		 * @param keyDisplay
		 */
    public function addKeyEvent(keyDisplay : KeyDisplayObject) : Void
    {
        _keys.push(keyDisplay);
    }
    
    /**
		 * 删除键控事件 
		 * @param keyDisplay
		 */
    public function removeKeyEvent(keyDisplay : KeyDisplayObject) : Void
    {
        var index : Int = Lambda.indexOf(_keys, keyDisplay);
        if (index != -1)
        {
            _keys.splice(index, 1)[0];
        }
    }
    
    /**
		 * 重新广播键控值
		 */
    public function resetPort() : Void
    {
        for (i in Reflect.fields(_keyDown))
        {
            for (i2 in Reflect.fields(_keys))
            {
                Reflect.field(_keys, i2).onDown(Reflect.field(_keyDown, i));
            }
        }
    }
    
    /**
		 * 模拟点击，适用于触摸 
		 * @param code
		 */
    public function onDown(code : Int) : Void
    {
        _stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, false, 0, code));
    }
    
    /**
		 * 模拟松开，适用于触摸 
		 * @param code
		 */
    public function onUp(code : Int) : Void
    {
        _stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, 0, code));
    }
    
    private function onKeyDown(e : KeyboardEvent) : Void
    {
        if (Lambda.indexOf(_keyDown, e.keyCode) == -1)
        {
            _keyDown.push(e.keyCode);
        }
        var i:Int = 0;
        while(i < _keys.length)
        {
            _keys[i].onKeyDown(e);
            i++;
        }
    }
    
    private function onKeyUp(e : KeyboardEvent) : Void
    {
        var index : Int = Lambda.indexOf(_keyDown, e.keyCode);
        if (index != -1)
        {
            _keyDown.splice(index, 1)[0];
        }
        var i:Int = 0;
        while(i < _keys.length)
        {
            _keys[i].onKeyUp(e);
            i++;
        }
    }
}
