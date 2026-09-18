

--将16进制串转换为字符串
function hex2str(hex)
	--判断输入类型
	if (type(hex)~="string") then
		return nil,"hex2str invalid input type"
	end
	--拼接字符串
	local index=1
	local ret=""
	for index=1,hex:len() do
		ret=ret..string.format("%02X",hex:sub(index):byte())
	end
 
	return ret
end
--将字符串按格式转为16进制串
function str2hex(str)
	--判断输入类型	
	if (type(str)~="string") then
	    return nil,"str2hex invalid input type"
	end
	--滤掉分隔符
	str=str:gsub("[%s%p]",""):upper()
	--检查内容是否合法
	if(str:find("[^0-9A-Fa-f]")~=nil) then
	    return nil,"str2hex invalid input content"
	end
	--检查字符串长度
	if(str:len()%2~=0) then
	    return nil,"str2hex invalid input lenth"
	end
	--拼接字符串
	local index=1
	local ret=""
	for index=1,str:len(),2 do
	    ret=ret..string.char(tonumber(str:sub(index,index+1),16))
	end
 
	return ret
end









function IsLastDay(time)

	--设置服务器时间
	local list= Split(time, " ")
	local day_list =  Split(list[1], "-")
	local sec_list =  Split(list[2], ":")
	local time_list = {
	year = 0,
	mon = 0,
	day = 0,
	hour = 0,
	min = 0,
	sec = 0,
	}


	time_list.year = day_list[1]
	time_list.mon = day_list[2]
	time_list.day = day_list[3]
	time_list.hour = sec_list[1]
	time_list.min = sec_list[2]
	time_list.sec = sec_list[3]

	local dayTable = {31,28,31,30,31,30,31,31,30,31,30,31}
	

	--判断闰年
	if(time_list.year%4==0 and time_list.year%100~=0) or (time_list.year%100==0 and time_list.year%400==0) then
		--闰年 二月份有29天
		if tonumber(time_list.mon)==2 then
			if tonumber(time_list.day)==29 then
				return true
			end
	
			return false
		end

	else
		--非闰年

	end
	if dayTable[tonumber(time_list.mon)]==tonumber(time_list.day) then
		return true
	end

	return false


end



if IsServer() then
	function FireDefaultMoveEvent(caster,ability)
		local keys = {
			caster = caster,
			ability = ability,

		}
		if caster.tSourceModifierEvents and caster.tSourceModifierEvents[MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE] then
			local tModifiers = caster.tSourceModifierEvents[MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(caster) and IsValid(hModifier) and hModifier.OnCastDefaultMove then
					hModifier:OnCastDefaultMove(keys)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		if caster.tTargetModifierEvents and caster.tTargetModifierEvents[MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE] then
			local tModifiers = caster.tTargetModifierEvents[MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.OnCastDefaultMove then
					hModifier:OnCastDefaultMove(keys)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE] then
			local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_CAST_DEFAULT_MOVE]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.OnCastDefaultMove then
					hModifier:OnCastDefaultMove(keys)
				else
					table.remove(tModifiers, i)
				end
			end
		end
	end
	
end


