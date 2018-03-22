package zygame.display;

import zygame.utils.Log;
import zygame.display.RefRole;
import zygame.display.World;
import zygame.data.RoleAttributeData;
import nape.shape.Polygon;
import nape.phys.BodyType;
import zygame.utils.FPSUtil;
import zygame.data.RoleData;
import zygame.core.GameCore;
import zygame.data.RoleFrameActionGroup;
import zygame.data.RoleFrameData;
import openfl.ui.Keyboard;
import nape.geom.Vec2;
import zygame.data.IgnoreData;
import zygame.data.HitDatas;
import zygame.data.HitBody;
import nape.dynamics.Arbiter;
import nape.phys.Body;
import zygame.data.RefType;
import nape.dynamics.ArbiterIterator;
import zygame.data.BeHitData;
import zygame.utils.ZYMath;
import nape.callbacks.PreFlag;
import zygame.display.SpriteEffectDisplayObject;
import zygame.data.EffectData;
import zygame.display.EffectDisplayObject;
import nape.phys.BodyList;
import nape.geom.Geom;

/**
 *  逻辑处理
 */
class BaseRole extends RefRole{

    /**
     *  当前帧
     */
    public var frame:Int = 0;

    /**
     *  用于计算FPS的刷新
     */
    public var fps:FPSUtil;

    /**
     *  角色动作数据
     */
    public var roleData:RoleData;

    /**
     *  动作组
     */
    public var actionGroup:RoleFrameActionGroup;

    /**
     *  动作
     */
    public var action(get,set):String;
    private var _lastAction:String = "";
    private var _action:String = "";
    private function get_action():String
    {
        return _action;
    }
    private function set_action(str:String):String
    {
        if(isLock())
            return _action;
        _action = str;
        actionGroup = roleData.actions.get(str);
        if(_action != _lastAction)
        {
            _lastAction = _action;
            go(0,true);
        }
        return _action;
    }

    /**
     *  角色属性
     */
    public var attribute:RoleAttributeData;

    /**
     *  跳跃力计算
     */
    private var _jumpMath:Int;
    private var _isJump:Bool = false;

    /**
     *  是否为锁定动作
     */
    private var _isLock:Bool = false;

    /**
     *  激活键
     */
    private var _keyActivation:Int;

    /**
     *  碰撞数据管理，这里包含技能碰撞块，角色普通攻击碰撞块
     */
    private var _hitDatas:HitDatas;

    /**
     *  普通攻击块
     */
    private var _hitBody:HitBody;

    /**
     *  用于计算攻击数据，这个参数可以随意更改，并不会修改到原来的值
     */
    private var _beHitData:BeHitData;

    /**
     *  队伍值
     */
    public var troop:Int;

    /**
     *  用于计算被击效果
     */
    private var _hitX:Float = 0;
    private var _hitY:Float = 0;
    private var _straight:Int = 0;

     /**
     *  如果碰撞了地图
     */
    private var _isHitMap:Bool = false;

    /**
     *  是否可以左右移动
     */
    private var _isCanMove:Bool = false;

    public function new(roleTarget : String, xz : Float, yz : Float, pworld : World, fps : Int = 24, pscale : Float = 1, troop : Int = -1, roleAttr : RoleAttributeData = null)
    {
        super();
        this.troop = troop;
        roleData = GameCore.roleManager.roleDataManager.getRoleData(roleTarget);
        this.targetName = roleTarget;
        world = pworld;
        this.posx = xz;
        this.posy = yz;
        this.fps = new FPSUtil(fps);
        attribute = roleAttr;
        _hitDatas = new HitDatas(this);
        _beHitData = new BeHitData(null);
        //当属性为空时，则新建一个
        if(attribute == null)
        {
            attribute = new RoleAttributeData();
        }
    }

    /**
     *  初始化
     */
    override public function onInit():Void
    {
        super.onInit();
        //开始创建身体
        this.onBodyCreate();
        //自动加入帧控制
        this.addToParentFrameEvents();
        //默认待机动作
        action = "待机";
        //默认的忽略数据
        this.ignoreData = IgnoreData.ROLE;
    }

