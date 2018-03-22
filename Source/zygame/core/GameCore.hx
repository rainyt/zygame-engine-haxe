package zygame.core;

import zygame.display.World;
import openfl.display.Stage;
import zygame.core.KeyCore;
import zygame.utils.RoleManager;
import starling.utils.AssetManager;
import zygame.utils.MapManager;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import starling.textures.Texture;
import openfl.events.EventDispatcher;
import zygame.events.GameCoreEvent;
import openfl.media.Sound;
import zygame.data.GameRoleData;


/**
 * 游戏的主要控制处理
 */
class GameCore extends EventDispatcher{
    
    /**
     * 游戏引擎的版本号
     */
    public static inline var VERSION:String = "0.0.1";

    /**
     *  默认的精灵表角色
     */
    public static var defalutSpriteRoleClass : Class<Dynamic>;

    public static function init(stage:Stage,projectPath:String):Void
    {
        trace("GameCore init!");
        _core = new GameCore(stage,projectPath);
    }
		
    /**
     * 获取当前运行的GameCore单例
     */
    private static var _core:GameCore;
    public static var currentCore(get,never):GameCore;
    private static function get_currentCore():GameCore
    {
        return _core;
    }

    /**
     *  获取当前运行的游戏世界
     */
    private static var _world:World;
    public static var currentWorld(get,never):World;
    private static function get_currentWorld():World
    {
        return _world;
    }

    /**
     *  获取键控核心
     */
    private static var _keyCore:KeyCore;
    public static var keyCore(get,never):KeyCore;
    private static function get_keyCore():KeyCore
    {
        return _keyCore;
    }

    /**
     *  获取角色资源管理
     */
    private static var _roleManager:RoleManager;
    public static var roleManager(get,never):RoleManager;
    private static function get_roleManager():RoleManager
    {
        return _roleManager;
    }

    private static var _gameRoleData:GameRoleData;
    public static var gameRoleData(get,never):GameRoleData;
    private static function get_gameRoleData():GameRoleData
    {
        return _gameRoleData;
    }

    /**
     *  地图资源管理
     */
    private static var _mapManager:MapManager;
    public static var mapManager(get,never):MapManager;
    private static function get_mapManager():MapManager
    {
        return _mapManager;
    }
    

    /**
     *  资源管理器
     */
    private static var _assets:AssetManager;
    public static var assets(get,never):AssetManager;
    private static function get_assets():AssetManager
    {
        return _assets;
    }

    public var projectPath:String;

    /**
     *  初始化游戏引擎
     *  @param stage - 本机舞台
     *  @param projectPath - project.xml路径
     */
    public function new(stage:Stage,projectPath:String){
        super();

        _keyCore = new KeyCore(stage);
        _assets = new AssetManager(1,false);
        _roleManager = new RoleManager();
        _mapManager = new MapManager();
        _gameRoleData = new GameRoleData();
        
        this.projectPath = projectPath;
        
    }

    public function initProject():Void
    {
        //开始载入projectPath
        var url:URLLoader = new URLLoader(new URLRequest(projectPath));
        url.addEventListener(Event.COMPLETE,onProjectComplete);
        url.addEventListener(IOErrorEvent.IO_ERROR,onProjectIOError);
    }

    /**
     *  当项目配置载入完成
     *  @param e - 
     */
    private function onProjectComplete(e:Event):Void
    {
        var url:URLLoader = cast(e.target,URLLoader);
        var xml:Xml = Xml.parse(Std.string(url.data));
        var head:String = xml.firstElement().get("dir");
        var childs:Iterator<Xml> = xml.firstChild().elements();
        while(true){
            var child:Xml = childs.next();
            if(child == null)
                break;
            GameCore.assets.enqueue([head+"/"+Std.string(child.get("path"))]);
        }
        GameCore.assets.loadQueue(onLoadQueue);
    }

    private function onLoadQueue(pro:Float):Void
    {
        if(pro == 1)
        {
            trace("初始化完毕！");
            //进行初始化游戏角色数据，如果游戏数据不存在时，则无法查询角色
            var gameRoleXml:Xml = getXml("fight");
            gameRoleData.init(gameRoleXml);
            //告知引擎数据初始化完毕
            this.dispatchEvent(new GameCoreEvent(GameCoreEvent.INIT_COMPLETE));
        }
        else
        {
            trace("初始化进度："+Std.int(pro*100)+"%");
        }
    }

    /**
     *  当项目配置失败时
     *  @param e - 
     */
    private function onProjectIOError(e:IOErrorEvent):Void
    {
        trace("project.xml配置异常：无法载入");
        this.dispatchEvent(new GameCoreEvent(GameCoreEvent.INIT_ERROR));
    }

    /**
     *  获取Xml配置
     *  @param id - 
     *  @return Xml
     */
    public static function getXml(id:String):Xml
    {
        var xml:Xml = assets.getXml(id);
        if(xml == null)
            xml = mapManager.assets.getXml(id);
        return xml;
    }

    /**
     *  获取纹理
     *  @param id - 使用文件名获取纹理，不需要后缀
     *  @return Texture
     */
    public static function getTexture(id:String):Texture
    {
        var texture:Texture = assets.getTexture(id);
        if(texture == null)
            texture = mapManager.assets.getTexture(id);
        return texture;
    }

    /**
     *  获取音源
     *  @param id - 使用文件获取音频，不需要后缀
     *  @return Sound
     */
    public static function getSound(id:String):Sound
    {
        var sound:Sound = assets.getSound(id);
        if(sound == null)
            sound = mapManager.assets.getSound(id);
        return sound;
    }

}