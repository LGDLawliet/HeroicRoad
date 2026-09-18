LinkLuaModifier("modifier_events_armor_ignore", "modifier/modifier_events", LUA_MODIFIER_MOTION_NONE)



if modifier_events == nil then
	modifier_events = class({})
end
function modifier_events:IsHidden()return true end
function modifier_events:IsDebuff()return false end
function modifier_events:IsPurgable()return false end
function modifier_events:IsPurgeException()return false end
function modifier_events:AllowIllusionDuplicate()return false end
function modifier_events:RemoveOnDeath()return false end
function modifier_events:DestroyOnExpire()return false end
function modifier_events:IsPermanent()return true end
function modifier_events:OnCreated(keys)
	if IsServer() then
		self.armor_ignore_record = {}
		-- print("111111111111111111111")
		self.filter = FilterManager:AddExecuteOrderFilter( self.OrderFilter, self )
	end
end

-- 修复右键跟随敌方单位的bug
function modifier_events:OrderFilter( data )
	-- 临时发布事件
	if true then
		
		local target = EntIndexToHScript( data.entindex_target or -1 )
		local new_pos = Vector(0,0,0)
		if data.position_x then
			new_pos = Vector(data.position_x,data.position_y,data.position_z)
		end
		local ability = EntIndexToHScript( data.entindex_ability or -1 )
		local EvemtKeys = {
			target = target,
			order_type = data.order_type,
			new_pos = new_pos,
			ability = ability,
			
		}
		for _,entindex in pairs(data.units) do
			local unit = EntIndexToHScript( entindex )
			if unit then
				EvemtKeys.unit = unit
				self:OnOrder(EvemtKeys)
			end
		
		end
	end
	
	

	if self.pass then
		return true
	end
	-- local parent = self:GetParent()
	if data.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET  then
		if data.entindex_target then
			local target = EntIndexToHScript( data.entindex_target )
			if target then
				-- 遍历重新发布指令
				self.pass = true
				local pass = true
				for _,entindex in pairs(data.units) do
					local entunit = EntIndexToHScript( entindex )
					if entunit then
						if IsEnemy(entunit,target) then
							pass = false
							entunit:MoveToTargetToAttack(target)
						end
					end
				
				end
				self.pass = false
				if not pass then
					return false
				end

			end
		end
	end

	if data.order_type == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH  then
		for _, entindex in pairs(data.units) do
			local unit = EntIndexToHScript(entindex)
			if unit then
				local nPlayerID = unit:GetPlayerOwnerID()
				if nPlayerID then
					SendCustomErrorToPlayer(nPlayerID,"HUD_Error_Note___DisableFeature","General.Cancel")
				end
			end
		end
		return false
	end



	return true
end

function modifier_events:OnDestroy()
	if IsServer() then
		if self.filter then
			FilterManager:RemoveExecuteOrderFilter(self.filter)
		end
	
	end
end




function modifier_events:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
function modifier_events:DeclareFunctions()
	-- print("2222222222222222222222")
	return {
		-- MODIFIER_EVENT_ON_SPELL_TARGET_READY,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_EVENT_ON_ORDER,
		-- MODIFIER_EVENT_ON_UNIT_MOVED,
		-- MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_EVENT_ON_SPENT_MANA,
		-- MODIFIER_EVENT_ON_TELEPORTED,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
		-- MODIFIER_EVENT_ON_MODIFIER_ADDED,
		-- MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_EVENT_ON_ATTACK_CANCELLED,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,
		MODIFIER_EVENT_ON_PROJECTILE_DODGE,
	}
end
		
-- function modifier_item_hd_demon_edge:OnAttackLanded(keys)
-- 	if IsServer() then
-- 		if keys.attacker == self:GetParent() then
-- 			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_demon_edge_active", {duration = 0.1})
-- 		end
-- 	end
-- end


-- function modifier_item_hd_demon_edge:OnDamageCalculated(keys)
-- 	if IsServer() then
-- 		if keys.attacker == self:GetParent() then
-- 			local modifier = keys.target:FindAllModifiersByName("modifier_item_hd_demon_edge_active")
-- 			if #modifier>0 then
-- 				modifier[1]:SafeDestroy()
-- 			end
-- 		end
-- 	end
-- end

	