    /**
     *  身体被创建
     */
    public function onBodyCreate():Void
    {
        createBody(Polygon.rect(-5,-110,10,110),BodyType.DYNAMIC);
        
    }

    /**
     *  达到某一帧
     *  @param at - 下标为0的at帧
     *  @param isDraw - 是否立即绘制
     */
    public function go(at:Int,isDraw:Bool = false):Void
    {
        frame = at;
        if(isDraw)
            onDraw();
    }

    override public function onFrame():Void
    {
        super.onFrame();
        //计算向量碰撞情况
        this.onArbitersMath();
        //僵直计算
        if(_straight > 0)
            _straight --;
        //激活键计算
        if(_keyActivation > 0)
            _keyActivation --;
        //实现移动逻辑
        this.onMove();
        //实现每帧更新
        if(this.fps.update())
        {
            frame ++;   
            //如果动作已不一样，强制反0，或者当帧数大于动作时，会进行归0        
            if(_lastAction != action)
            {
                frame = 0;
            }
            else if(frame >= actionGroup.count())
            {
                if(isStraight())
                    frame = actionGroup.count()-1;
                else
                    stopSkill();
            }
            //判断停顿点处理
            if(currentFrame().stop && _keyActivation == 0)
            {
                stopSkill();
            }
            //实现动作变更
            this.onActionState();
            //开始绘制特效
            this.onEffect();
            //开始绘制画面
            this.onDraw();
        }
        //攻击数据计算
        onHitData();        
    }

    public function onEffect():Void
    {
        if(currentFrame().effectDatas != null)
        {
            var i:Int = 0;
            while(i < currentFrame().effectDatas.length)
            {   
                //映射
                //Type.resolveClass
                var effectData:EffectData = currentFrame().effectDatas[i];
                var effect:EffectDisplayObject = new SpriteEffectDisplayObject(effectData.name(),effectData,this);
                effect.world = world;   
                world.addChild(effect);
                i++;
            }
            trace("存在特效攻击");
        }
    }

    public function onArbitersMath():Void
    {
        _isHitMap = false;
        _isCanMove = true;
        if(this.body.arbiters.length > 0)
        {
            var ai:ArbiterIterator = this.body.arbiters.iterator();
            while(ai.hasNext())
            {
                var a:Arbiter = ai.next();
                if(a.state != PreFlag.IGNORE){
                    var collisionAngle:Float = ZYMath.rad2deg(a.collisionArbiter.normal.angle);
                    collisionAngle = Math.abs(collisionAngle);
                    if(collisionAngle > 45 && collisionAngle < 135)
                    {
                        _isHitMap = true;
                    }
                    else
                    {
                        var xz:Float = a.collisionArbiter.normal.x;
                        if(a.body1 != this.body)
                        {
                            xz *= -1;
                        }
                        if(isKeyDown(Keyboard.A) && xz < -0.7)
                        {
                            _isCanMove = false;
                        } 
                        else if(isKeyDown(Keyboard.D) && xz > 0.7)
                        {
                            _isCanMove = false;
                        } 
                    }
                }
            }
        }
    }

    /**
     *  攻击数据计算
     */
    public function onHitData():Void
    {
         var hitBody:HitBody = null;
        if(currentFrame().hitPoint == null){
            if(_hitBody != null)
            {
                if(_hitBody.beHitData.activationMinFrame() > currentFrame().at || _hitBody.beHitData.activationMaxFrame() < currentFrame().at)
                {
                    if(_hitBody != null)
                        _hitBody.body.space = null;
                    return;
                }
            }
            else
            {
                if(_hitBody != null)
                    _hitBody.body.space = null;
                return;
            }
        }
        else{
            hitBody = _hitDatas.getHitBody(currentFrame().id,currentFrame().beHitData,currentFrame().hitPoint);
            if(_hitBody != hitBody)
            {
                if(_hitBody != null)
                    _hitBody.body.space = null;
                _hitBody = hitBody;
                _hitBody.body.space = world.nape;
            }
        }
        _hitBody.setScaleX(this.scaleX>0?1:-1);
        _hitBody.body.position.x = body.position.x;
        _hitBody.body.position.y = body.position.y;
        if(_hitBody != null)
        { 
            onHitArbiter(_hitBody);
        } 
    }

