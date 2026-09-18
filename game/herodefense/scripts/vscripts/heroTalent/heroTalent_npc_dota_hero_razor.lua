heroTalent_npc_dota_hero_razor = class({})
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_razor_arua", "skills/heroTalent_npc_dota_hero_razor", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_razor_arua_effect", "skills/heroTalent_npc_dota_hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_razor", "heroTalent/heroTalent_npc_dota_hero_razor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_razor_active", "heroTalent/heroTalent_npc_dota_hero_razor", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_razor:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_razor"
end


modifier_heroTalent_npc_dota_hero_razor = class({})




function modifier_heroTalent_npc_dota_hero_razor:IsHidden() 	return true end
function modifier_heroTalent_npc_dota_hero_razor:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_razor:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_razor:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_razor:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_heroTalent_npc_dota_hero_razor:OnAttackLanded(keys)
    if not IsServer() then
        return
	end  
	
	if self:GetParent():IsIllusion() then
		return
    end


    if keys.attacker == self:GetParent() then 
		if keys.target:IsMagicImmune() then
			return
		end
		if not self:GetAbility():IsCooldownReady() then
			return
		end
		self:GetAbility():UseResources(true, true, true,true)
		local parent = self:GetParent()
		local target = keys.target
		local ModifierStatusNegativeGain = parent:GetModifierStatusNegativeGainIndex(1)
		local damageTable = {
			victim = target,
			attacker = parent,
			damage = parent:GetAgility()*self:GetAbility():GetSpecialValueFor("agi_index"),
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self:GetAbility(), --Optional.
		}
		Timers:CreateTimer(0.3, function()
			local particle_cast = "particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf"
			local sound_cast = "Hero_razor.lightning"
			
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, parent )
			ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() + Vector(0,0,500) )

			ParticleManager:SetParticleControlEnt(
				effect_cast,
				1,
				target,
				PATTACH_POINT_FOLLOW,
				"attach_hitloc",
				Vector(0,0,0), -- unknown
				true -- unknown, true
			)
			ParticleManager:ReleaseParticleIndex( effect_cast )
	
			-- Create Sound
			EmitSoundOn( sound_cast, target )
			ApplyDamage(damageTable)
			target:AddNewModifier(parent, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_razor_active", {duration=self:GetAbility():GetSpecialValueFor("duration")*ModifierStatusNegativeGain}) 
		end)


	


	end 
end  




modifier_heroTalent_npc_dota_hero_razor_active = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_razor_active:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_razor_active:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_razor_active:IsPurgable()	return true end

function modifier_heroTalent_npc_dota_hero_razor_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_heroTalent_npc_dota_hero_razor_active:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetAbility():GetSpecialValueFor("armor")*self:GetStackCount()
end



function modifier_heroTalent_npc_dota_hero_razor_active:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_razor_active:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= (self:GetAbility():GetSpecialValueFor("max_count")) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_razor_active:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end

