modifier_generic_jump = advanced_modifier({})


function modifier_generic_jump:IsHidden() return true end
function modifier_generic_jump:IsDebuff() return false end
-- function modifier_generic_jump:IsStunDebuff() return false end
function modifier_generic_jump:IsPurgable() return true end
function modifier_generic_jump:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_generic_jump:RemoveOnDeath()
	return self.bRemoveOnDeath
end
function modifier_generic_jump:GetMotionPriority()
	return self.motionPriority 
end

function modifier_generic_jump:OnCreated( kv )
	if not IsServer() then return end
	self.interrupted = false
	self:InitDefaultParams( kv )
end

-- 有些参数在Oncreate就设置好 有些则无所谓 都放下面
function modifier_generic_jump:InitDefaultParams(keys)

	self.activity = keys.activity or 0
	self:SetStackCount( self.activity )
	self.activity_rate = keys.activity_rate or 1
	self.bIsForward = keys.bIsForward==1
	-- print("modifier_generic_jump:InitDefaultParams bIsForward=",self.bIsForward)

end

function modifier_generic_jump:InitJumpEffect(keys)
	if not IsServer() then return end
	self.destroy_tree_on_progresing  = keys.destroy_tree_on_progresing or false --位移过程中摧毁树木
	self.destroy_tree_on_progresing_radius = keys.destroy_tree_on_progresing_radius or 100
	self.destroy_tree_on_end = keys.destroy_tree_on_end or false  --位移结束时摧毁树木
	self.destroy_tree_on_end_radius = keys.destroy_tree_on_end_radius or 200 --位移结束时摧毁树木的半径


	self.motionPriority = keys.motionPriority or MODIFIER_PRIORITY_NORMAL
	self.bRemoveOnDeath = true
	if keys.bRemoveOnDeath~=nil then
		self.bRemoveOnDeath = keys.bRemoveOnDeath
	end	
	self.bStunned = false
	if keys.bStunned~=nil then
		self.bStunned = keys.bStunned
	end
	self.bRestricted = false
	if keys.bRestricted~=nil then
		self.bRestricted = keys.bRestricted
	end
	self.bInvulnerable = false
	if keys.bInvulnerable~=nil then
		self.bInvulnerable = keys.bInvulnerable
	end
	self.bShowHealthBar = true
	if keys.bShowHealthBar~=nil then
		self.bShowHealthBar = keys.bShowHealthBar
	end

	self.bLockToEnd = false
	if keys.bLockToEnd~=nil then
		self.bLockToEnd = keys.bLockToEnd
	end

	self.start_pos = keys.start_pos or self:GetParent():GetOrigin()

	self.target_pos = GetGroundPosition(keys.target_pos or self:GetParent():GetOrigin(),nil)
	if keys.target_height_offset then
		self.target_pos.z = self.target_pos.z + keys.target_height_offset
	end

	self.horizontal_distance = CalculateDistance(self.start_pos, self.target_pos)
	self.direction = CalculateDirection(self.target_pos,self.start_pos)
	self:GetParent():SetOrigin(self.start_pos)

	self.duration = keys.duration or 1 --默认跑1秒
	self.start_time = GameRules:GetGameTime()
	self.end_time = self.start_time + self.duration
	self.last_horizontal_update_time = self.start_time
	self.last_vertical_update_time = self.start_time
	self.height = keys.height or 0

	self.bCheckPath = true
	if  keys.bCheckPath~=nil then
		self.bCheckPath = keys.bCheckPath
	end
	if keys.bCheckvaildPosition~=nil then
		self.bCheckvaildPosition = keys.bCheckvaildPosition
		
	end
	self.last_vaild_position = self:GetParent():GetAbsOrigin()



	if keys.horizontal_function then
		self.horizontal_function = keys.horizontal_function
	end
	if keys.vertical_function then
		self.vertical_function = keys.vertical_function
		
	end
	if keys.endCallback then
		self.endCallback = keys.endCallback
	end

	-- if keys.endGesture then
	-- 	self.endGesture = keys.endGesture
	-- 	self.endGestureRate = keys.endGestureRate or 1
	-- 	self.endGesturePlayPoint = keys.endGesturePlayPoint or 0.95
	-- end
	self.callBackList = keys.callBackList or {}


	-- if not self:ApplyHorizontalMotionController() then
	-- 	self.interrupted = true
	-- 	print("modifier_generic_jump:OnCreated interrupted=",self.interrupted)
	-- 	self:Destroy()
	-- 	return
	-- end

	-- if not self:ApplyVerticalMotionController() then
	-- 	print("modifier_generic_jump:OnCreated interrupted2=",self.interrupted)
	-- 	self.interrupted = true
	-- 	self:Destroy()
	-- end



end


function modifier_generic_jump:OnDestroy()
	if not IsServer() then return end
	self._destroyed = true
	local pos = self:GetParent():GetOrigin()
	if self.destroy_tree_on_end then

		local caster = self:GetCaster()
		if caster then
			local trees = GridNav:GetAllTreesAroundPoint(pos, self.destroy_tree_on_end_radius, false)
			caster:CutDownTrees(trees,self:GetAbility(),nil)
		end
		
	end
	-- print("OnDestroy interrupted=",self.interrupted)


	-- print("OnDestroy bCheckvaildPosition=",self.bCheckvaildPosition)
	if self.bLockToEnd then
		self:GetParent():SetOrigin(self.target_pos)
	else
		if self.bCheckvaildPosition then
			-- FindClearSpaceForUnit(self:GetParent(), self.last_vaild_position, true)
			local final_pos = GetClearSpaceForUnit(self:GetParent(),self:GetParent():GetAbsOrigin())
			if GridNav:CanFindPath( self.last_vaild_position, final_pos ) then
				self.last_vaild_position = final_pos
			end
		
			FindClearSpaceForUnit(self:GetParent(), self.last_vaild_position, true)
		
		else
			FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
		end
		
		self:GetParent():RemoveHorizontalMotionController( self )
		self:GetParent():RemoveVerticalMotionController( self )
	end


	if self.endCallback then
		self.endCallback( self.interrupted )
	end