    /**
     *  攻击统一处理，特效/普通攻击都在这里处理
     *  @param a - 
     */
    public function onHitArbiter(pbody:HitBody):Void
    {
        if(pbody.body.arbiters.length == 0)
            return;
        trace("攻击敌人",pbody.body.arbiters.length);
        var ai:ArbiterIterator = pbody.body.arbiters.iterator();
        //copy攻击数据
        _beHitData.copy(pbody.beHitData);
        _beHitData.hitX *= this.scaleX;
        while(ai.hasNext()){
            var a:Arbiter = ai.next();
            var enemy:BaseRole = null;
            var enemyBody:Body = null;
            enemyBody = a.body1.userData.ref == pbody?a.body2:a.body1;
            if(enemyBody != null && enemyBody.userData.refType == RefType.ROLE){
                enemy = cast(enemyBody.userData.ref,BaseRole);
                onHitEnemy(enemy);
            }
        }
    }

    /**
     *  成功攻击敌人触发
     *  @param enemy - 
     */
    public function onHitEnemy(enemy:BaseRole):Void
    {
        if(enemy.troop != this.troop){
            enemy.onBeHit(_beHitData);
        }
    }

    /**
     *  被攻击触发
     *  @param hitdata - 
     */
    public function onBeHit(hitdata:BeHitData):Void
    {
        if(hitdata.hitX != 0 && !Math.isNaN(hitdata.hitY))
            this._hitX = hitdata.hitX;
        if(hitdata.hitY != 0 && !Math.isNaN(hitdata.hitY)){
            this._hitY = -hitdata.hitY;  
            this._isJump = true;    
            this._jumpMath = Std.int(this._hitY * 0.5);
        }
        this._straight = hitdata.straight == 0?30:hitdata.straight;
        trace("击中",this._straight);
        // Log.print("HitX"+this._hitX+"_"+this._jumpMath);
    }

    /**
     *  如果在僵直中
     *  @return Bool
     */
    public function isStraight():Bool
    {
        return  this._straight > 0;
    }

    /**
     *  获取是否在跳跃中
     *  @return Bool
     */
    public function isJump():Bool
    {
        return _isJump;
    }

    /**
     *  实现移动
     */
    public function onMove():Void
    {  
        //获取当前的角色是否碰到地图
        var hitMap:Bool = this.isHitMap();
        if(!hitMap && !isJump()){
            //判断是否可以重新落地
            var list:BodyList = this.getBodyAtPos(this.posx,this.posy + 10);
            if(list.length > 0)
            {
                var hitBody2:Body = null;
                var bodyIndex:Int = 0;
                while(bodyIndex < list.length)
                {
                    var body2:Body = list.at(bodyIndex);
                    if(body2.userData.noHit != true)
                    {
                        hitBody2 = body2;
                        break;
                    }
                    bodyIndex ++;
                }
                if(hitBody2 != null){
                    //允许重新落地
                    var d:Float = Geom.distanceBody(hitBody2,this.body,ZYMath.vec2(),ZYMath.vec2());
                    this.posy += d;
               }
            }
            else
            {
                _isJump = true;
                _jumpMath = 0;
            }
        }

        //是否跳跃状态
        if(isJump())
        {
            if(!isLock() || actionGroup.allowJumpMove){
                if(hitMap && _jumpMath >= 0){
                    _isJump = false;
                }
                else
                {
                    //值越大就跳跃得越高
                    _jumpMath ++;
                    yMove(_jumpMath);
                }
            }
        }
        

        //移动状态
        //僵直状态
        if(isStraight())
        {
            xMove(_hitX);
            if(!isJump() && _hitX != 0)
                _hitX += _hitX > 0?-1:1;
        }
        else if(isLock() && !actionGroup.allowJumpMove){
            //释放技能时，X轴移动将锁定
            xMove(currentFrame().moveX/(60/fps.fps) * this.scaleX);
            yMove(currentFrame().moveY/(60/fps.fps));
        }
        else if(isMoveing() && isCanMove())
        {
            if(isKeyDown(Keyboard.A))
                xMove(-attribute.speed);
            else if(isKeyDown(Keyboard.D))
                xMove(attribute.speed);
        }
        else
        {
            xMove(0);
        }

    }

