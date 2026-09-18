item_hd_high_priest_robe = class({})

LinkLuaModifier("modifier_item_hd_high_priest_robe", "items/item_hd_high_priest_robe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_high_priest_robe_buff", "items/item_hd_high_priest_robe", LUA_MODIFIER_MOTION_NONE)



function item_hd_high_priest_robe:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/high_priest_robe/effect.vpcf", context )

end

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_high_priest_robe:GetIntrinsicModifierName()
	return "modifier_item_hd_high_priest_robe"
end


modifier_item_hd_high_priest_robe = advanced_modifier({})

function modifier_item_hd_high_priest_robe:IsDebuff() return false end
function modifier_item_hd_high_priest_robe:IsHidden() return true end
function modifier_item_hd_high_priest_robe:IsPurgable() return false end
function modifier_item_hd_high_priest_robe:IsPurgeException() return false end
function modifier_item_hd_high_priest_robe:RemoveOnDeath() return false end
function modifier_item_hd_high_priest_robe:DestroyOnExpire() return false end
function modifier_item_hd_high_priest_robe:OnCreated(keys)
	self.bonus_int =  self:GetAbility():GetSpecialValueFor("bonus_int")
	self.heal_amp = self:GetAbility():GetSpecialValueFor("heal_amp")
	self.heal_receive_amp = self:GetAbility():GetSpecialValueFor("heal_receive_amp")

end

function modifier_item_hd_high_priest_robe:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,        
	}
end
function modifier_item_hd_high_priest_robe:GetModifierBonusStats_Intellect()return self.bonus_int end


function modifier_item_hd_high_priest_robe:OnCustomModifierFunction_Heal(keys)
	if IsServer() then
		if keys.unit~=self:GetParent() then
			return
		end
		if keys.heal<5 then
			return
		end
		local caster = self:GetCaster()
		local heal = keys.heal*0.2
		if heal>0 then
			keys.target:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_high_priest_robe_buff",{	duration = 10,bonus_shield = heal})

		end

		
	end
end



-- advanced_modifier
function modifier_item_hd_high_priest_robe:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_high_priest_robe:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.heal_amp 
end


function modifier_item_hd_high_priest_robe:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.heal_receive_amp
end








modifier_item_hd_high_priest_robe_buff = modifier_item_hd_high_priest_robe_buff or advanced_modifier({})

function modifier_item_hd_high_priest_robe_buff:IsDebuff()			return false end
function modifier_item_hd_high_priest_robe_buff:IsHidden() 			return false end
function modifier_item_hd_high_priest_robe_buff:IsPurgable() 			return true end
function modifier_item_hd_high_priest_robe_buff:IsPurgeException() 	return true end

function modifier_item_hd_high_priest_robe_buff:OnCreated(keys)
	if IsServer() then



		self:SetStackCount(keys.bonus_shield)
		local parent = self:GetParent()
		EmitSoundOn("Hero_Abaddon.AphoticShield.Cast", parent)

		local particle_name = "particles/rebuild/items/high_priest_robe/effect.vpcf"
		
		local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 5, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		local ex = parent:GetModelScale() * 100
		ParticleManager:SetParticleControl(pfx, 1, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 2, Vector(ex,ex,ex))
		ParticleManager:SetParticleControl(pfx, 4, Vector(ex,ex,ex))
		self:AddParticle(pfx, false, false, 15, false, false)
	end
end
function modifier_item_hd_high_priest_robe_buff:OnRefresh(keys)
	if IsServer() then
		local max = self:GetParent():GetMaxHealth()*10
		self:SetStackCount(math.min(self:GetStackCount()+keys.bonus_shield,max))
	end
end




function modifier_item_hd_high_priest_robe_buff:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_item_hd_high_priest_robe_buff:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return self:GetStackCount()
	end
	if keys.block_disabled then
        return 0 
    end

	local stack = self:GetStackCount()
	if stack<=0 then
		self:SafeDestroy()
		return 0
	end
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage+1
	end
	return stack
end