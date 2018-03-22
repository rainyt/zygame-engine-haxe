package zygame.display;

import zygame.display.KeyDisplayObject;

import nape.callbacks.CbType;
import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.dynamics.Arbiter;
import nape.dynamics.CollisionArbiter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.space.Space;
import nape.util.ShapeDebug;
import zygame.core.CoreStarup;
import starling.display.DisplayObject;
import zygame.data.IgnoreData;
import zygame.map.BaseMap;
import zygame.map.MapliveMap;
import zygame.core.GameCore;

/**
 *  世界基类，用于实现游戏内容的主要框架
 */
class World extends KeyDisplayObject {

    /**
     *  世界的比例
     */
    public static var worldScale : Float = 1.3;

    /**
     *  默认的世界入口
     */
    public static var defalutClass : Class<Dynamic> = World;

    /**
     *  物理引擎的迭代计算
     */
    public static var velocityIterations : Int = 10;
    
    /**
     *  物理引擎的迭代计算
     */
    public static var positionIterations : Int = 10;

    /**
     *  摄像头偏移X
     */
    public var cameraPx : Float = 0.5;
    
    /**
     *  摄像头偏移Y
     */
    public var cameraPy : Float = 0.4;

    /**
     *  物理框架
     */
    private var _nape:Space;
    public var nape(get,never):Space;
    private function get_nape():Space
    {
        return _nape;
    }

    /**
     *  测试渲染物理框架
     */
    private var _debug:ShapeDebug;

    /**
     *  用于计算
     */
    private var arbiter : Arbiter;

    /**
     *  地图渲染
     */
    public var map(get,never):BaseMap;
    private var _map:BaseMap = null;
    private function get_map():BaseMap
    {
        return _map;
    }

    /**
     *  记录当前控制角色对象
     */
    private var _role:BaseRole;
    public var role(get,set):BaseRole;
    public function get_role():BaseRole
    {
        return _role;
    }
    public function set_role(r:BaseRole):BaseRole
    {
        _role = r;
        return _role;
    }

    public function new(mapName:String,toName:String){
        super();
        this.targetName = mapName;
        data = {};
        data.mapName = mapName;
        data.toName = toName;
        this.create();
    }

    /**
     *  开始建立世界
     */
    public function create():Void
    {
        _nape = new Space(new Vec2(0, 5000));
        // //碰撞侦听
        var preListener:PreListener = new PreListener(InteractionType.ANY, CbType.ANY_BODY, CbType.ANY_BODY, onPre);
        _nape.listeners.add(preListener);
        // var collisionListener : InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, CbType.ANY_BODY, CbType.ANY_BODY, onCollide);
        // _nape.listeners.add(collisionListener);
    }

    override public function onInit():Void
    {
        //创建地图渲染
        if(targetName != null)
        {
            _map = new MapliveMap(targetName,this);
            _map.world = this;
            this.addChild(map);
        }
        //创建视角
        if(CoreStarup.getInstance().drawDisplayObjectContainerDebug)
           _debug = new ShapeDebug(1024, 1024);
    }

    override public function onFrame():Void
    {
        super.onFrame();
        //物理引擎刷新
        refershNape();
    }

     /**
     * 刷新物理引擎
     */
    public function refershNape() : Void
    {
        if (nape == null)
        {
            // trace("Waring:nape is null!");
            return;
        }
        nape.step(1 / 60, velocityIterations, positionIterations);
        var body : Body;
        var graphic : DisplayObject;
        var i : Int = 0;
        while (i < _nape.liveBodies.length)
        {
            //遍历这个BodyList对象，并通过BodyList.at(index)方法获取每个刚体的引用，同时获取贴图对象引用    
            body = _nape.liveBodies.at(i);
            graphic = try cast(body.userData.ref, DisplayObject) catch(e:Dynamic) null;
            if (graphic != null)
            {    
                graphic.x = body.position.x;
                graphic.y = body.position.y;
                graphic.rotation = (body.rotation);
            }
            i++;
        }
        
        
        //Debug渲染
        if (_debug != null)
        {
            _debug.clear();
            _debug.flush();
            _debug.drawCollisionArbiters = true;
            _debug.draw(_nape);
            _debug.display.x = this.x - 32;
            _debug.display.y = this.y - 32;
            _debug.display.scaleY = this.scaleX;
            _debug.display.scaleX = this.scaleX;
            CoreStarup.getInstance().stage.addChild(_debug.display);
        }
    }

    override public function onDown(key:Int):Void
    {
        super.onDown(key);
        if(role != null)
            role.onDown(key);
    }

    override public function onUp(key:Int):Void
    {
        super.onUp(key);
        if(role != null)
            role.onUp(key);
    }

    private function onPre(e:PreCallback):PreFlag
    {
        var collsion:CollisionArbiter = e.arbiter.collisionArbiter;
        if(collsion == null)
            return PreFlag.ACCEPT;
        var ignoreDataA:IgnoreData = null;
        var ignoreDataB:IgnoreData = null;
        if(collsion.body1 != null){
            if(collsion.body1.userData.noHit == true)
                return PreFlag.IGNORE;
            if(collsion.body1.userData.ignoreData != null)
                ignoreDataA = cast(collsion.body1.userData.ignoreData,IgnoreData);
        }
        if(collsion.body2 != null){
            if(collsion.body2.userData.noHit == true)
                return PreFlag.IGNORE;
            if(collsion.body2.userData.ignoreData != null)
                ignoreDataB = cast(collsion.body2.userData.ignoreData,IgnoreData);
        }
        if(ignoreDataA != null && ignoreDataB != null)
        {
            return ignoreDataA.cheakIgnore(ignoreDataB)?PreFlag.IGNORE:PreFlag.ACCEPT;
        }
        return PreFlag.ACCEPT;
    }

    override public function addChild(display:DisplayObject):DisplayObject
    {
        return super.addChild(display);
    }
}