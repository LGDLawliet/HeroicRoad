item_hd_ancient_gemstone = class({})

LinkLuaModifier("modifier_item_hd_ancient_gemstone", "items/item_hd_ancient_gemstone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ancient_gemstone_buff", "items/item_hd_ancient_gemstone", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_ancient_gemstone:GetIntrinsicModifierName()
	return "modifier_item_hd_ancient_gemstone"
end
function item_hd_ancient_gemstone:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", context )

end
function item_hd_ancient_gemstone:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local dir = CalculateDirection(target,caster)
	local dis = CalculateDistance(target,caster)*0.3
	local caster_pos = caster:GetAbsOrigin()
	local center_pos = caster_pos+dir*dis
	local pos1 = RotatePosition(caster_pos, QAngle(0, -15, 0), center_pos)+Vector(0,0,128)
	local pos2 = RotatePosition(caster_pos, QAngle(0, 15, 0), center_pos)+Vector(0,0,128)



	self:GetCaster():EmitSound("Ability.LagunaBladeImpact")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle,1,pos1)
	-- ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle,1,pos2)
	-- ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	Timers:CreateTimer(0.06, function()
		if not self:IsNull() and target and not target:IsNull() then
			self:GetCaster():EmitSound("Ability.LagunaBladeImpact")
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(particle,0,pos1)
			ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(particle,0,pos2)
			ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)
			
		end
	end)

	ApplyDamage({
		victim 			= target,
		damage 			= caster:GetIntellect(false)*20+4000,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= caster,
		ability 		= self
	})
	if not target:IsAlive() then
		caster:AddNewModifier(caster, self, "modifier_item_hd_ancient_gemstone_buff", {})
	end
end





modifier_item_hd_ancient_gemstone = class({})

function modifier_item_hd_ancient_gemstone:IsDebuff() return false end
function modifier_item_hd_ancient_gemstone:IsHidden() return true end
function modifier_item_hd_ancient_gemstone:IsPurgable() return false end

function modifier_item_hd_ancient_gemstone:OnCreated(keys)
   local ability = self:GetAbility()

 

	self.bonus_int = ability:GetSpecialValueFor("bonus_int")


end



function modifier_item_hd_ancient_gemstone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	}
end


function modifier_item_hd_ancient_gemstone:GetModifierBonusStats_Intellect()	return self.bonus_int end




modifier_item_hd_ancient_gemstone_buff = advanced_modifier({})

function modifier_item_hd_ancient_gemstone_buff:IsDebuff() return false end
function modifier_item_hd_ancient_gemstone_buff:IsHidden() return false end
function modifier_item_hd_ancient_gemstone_buff:IsPurgable() return false end
function modifier_item_hd_ancient_gemstone_buff:RemoveOnDeath() return false end
function modifier_item_hd_ancient_gemstone_buff:IsPurgeException() return false end
function modifier_item_hd_ancient_gemstone_buff:GetTexture() return "item_ancient_malachite_gemstone" end
function modifier_item_hd_ancient_gemstone_buff:OnCreated()
	if IsServer() then
		self:SetStackCount(2)
	end
end
function modifier_item_hd_ancient_gemstone_buff:OnRefresh()
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+3,60))
	end
end
function modifier_item_hd_ancient_gemstone_buff:ADDeclareFunctions()
    return 
    {

		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS


    }
end

function modifier_item_hd_ancient_gemstone_buff:Advanced_GetModifierSpellAmplifyBonus()	return self:GetStackCount() end


