heroTalent_npc_dota_hero_terrorblade_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade_3", "heroTalent/heroTalent_npc_dota_hero_terrorblade_3", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_terrorblade_3_effect", "heroTalent/heroTalent_npc_dota_hero_terrorblade_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_terrorblade_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_terrorblade_3"
end

-- "神圣利刃将彻底免疫缴械，同时具备%status_resistance%%%初始状态抗性。每隔%interval%秒，将强制性得到一次强驱散效果。在白昼时，神圣利刃还将获得%bonus_attack_speed%%%的攻击速度增加。"
modifier_heroTalent_npc_dota_hero_terrorblade_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_terrorblade_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_terrorblade_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_terrorblade_3:OnCreated(keys)
	local ability = self:GetAbility()
	self.status_resistance = ability:GetSpecialValueFor("status_resistance")
	self.interval = ability:GetSpecialValueFor("interval")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self.game_time = GameRules:GetGameTime()
		self:StartIntervalThink(0.1)
		local parent = self:GetParent()
		parent:SetOriginalModel("models/override_model/terrorblade_ultimate/terrorblade_ultimate_depravity_demon.vmdl")
		parent:UpdateOriginModel("models/override_model/terrorblade_ultimate/terrorblade_ultimate_depravity_demon.vmdl")

		local model = parent:FirstMoveChild()
		-- self.modelName = self.hero:GetModelName()
		local model_list = {}
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				-- print(model)
				-- PrintTable(model)
				-- print(model:GetModelName())
	
				table.insert(model_list,model)
				
			end
			model = model:NextMovePeer()
		end
		for _, model in ipairs(model_list) do
			UTIL_Remove(model)
		end	
	end

end

function modifier_heroTalent_npc_dota_hero_terrorblade_3:OnRefresh(keys)
	local ability = self:GetAbility()
	self.status_resistance = ability:GetSpecialValueFor("status_resistance")
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.interval = ability:GetSpecialValueFor("interval")


end


function modifier_heroTalent_npc_dota_hero_terrorblade_3:OnIntervalThink()
	if self:GetParent():IsInDayTime() then
		self:SetStackCount(1)
	else
		self:SetStackCount(0)
	end
	local time = GameRules:GetGameTime()
	if time>=self.game_time then
		self.game_time = time
		self:GetParent():Purge(false, true, false, false,true) --强驱散
	end
end

function modifier_heroTalent_npc_dota_hero_terrorblade_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}
end




function modifier_heroTalent_npc_dota_hero_terrorblade_3:Advanced_GetModifierAttackSpeedPercentage() 
	local bonus = self:GetStackCount()==1 and self.bonus_attack_speed or 0
    return bonus
end

function modifier_heroTalent_npc_dota_hero_terrorblade_3:GetModifierModelChange()
	return "models/override_model/terrorblade_ultimate/terrorblade_ultimate_depravity_demon.vmdl"
end

function modifier_heroTalent_npc_dota_hero_terrorblade_3:GetPriority() return 19 end

function modifier_heroTalent_npc_dota_hero_terrorblade_3:CheckState() 
	local state = {[MODIFIER_STATE_DISARMED] = false,  } 
	return state 
end

function modifier_heroTalent_npc_dota_hero_terrorblade_3:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }

	return funcs

end
function modifier_heroTalent_npc_dota_hero_terrorblade_3:Advanced_GetModifier_StatusResistance(keys)
	return self.status_resistance
end

