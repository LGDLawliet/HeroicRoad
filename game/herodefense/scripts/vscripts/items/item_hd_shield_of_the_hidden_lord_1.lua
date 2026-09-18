item_hd_shield_of_the_hidden_lord_1 = class({})
-- LinkLuaModifier("modifier_item_hd_shield_of_the_hidden_lord_1_arua", "items/item_hd_shield_of_the_hidden_lord_1", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_shield_of_the_hidden_lord_1_arua_effect", "items/item_hd_shield_of_the_hidden_lord_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shield_of_the_hidden_lord_1", "items/item_hd_shield_of_the_hidden_lord_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shield_of_the_hidden_lord_1_buff", "items/item_hd_shield_of_the_hidden_lord_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_shield_of_the_hidden_lord_1_debuff", "items/item_hd_shield_of_the_hidden_lord_1", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_shield_of_the_hidden_lord_1:GetIntrinsicModifierName()
	return "modifier_item_hd_shield_of_the_hidden_lord_1"
end





function item_hd_shield_of_the_hidden_lord_1:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_crimson_ti8_immortal_cursed_crownmarker.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", context )




	

end




function item_hd_shield_of_the_hidden_lord_1:Spawn()
	self.timer = GameRules:GetGameTime()+60
end
function item_hd_shield_of_the_hidden_lord_1:CheckDamnation()

	if not self:GetCaster():IsAlive() then
		return
	end
	if GameRules:GetGameTime()>=self.timer then
		self.timer= GameRules:GetGameTime() +60
		local danation = false
		if 1>=RandomInt(1, 10) then
			danation = true
		end
		return danation
	end
end

modifier_item_hd_shield_of_the_hidden_lord_1 = modifier_item_hd_shield_of_the_hidden_lord_1 or advanced_modifier({})

function modifier_item_hd_shield_of_the_hidden_lord_1:IsDebuff() return false end
function modifier_item_hd_shield_of_the_hidden_lord_1:IsHidden() return false end
function modifier_item_hd_shield_of_the_hidden_lord_1:IsPurgable() return false end
function modifier_item_hd_shield_of_the_hidden_lord_1:OnCreated(keys)
    local parent = self:GetParent()

	local ability = self:GetAbility()
	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_armor =ability:GetSpecialValueFor( "bonus_armor" ) 
	self.red_spell_resist =-ability:GetSpecialValueFor( "red_spell_resist" ) 
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_item_hd_shield_of_the_hidden_lord_1:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		MODIFIER_PROPERTY_HEALTH_BONUS,

		MODIFIER_EVENT_ON_TAKEDAMAGE

	}
end

function modifier_item_hd_shield_of_the_hidden_lord_1:GetModifierMagicalResistanceBonus() return self.red_spell_resist end
function modifier_item_hd_shield_of_the_hidden_lord_1:GetModifierHealthBonus() return self.bonus_health end

function modifier_item_hd_shield_of_the_hidden_lord_1:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:CheckDamnation() then
		local caster = self:GetCaster()
		caster:AddNewModifier(caster,ability,"modifier_item_hd_shield_of_the_hidden_lord_1_debuff",{	duration = 60})
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_crimson_ti8_immortal_cursed_crownmarker.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(nFXIndex, 0,caster:GetOrigin())
		ParticleManager:SetParticleControl(nFXIndex, 1,Vector(200,0,0))
		DestroyParticleByDelay(nFXIndex,2)
	end
	if ability:IsCooldownReady() then
		if self:GetStackCount()<=5 then
			ability:UseResources(true, true, true, true)
			self:SetStackCount(15)
		end

	end
end

function modifier_item_hd_shield_of_the_hidden_lord_1:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end

	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
    end
	if keys.damage<=0 then
		return
	end
	local caster = self:GetCaster()
    if keys.damage_type==DAMAGE_TYPE_PHYSICAL  and  caster:RollRandom(10,1)  then
		caster:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_shield_of_the_hidden_lord_1_buff",{	duration = 7*caster:GetModifierDurationGainIndex(1)})
	end
	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(nFXIndex, 1, keys.attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", keys.unit:GetAbsOrigin(), true)
		DestroyParticleByDelay(nFXIndex,2)

		local damageTable = {
			victim = keys.attacker,
			attacker = caster,
			damage = caster:GetPhysicalArmorValue(false)*25,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)
		
	end
end


function modifier_item_hd_shield_of_the_hidden_lord_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_shield_of_the_hidden_lord_1:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



modifier_item_hd_shield_of_the_hidden_lord_1_buff = advanced_modifier({})

function modifier_item_hd_shield_of_the_hidden_lord_1_buff:IsHidden()	return false end
function modifier_item_hd_shield_of_the_hidden_lord_1_buff:IsDebuff()	return false end
function modifier_item_hd_shield_of_the_hidden_lord_1_buff:IsPurgable()	return false end
function modifier_item_hd_shield_of_the_hidden_lord_1_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_shield_of_the_hidden_lord_1_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= 10 then
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

function modifier_item_hd_shield_of_the_hidden_lord_1_buff:OnIntervalThink()
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


function modifier_item_hd_shield_of_the_hidden_lord_1_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP}
end

function modifier_item_hd_shield_of_the_hidden_lord_1_buff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_item_hd_shield_of_the_hidden_lord_1_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_shield_of_the_hidden_lord_1_buff:Advanced_GetModifierPhysicalArmorBonus()
    return math.min(self:GetStackCount()*4,40)
end



modifier_item_hd_shield_of_the_hidden_lord_1_debuff = modifier_item_hd_shield_of_the_hidden_lord_1_debuff or class({})

function modifier_item_hd_shield_of_the_hidden_lord_1_debuff:IsDebuff() return true end
function modifier_item_hd_shield_of_the_hidden_lord_1_debuff:IsHidden() return false end
function modifier_item_hd_shield_of_the_hidden_lord_1_debuff:IsPurgable() return false end
function modifier_item_hd_shield_of_the_hidden_lord_1_debuff:RemoveOnDeath() return false end

function modifier_item_hd_shield_of_the_hidden_lord_1_debuff:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性

	}
end

function modifier_item_hd_shield_of_the_hidden_lord_1_debuff:GetModifierMagicalResistanceBonus() return -200 end
