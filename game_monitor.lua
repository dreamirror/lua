game_monitor = {
	gc_time = 60;
};

game_monitor.__index = game_monitor;

function game_monitor:new()
	local class= {};
	self._memWeakTable = {};
	setmetatable(self._memWeakTable,{__mode="kv"});
	self.__memLeakMonitor = nil  
	setmetatable(class,game_monitor);
	return class;
end

function game_monitor:start(tblName,tbl)
	self:addTblToUnderMemLeakMonitor(tblName, tbl) 
	self:__memLeaksMonitoring();
end

function game_monitor:get_gc_tiem()
	return self.gc_time;
end

function game_monitor:update()

end

function game_monitor:addTblToUnderMemLeakMonitor(tblName, tbl)  
    if type(tbl) == "table" then
    	sprint('bingo');
    else
    	return
    end
    for i,v in pairs(tbl) do
    	self._memWeakTable[i] = 1; 
    end
end  

function game_monitor:__memLeaksMonitoring()  
    for k, v in pairs(self._memWeakTable) do  
        local str = str..string.format("  \n%s = %s", tostring(k), tostring(v))  
        sprint(str);
    end  
end  



--内存泄露单例
--tbl 要检查的table
game_monitor_single ={};
game_monitor_single.TEST_TIME = 5;
function game_monitor_single.begin(tbl)
    if chanel_config.debug ~= true then
        return;
    end

    if type(tbl) ~= "table" then
        sprint("target is not table");
        return;
    end
    game_monitor_single.tested = 0;

    game_monitor_single.weakTable = {};
    setmetatable(game_monitor_single.weakTable,{__mode="kv"});
    for i,v in pairs(tbl) do
        sprint(type(i))
        game_monitor_single.weakTable[v] = i; 
    end

    if game_monitor_single.timer_id then
        common_fun.destory_timer(activity_charge_pl.timer_id);
    else
        game_monitor_single.timer_id = common_fun.create_timer(1000, -1, "game_monitor_single.update")
    end
end

function game_monitor_single.update()
    sprint("game_monitor_single update");
    collectgarbage("collect")  
    collectgarbage("collect")  
    local str = ''
    for k, v in pairs(game_monitor_single.weakTable) do  
        str = str..string.format("  \n%s %s", tostring(k),tostring(v))  
        sprint(str);
    end
    sprint('-------------------------');  
end