end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_jump:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	if self:GetStackCount()>0 then
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE )
	end

	return funcs
end

function modifier_generic_jump:GetModifierDisableTurning()
	if not self.bIsForward then return end
	return 1
end
function modifier_generic_jump:GetOverrideAnimation()
	return self:GetStackCount()
end

function modifier_generic_jump:GetOverrideAnimationRate()
	return self.activity_rate or 1
end


function modifier_generic_jump:CheckState()
	local state = {
		-- [MODIFIER_STATE_STUNNED] = self.bStunned or false,
		-- [MODIFIER_STATE_COMMAND_RESTRICTED] = self.bRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	if self.bInvulnerable then
		state[MODIFIER_STATE_INVULNERABLE] = true
	end
	if self.bShowHealthBar==false then
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	end
	if  self.bStunned then
		state[MODIFIER_STATE_STUNNED] = true
	end
	if self.bRestricted then
		state[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	end




	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_generic_jump:UpdateHorizontalMotion( me, dt )

	local currentTime = GameRules:GetGameTime()
	local dealTime = currentTime - self.last_horizontal_update_time

	local last_pct = math.min(1, (self.last_horizontal_update_time - self.start_time ) / self.duration)
	self.last_horizontal_update_time = currentTime
	local current_pct = math.min(1, (currentTime - self.start_time ) / self.duration)

	if self.bCheckPath then
		local last_pos = self:PredictHorizontalPosition( last_pct )
		local current_pos = self:PredictHorizontalPosition( current_pct )
		-- 算出位移差值
		local delDistance = CalculateDistance(last_pos, current_pos)
		local newPos =  me:GetOrigin() + self.direction * delDistance
		if GridNav:CanFindPath( self:GetParent():GetOrigin(), newPos ) then
			me:SetOrigin( newPos )
		end

	else



		-- 绝对位移 不检测路径
		local current_pos = self:PredictHorizontalPosition( current_pct )
		if self.bCheckvaildPosition then
			if GridNav:CanFindPath( self.last_vaild_position, current_pos ) then
				self.last_vaild_position = current_pos
			end
			
		end
		me:SetOrigin( current_pos )

	end

	if current_pct>=1 then
		local current_y_pct = math.min(1, (self.last_vertical_update_time - self.start_time ) / self.duration)
		if current_y_pct>=1 then
			if self._destroyed then
				return
			end
			self:Destroy()
			return
		end
	end


	-- 摧毁树木
	if self.destroy_tree_on_progresing then
		local currentHeight = me:GetOrigin().z
		local groundHeight = GetGroundHeight(me:GetOrigin(),nil)
		local delHeight = currentHeight - groundHeight
		if delHeight <= self.destroy_tree_on_progresing_radius then
			local caster = self:GetCaster()
			if caster then
				local trees = GridNav:GetAllTreesAroundPoint(me:GetOrigin(), self.destroy_tree_on_progresing_radius, false)
				caster:CutDownTrees(trees,self:GetAbility(),nil)
			end
		end
	end
end

function modifier_generic_jump:UpdateVerticalMotion( me, dt )
	local currentTime = GameRules:GetGameTime()
	-- local dealTime = currentTime - self.last_vertical_update_time
	-- local last_pct = math.min(1, (self.last_vertical_update_time - self.start_time ) / self.duration)
	self.last_vertical_update_time = currentTime
	local current_pct = math.min(1, (currentTime - self.start_time ) / self.duration)
	local newHeight = self:PredictVerticalHeight( current_pct )
	local newPos = me:GetOrigin()
	newPos.z = newHeight
	me:SetOrigin( newPos )

	-- print("v currentTime=",current_pct)


	if #self.callBackList>=1 then
		for i = #self.callBackList, 1, -1 do
			if current_pct>=self.callBackList[i].timePoint then
				self.callBackList[i].callBack()
				table.remove(self.callBackList, i)
			end
		end
	
	end



end



function modifier_generic_jump:OnHorizontalMotionInterrupted()
	if self._destroyed then
		return
	end
	self.interrupted = true
	self:Destroy()
	print("OnHorizontalMotionInterrupted")
end

function modifier_generic_jump:OnVerticalMotionInterrupted()
	if self._destroyed then
		return
	end
	self.interrupted = true
	self:Destroy()
	print("OnVerticalMotionInterrupted")
end


-- 预测水平位置
function modifier_generic_jump:PredictHorizontalPosition( pct )
	if self.horizontal_function then
		pct = self.horizontal_function(pct)
	end
	local pos = self.start_pos + self.direction * self.horizontal_distance * pct
	-- print("pct x=",pct)
	return pos
end


-- 预测高度
function modifier_generic_jump:PredictVerticalHeight( pct )
	local start_z = self.start_pos.z
	local end_z = self.target_pos.z
	local height = self.height
	if self.vertical_function then
		pct = self.vertical_function(pct)
	end
	-- print("z pct=",pct)
	-- 抛物线曲线计算
	local z = start_z + (end_z - start_z) * pct + height * 4 * pct * (1 - pct)
	return z
end





function modifier_generic_jump:SetEndCallback( func )
	self.endCallback = func
end