    /**
     *  动作状态变更
     */
    public function onActionState():Void
    {
        if(isStraight()){
            action = "受伤";
        }
        else if(isLock()){
            if(currentFrame().stop){
                if(isKeyDown(Keyboard.A))
                    this.scaleX = -1;
                else if(isKeyDown(Keyboard.D))
                    this.scaleX = 1;
            }
        }
        else if(isJump()){
            //跳跃中
            action = _jumpMath > 0?"降落":"跳跃";
        }
        else if(isMoveing())
        {
            action = "行走";
            if(isKeyDown(Keyboard.A))
                this.scaleX = -1;
            else if(isKeyDown(Keyboard.D))
                this.scaleX = 1;
        }
        else
        {
            action = "待机";
        }
    }

    /**
     *  绘制，用于实现角色的显示绘制
     */
    public function onDraw():Void
    {

    }

    /**
     *  按下事件实现
     *  J - 攻击
     *  K - 跳跃
     *  UIOP - 技能
     *  L - 快速移动
     *  如果需要重新设定这个，请重写
     *  @param key - 
     */
    override public function onDown(key:Int):Void
    {
        super.onDown(key);
        switch(key)
        {
            case Keyboard.J:
                //普通攻击
                _keyActivation = 16;
                playSkill(isJump()?"空中攻击":"普通攻击");
            case Keyboard.A:
                //左移动
            case Keyboard.D:
                //右移动
            case Keyboard.K:
                //跳跃
                jump();
            case Keyboard.U:
                _keyActivation = 16;
                //技能释放
            case Keyboard.I:
                _keyActivation = 16;
                //技能释放
            case Keyboard.O:
                _keyActivation = 16;
                //技能释放
            case Keyboard.P:
                _keyActivation = 16;
                //技能释放
            case Keyboard.L:
                _keyActivation = 16;
                //技能释放
        }
    }

    /**
     *  释放技能，如普通攻击、技能等
     *  释放技能的过程中，将不会被强制打算，除非受到了攻击
     *  @param action - 动作名
     */
    public function playSkill(action:String):Void
    {
        //锁定中不可切换技能
        if(isLock())
        {
            return;
        }
        else
        {
            this.action = action;
            _isLock = true;
        }
    }

    /**
     *  停止技能释放
     */
    public function stopSkill():Void
    {
        if(_hitBody != null){
            _hitBody.body.space = null;
            _hitBody = null;
        }
        if(isLock())
            _isLock = false;
        frame = 0;
    }

    /**
     *  是否锁定目标
     *  @return Bool
     */
    public function isLock():Bool
    {
        return _isLock;
    }

    /**
     *  跳跃
     */
    public function jump():Void
    {
        if(isJump())
            return;
        if(isLock())
        {
            if(actionGroup.allowJump){
                stopSkill();
            }
            else
                return;
        }
        //设置跳跃计算
        _jumpMath = -attribute.jump;
        _isJump = true;
    }

    /**
     *  获取当前帧的帧数据
     *  @return RoleFrameData
     */
    public function currentFrame():RoleFrameData
    {
        return actionGroup.frames[frame];
    }

    /**
     *  是否按了移动键
     *  @return Bool
     */
    public function isMoveing():Bool
    {
        return isKeyDown(Keyboard.A) || isKeyDown(Keyboard.D);
    }   

    /**
     *  角色不能主动旋转
     */
    override public function createBody(arr:Array<Vec2>,type:BodyType):Void
    {
        super.createBody(arr,type);
        body.allowRotation = false;
        body.userData.refType = RefType.ROLE;
        body.gravMass = 0;
    }


     /**
     *  是否碰到地图
     *  @return Bool
     */
    public function isHitMap():Bool
    {
        return _isHitMap;
    }

    /**
     *  是否可以移动
     *  @return Bool
     */
    public function isCanMove():Bool
    {
        return _isCanMove;
    }
}