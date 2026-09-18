heroTalent_npc_dota_hero_winter_wyvern_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_winter_wyvern_2", "heroTalent/heroTalent_npc_dota_hero_winter_wyvern_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect", "heroTalent/heroTalent_npc_dota_hero_winter_wyvern_2", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_winter_wyvern_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_winter_wyvern_2"
end


function heroTalent_npc_dota_hero_winter_wyvern_2:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf" , context )
	-- PrecacheResource( "particle", "particles/econ/items/viper/viper_ti7_immortal/viper_poison_debuff_ti7.vpcf" , context )
end
modifier_heroTalent_npc_dota_hero_winter_wyvern_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:Advanced_GetModifierAttackRangeBonus()		
    if self:GetParent():IsRangedAttacker() then
      return 180
    else 
		return 0
 	end
end



function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
	


    if keys.attacker == self:GetParent() then 
		if self:GetParent():PassivesDisabled() then
			return
		end
		if keys.target:IsMagicImmune() then
			return
		end
		if not self:GetParent():IsApplyModifier()  then
			return
		end
		keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect", {duration=4}) 

	end 
end  

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf" 
    end	
end 

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end


modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect =modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:IsPurgable()	return false end
-- function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end





function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)

		self.timer = GameRules:GetGameTime()+1
		
		self.damagetable= {
			victim =self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}
	end
end
function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end

		if fGameTime>=self.timer then
			self.timer = self.timer +1
			local damage = math.min(self:GetParent():GetHealth() *0.01 ,self:GetCaster():GetMaxMana()*0.05)
			self.damagetable.damage = damage*self:GetStackCount()
			local real_damage = ApplyDamage(self.damagetable)
			if real_damage>10 then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , self:GetParent(), real_damage, nil)
			end
			
		end
	end
end

-- particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:DeclareFunctions()
	local funcs = {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     
		    

	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_winter_wyvern_2_effect:GetModifierMoveSpeedBonus_Percentage()
	return -35
end

