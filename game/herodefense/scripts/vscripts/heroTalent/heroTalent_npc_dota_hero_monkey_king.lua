--
heroTalent_npc_dota_hero_monkey_king = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_monkey_king", "heroTalent/heroTalent_npc_dota_hero_monkey_king", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_monkey_king:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_monkey_king"
end



modifier_heroTalent_npc_dota_hero_monkey_king = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_monkey_king:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_monkey_king:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_monkey_king:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_monkey_king:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_monkey_king:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_monkey_king:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self.hero =  self:GetParent()
		self:GetAbility():StartCooldown(10)
		self:StartIntervalThink(0)
		self.draw = false
		self.modelName = self.hero:GetModelName()
		Timers:CreateTimer(0.3, function()
			
			-- 这里是因为最后一个就是武器了 所以这样弄
			local model = self.hero:FirstMoveChild()
			-- self.modelName = self.hero:GetModelName()
			while model ~= nil do
				if model:GetClassname() == "dota_item_wearable" then
					-- print(model)
					-- PrintTable(model)
					-- print(model:GetModelName())
					self.lastModel = model
				end
				model = model:NextMovePeer()
			end
			-- self.lastModel:AddEffects(EF_NODRAW) -- Set model hidden
			local name = self.lastModel:GetModelName()
			self.model = GameRules:AttachWearableWithScale(self.hero, name,nil,2)
			self.model:AddEffects(EF_NODRAW)
		end)
	
	end
end
--由于这个模型是主动创建 所以单位变身时候需要把这个模型隐藏
function modifier_heroTalent_npc_dota_hero_monkey_king:OnIntervalThink()
	if self.draw then
		self.model:RemoveEffects(EF_NODRAW)
		local pos = self.lastModel:GetAbsOrigin()
		local angle = self.lastModel:GetAngles()
		self.model:SetAngles(angle.x, angle.y, angle.z)
		self.model:SetAbsOrigin(pos)
	end
	if self.modelName~=self.hero:GetModelName() then
		self.model:AddEffects(EF_NODRAW)
	end
	local ability = self:GetAbility()
	local cooldown = ability:GetCooldownTimeRemaining()
	if cooldown<=6 then
		self.draw = true
		self:SetStackCount(_G.GAME_ROUND)
	end
end

function modifier_heroTalent_npc_dota_hero_monkey_king:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
	}

	return funcs
end



function modifier_heroTalent_npc_dota_hero_monkey_king:OnAttackLanded(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		if keys.attacker==self:GetParent() then
			local ability = self:GetAbility()
			local cooldown = ability:GetCooldownTimeRemaining()
			if cooldown<=6 then
				ability:StartCooldown(cooldown+ability:GetCooldown(ability:GetLevel())* self:GetParent():GetCooldownReduction() )
				-- self:GetAbility():UseResources(true, true, true,true)

				if ability:GetCooldownTimeRemaining()>6 then
					self.model:AddEffects(EF_NODRAW)
					self.draw = false
					self:SetStackCount(0)
				end
			end
		end
	end
end


function modifier_heroTalent_npc_dota_hero_monkey_king:GetModifierPreAttack_BonusDamage() 
	if IsClient() then
		return 0
	end
	if not self:GetParent():IsRealHero() then
		return 0
	end
	return self:GetAbility():GetCooldownTimeRemaining()<=6 and self:GetStackCount()*20+100 
end
function modifier_heroTalent_npc_dota_hero_monkey_king:Advanced_GetModifierAttackRangeBonus()
	if IsClient() then
		return 200
	end
	if not self:GetParent():IsRealHero() then
		return 0
	end
	return self:GetAbility():GetCooldownTimeRemaining()<=6 and 400 or 200 
end



function modifier_heroTalent_npc_dota_hero_monkey_king:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end