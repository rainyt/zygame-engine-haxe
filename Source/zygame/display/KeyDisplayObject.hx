package zygame.display;

import zygame.display.TouchDisplayObject;
import openfl.events.KeyboardEvent;
import zygame.core.GameCore;

class KeyDisplayObject extends TouchDisplayObject{
    
    /**
     * 双击键相应有效时间 
     */
    public static var doubleKeyTime:Int = 20;

    /**
     *  当前按下的key
     */
    private var _key : Int = 0;
    
    /**
     *  当前按下的所有键
     */
    private var _downkey:Array<Int> = [];

    /**
     *  双击键敏感度
     */
    private var _doubleKeyTime : Int = 20;
    private var _doubleKeys : Array<Int> = [];

    public function new(){
        super();    
    }

    /**
     * 按下键回调
     * @param key 按下的键码
     */
    public function onDown(key:Int):Void
    {
        pushKey(key);
    }
    
    /**
     * 追加键控 
     * @param key
     */
    public function pushKey(key : Int) : Void
    {
        if (_downkey.indexOf(key) == -1)
        {
            _doubleKeys.push(key);
            _doubleKeyTime = doubleKeyTime;
            _downkey.push(key);
        }
    }
    
    /**
     * 移除键控 
     * @param key
     */
    public function removeKey(key : Int) : Void
    {
        var i : Int = _downkey.indexOf(key);
        if (i != -1)
        {
            _downkey.splice(i,1);
            if (_doubleKeyTime <= 0)
            {
                clearDoubleKey();
            }
        }
    }
    
    /**
     *  清空双击键值
     */
    public function clearDoubleKey() : Void
    {
        _doubleKeys.splice(0, _doubleKeys.length);
    }
    
    /**
     * UpKey模拟 
     * @param key 松开的键码
     */
    public function onUp(key : Int) : Void
    {
        removeKey(key);
    }
    
    /**
     * 启动键控
     */
    public function listenerKey() : Void
    {
        GameCore.keyCore.addKeyEvent(this);
    }
    
    /**
     * 清理键控
     */
    public function clearKey() : Void
    {
        GameCore.keyCore.removeKeyEvent(this);
    }
    
    /**
     * 按下
     */
    public function onKeyDown(e : KeyboardEvent) : Void
    {
        if (_key != e.keyCode)
        {
            _key = e.keyCode;
            onDown(_key);
        }
    }
    
    /**
     * 按下
     */
    public function onKeyUp(e : KeyboardEvent) : Void
    {
        if (_key == e.keyCode)
        {
            _key = -1;
        }
        onUp(e.keyCode);
    }
    
    /**
     *  这里实现了双击处理事件，但如果该容器没有执行onFrame，则意味着不支持doubleKey。
     */
    override public function onFrame() : Void
    {
        super.onFrame();
        if (_doubleKeyTime > 0)
        {
            _doubleKeyTime--;
        }
    }
    
    /**
     * 是否按下某键 
     * @param key
     * @return 
     */
    public function isKeyDown(key : Int) : Bool
    {
        return _downkey.indexOf(key) != -1;
    }
    
    /**
     * 是否双击了某个按键 
     * @param key
     * @return 
     */
    public function isKeyDoubleDown(key : Int) : Bool
    {
        if (_doubleKeys.length > 1)
        {
            return _doubleKeys[_doubleKeys.length - 1] == key && _doubleKeys[_doubleKeys.length - 2] == key;
        }
        return false;
    }
    
    /**
     * 是否松开某键 
     * @param key
     * @return 
     */
    public function isKeyUp(key : Int) : Bool
    {
        return Lambda.indexOf(_downkey, key) == -1;
    }
    
    /**
     *  获取所有的downkeys
     *  @return Array<Int>
     */
    public function getDownKeys() : Array<Int>
    {
        return this._downkey;
    }
    
    /**
     *  清理所有的downkey
     */
    public function clearDownKeys() : Void
    {
        _downkey = [];
    }
    
    /**
     *  释放键控
     */
    override public function dispose() : Void
    {
        super.dispose();
        this.clearKey();
    }

}