function modifier_events:OnSpellTargetReady(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnSpellTargetReady then
				hModifier:OnSpellTargetReady(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnSpellTargetReady then
				hModifier:OnSpellTargetReady(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnSpellTargetReady then
				hModifier:OnSpellTargetReady(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end

function modifier_events:OnAttackStart(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackStart then
				hModifier:OnAttackStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackStart then
				hModifier:OnAttackStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackStart then
				hModifier:OnAttackStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAttack(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttack then
				hModifier:OnAttack(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttack then
				hModifier:OnAttack(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttack then
				hModifier:OnAttack(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAttackLanded(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackLanded then
				hModifier:OnAttackLanded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackLanded then
				hModifier:OnAttackLanded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackLanded then
				hModifier:OnAttackLanded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end


	if IsServer() then
		-- print("111111111111")
		if params.attacker:IsApplyModifier() then
			local armor_ignore = GetAttackArmorIgnore(params.attacker, params)
			-- print("armor_ignore=",armor_ignore)
			if armor_ignore>0 then
				-- print("gogogogogogog")
				self.armor_ignore_record[params.record] = true
				params.target:AddNewModifier(params.attacker, nil, "modifier_events_armor_ignore", {duration = 0.1,stack = armor_ignore})
			end
		end

		

	end


end
function modifier_events:OnAttackFail(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackFail then
				hModifier:OnAttackFail(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackFail then
				hModifier:OnAttackFail(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackFail then
				hModifier:OnAttackFail(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAttackAllied(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackAllied then
				hModifier:OnAttackAllied(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackAllied then
				hModifier:OnAttackAllied(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackAllied then
				hModifier:OnAttackAllied(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnProjectileDodge(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnProjectileDodge then
				hModifier:OnProjectileDodge(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnProjectileDodge then
				hModifier:OnProjectileDodge(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end

	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnProjectileDodge then
				hModifier:OnProjectileDodge(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnOrder(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ORDER] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ORDER]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnOrder then
				hModifier:OnOrder(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ORDER] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ORDER]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnOrder then
				hModifier:OnOrder(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ORDER] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ORDER]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnOrder then
				hModifier:OnOrder(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end

	if params.order_type == DOTA_UNIT_ORDER_CAST_POSITION or params.order_type == DOTA_UNIT_ORDER_CAST_TARGET or params.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET  then
		params.unit.__last_try_cast_time = GameRules:GetGameTime()
	end

end
function modifier_events:OnUnitMoved(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnUnitMoved then
				hModifier:OnUnitMoved(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnUnitMoved then
				hModifier:OnUnitMoved(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAbilityStart(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_START] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityStart then
				hModifier:OnAbilityStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_START] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityStart then
				hModifier:OnAbilityStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_START] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityStart then
				hModifier:OnAbilityStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAbilityExecuted(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityExecuted then
				hModifier:OnAbilityExecuted(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityExecuted then
				hModifier:OnAbilityExecuted(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityExecuted then
				hModifier:OnAbilityExecuted(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAbilityFullyCast(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityFullyCast then
				hModifier:OnAbilityFullyCast(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityFullyCast then
				hModifier:OnAbilityFullyCast(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityFullyCast then
				hModifier:OnAbilityFullyCast(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnBreakInvisibility(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_BREAK_INVISIBILITY] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_BREAK_INVISIBILITY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnBreakInvisibility then
				hModifier:OnBreakInvisibility(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAbilityEndChannel(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityEndChannel then
				hModifier:OnAbilityEndChannel(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityEndChannel then
				hModifier:OnAbilityEndChannel(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityEndChannel then
				hModifier:OnAbilityEndChannel(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnTakeDamage(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnTakeDamage then
				-- print("srouce=",params.unit:GetUnitName(),params.attacker:GetUnitName())
				hModifier:OnTakeDamage(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTakeDamage then
	
				-- print("unit=",params.unit:GetUnitName(),params.attacker:GetUnitName())
				hModifier:OnTakeDamage(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTakeDamage then
				-- print("all=",params.unit:GetUnitName(),params.attacker:GetUnitName())
				hModifier:OnTakeDamage(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnStateChanged(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnStateChanged then
				hModifier:OnStateChanged(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnStateChanged then
				hModifier:OnStateChanged(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnProcessCleave(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_PROCESS_CLEAVE] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_PROCESS_CLEAVE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnProcessCleave then
				hModifier:OnProcessCleave(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnDamageCalculated(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]

			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnDamageCalculated then
				hModifier:OnDamageCalculated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnDamageCalculated then
				hModifier:OnDamageCalculated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnDamageCalculated then
				hModifier:OnDamageCalculated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end

	if self.armor_ignore_record[params.record] then
		self.armor_ignore_record[params.record] = nil
		params.target:RemoveModifierByName("modifier_events_armor_ignore")
	end
	
	
end
function modifier_events:OnAttacked(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACKED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACKED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttacked then
				hModifier:OnAttacked(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACKED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACKED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttacked then
				hModifier:OnAttacked(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACKED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACKED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttacked then
				hModifier:OnAttacked(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnDeath(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DEATH] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DEATH]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnDeath then
				hModifier:OnDeath(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_DEATH] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_DEATH]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnDeath then
				hModifier:OnDeath(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_DEATH] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_DEATH]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnDeath then
				hModifier:OnDeath(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnRespawn(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_RESPAWN] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_RESPAWN]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnRespawn then
				hModifier:OnRespawn(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_RESPAWN] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_RESPAWN]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnRespawn then
				hModifier:OnRespawn(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnSpentMana(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnSpentMana then
				hModifier:OnSpentMana(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnSpentMana then
				hModifier:OnSpentMana(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnTeleporting(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTING] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTING]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTeleporting then
				hModifier:OnTeleporting(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TELEPORTING] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TELEPORTING]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTeleporting then
				hModifier:OnTeleporting(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnTeleported(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTeleported then
				hModifier:OnTeleported(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TELEPORTED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TELEPORTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTeleported then
				hModifier:OnTeleported(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnSetLocation(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SET_LOCATION] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SET_LOCATION]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnSetLocation then
				hModifier:OnSetLocation(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnHealthGained(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnHealthGained then
				hModifier:OnHealthGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnHealthGained then
				hModifier:OnHealthGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnManaGained(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnManaGained then
				hModifier:OnManaGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnManaGained then
				hModifier:OnManaGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnTakeDamageKillCredit(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnTakeDamageKillCredit then
				hModifier:OnTakeDamageKillCredit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTakeDamageKillCredit then
				hModifier:OnTakeDamageKillCredit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTakeDamageKillCredit then
				hModifier:OnTakeDamageKillCredit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnHeroKilled(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnHeroKilled then
				hModifier:OnHeroKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnHeroKilled then
				hModifier:OnHeroKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnHeroKilled then
				hModifier:OnHeroKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnHealReceived(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnHealReceived then
				hModifier:OnHealReceived(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnHealReceived then
				hModifier:OnHealReceived(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnBuildingKilled(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_BUILDING_KILLED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_BUILDING_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnBuildingKilled then
				hModifier:OnBuildingKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnModelChanged(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_MODEL_CHANGED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_MODEL_CHANGED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnModelChanged then
				hModifier:OnModelChanged(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnModifierAdded(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnModifierAdded then
				hModifier:OnModifierAdded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnModifierAdded then
				hModifier:OnModifierAdded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnDominated(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_DOMINATED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_DOMINATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnDominated then
				hModifier:OnDominated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAttackFinished(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackFinished then
				hModifier:OnAttackFinished(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackFinished then
				hModifier:OnAttackFinished(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackFinished then
				hModifier:OnAttackFinished(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end

function modifier_events:OnProjectileObstructionHit(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnProjectileObstructionHit then
				hModifier:OnProjectileObstructionHit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function modifier_events:OnAttackCancelled(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackCancelled then
				hModifier:OnAttackCancelled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackCancelled then
				hModifier:OnAttackCancelled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackCancelled then
				hModifier:OnAttackCancelled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end






modifier_events_armor_ignore = advanced_modifier({})

function modifier_events_armor_ignore:IsDebuff() return true end
function modifier_events_armor_ignore:IsHidden() return true end
function modifier_events_armor_ignore:IsPurgable() return false end
function modifier_events_armor_ignore:OnCreated(keys)
	if IsServer() then
		-- print("-11111111")
		self.armor = -keys.stack
	end
end

function modifier_events_armor_ignore:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_events_armor_ignore:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor
end



