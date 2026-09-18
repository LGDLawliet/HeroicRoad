item_hd_sven_mask = class({})
-- LinkLuaModifier("modifier_item_hd_sven_mask_arua", "items/item_hd_sven_mask", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_sven_mask_arua_effect", "items/item_hd_sven_mask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sven_mask", "items/item_hd_sven_mask", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sven_mask_active", "items/item_hd_sven_mask", LUA_MODIFIER_MOTION_NONE)


function item_hd_sven_mask:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/sven_mask/active_effect/rebuild/spell/god_strength_attack/sven_ti10_helmet_gods_strength.vpcf", context )

end
function item_hd_sven_mask:GetIntrinsicModifierName()
	return "modifier_item_hd_sven_mask"
end



modifier_item_hd_sven_mask = class({})

function modifier_item_hd_sven_mask:IsDebuff() return false end
function modifier_item_hd_sven_mask:IsHidden() return false end
function modifier_item_hd_sven_mask:IsPurgable() return false end
function modifier_item_hd_sven_mask:IsPurgeException() return false end
function modifier_item_hd_sven_mask:RemoveOnDeath() return false end

function modifier_item_hd_sven_mask:OnCreated(keys)
    local ability = self:GetAbility()
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
	if IsServer() then
		-- local parent = self:GetParent()
		self:StartIntervalThink(1)
	end
end


function modifier_item_hd_sven_mask:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end


function modifier_item_hd_sven_mask:GetModifierDamageOutgoing_Percentage()
	return self.bonus_damage
end
function modifier_item_hd_sven_mask:OnAttackLanded(keys)
	if not IsServer() then return end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if not keys.attacker:IsApplyModifier() then
		return
	end
	local parent = self:GetParent()
	if parent:HasModifier("modifier_item_hd_sven_mask_active") then
		return
	end

	self:SetStackCount(self:GetStackCount()+1)
	
end
function modifier_item_hd_sven_mask:OnIntervalThink()
	local parent = self:GetParent()
	if parent:IsAlive() then
		if parent:HasModifier("modifier_item_hd_sven_mask_active") then
			return
		end
		self:SetStackCount(self:GetStackCount()+10)
	end
	
end
function modifier_item_hd_sven_mask:CheckState()
	if self:GetStackCount()>=500 then
		self:SetStackCount(0)
		local caster = self:GetParent()
		local ability = self:GetAbility()
		caster:AddNewModifier(caster, ability, "modifier_item_hd_sven_mask_active", {duration = 10})
		local particle = ParticleManager:CreateParticle("particles/rebuild/items/sven_mask/active_effect/rebuild/spell/god_strength_attack/sven_ti10_helmet_gods_strength.vpcf", PATTACH_POINT_FOLLOW, caster)
		local caster_pos = caster:GetOrigin()
		ParticleManager:SetParticleControl(particle, 0, caster_pos)
		ParticleManager:SetParticleControl(particle, 1, caster_pos)
		DestroyParticleByDelay(particle,4)
		caster:EmitSound("Hero_Sven.GodsStrength")
		
	end
end










modifier_item_hd_sven_mask_active = class({})

function modifier_item_hd_sven_mask_active:IsDebuff() return false end
function modifier_item_hd_sven_mask_active:IsHidden() return false end
function modifier_item_hd_sven_mask_active:IsPurgable() return false end
function modifier_item_hd_sven_mask_active:IsPurgeException() return false end
function modifier_item_hd_sven_mask_active:RemoveOnDeath() return false end
function modifier_item_hd_sven_mask_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,           --攻击力
	}

	return funcs
end


function modifier_item_hd_sven_mask_active:GetModifierDamageOutgoing_Percentage()
	return 40
end