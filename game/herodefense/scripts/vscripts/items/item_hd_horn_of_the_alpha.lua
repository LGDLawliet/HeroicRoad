item_hd_horn_of_the_alpha = class({})

LinkLuaModifier("modifier_item_hd_horn_of_the_alpha", "items/item_hd_horn_of_the_alpha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_horn_of_the_alpha_active", "items/item_hd_horn_of_the_alpha", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_horn_of_the_alpha_buff", "items/item_hd_horn_of_the_alpha", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_horn_of_the_alpha:GetIntrinsicModifierName()
	return "modifier_item_hd_horn_of_the_alpha"
end



function item_hd_horn_of_the_alpha:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/centaur/centaur_2022_immortal/centaur_2022_immortal_stampede_cast.vpcf", context )

end


modifier_item_hd_horn_of_the_alpha = advanced_modifier({})

function modifier_item_hd_horn_of_the_alpha:IsDebuff() return false end
function modifier_item_hd_horn_of_the_alpha:IsHidden() return true end
function modifier_item_hd_horn_of_the_alpha:IsPurgable() return false end
function modifier_item_hd_horn_of_the_alpha:IsPurgeException() return false end
function modifier_item_hd_horn_of_the_alpha:RemoveOnDeath() return false end


function modifier_item_hd_horn_of_the_alpha:OnCreated(keys)
    local ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_summon_intensity =ability:GetSpecialValueFor("bonus_summon_intensity")
	self.bonus_basic_damage =ability:GetSpecialValueFor("bonus_damage")

end



function modifier_item_hd_horn_of_the_alpha:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE

	}
end

function modifier_item_hd_horn_of_the_alpha:GetModifierBaseAttack_BonusDamage() return self.bonus_basic_damage end
function modifier_item_hd_horn_of_the_alpha:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_horn_of_the_alpha_active", {})
	end
end
-- advanced_modifier
function modifier_item_hd_horn_of_the_alpha:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_horn_of_the_alpha:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity 
end






modifier_item_hd_horn_of_the_alpha_active = class({})

function modifier_item_hd_horn_of_the_alpha_active:IsDebuff() return false end
function modifier_item_hd_horn_of_the_alpha_active:IsHidden() return true end
function modifier_item_hd_horn_of_the_alpha_active:IsPurgable() return false end
function modifier_item_hd_horn_of_the_alpha_active:OnDestroy()
	if IsServer() then
		local damage = self:GetParent():GetBaseDamageMax()*0.01

		local caster = self:GetCaster()


		local pfx = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_2022_immortal/centaur_2022_immortal_stampede_cast.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetOrigin())
		DestroyParticleByDelay(pfx,2)
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_horn_of_the_alpha_buff", {duration=60*caster:GetModifierDurationGainIndex(1),time=60*caster:GetModifierDurationGainIndex(1), index=damage}) 
	end

end







modifier_item_hd_horn_of_the_alpha_buff = modifier_item_hd_horn_of_the_alpha_buff or class({})

function modifier_item_hd_horn_of_the_alpha_buff:IsHidden()	return false end
function modifier_item_hd_horn_of_the_alpha_buff:IsDebuff()	return false end
function modifier_item_hd_horn_of_the_alpha_buff:IsPurgable()	return false end
function modifier_item_hd_horn_of_the_alpha_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE

	}
end

function modifier_item_hd_horn_of_the_alpha_buff:GetModifierBaseAttack_BonusDamage() return math.min(self:GetStackCount(),200) end

function modifier_item_hd_horn_of_the_alpha_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime =  GameRules:GetGameTime()+params.time,stack = params.index })
		self:SetStackCount( params.index )
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_item_hd_horn_of_the_alpha_buff:OnRefresh(params)
	if IsServer() then
		local dieTime =  GameRules:GetGameTime()+params.time

		
	
		table.insert(self.tData, {dieTime = dieTime ,stack = params.index})
		self:SetStackCount(self:GetStackCount()+ params.index )
		
	end
end

function modifier_item_hd_horn_of_the_alpha_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(math.max(self:GetStackCount()- self.tData[i].stack,0) )
				table.remove(self.tData, i)
				
			end
		end
		if self:GetStackCount()<=0 then
			self:SafeDestroy()
		end
	end
end


