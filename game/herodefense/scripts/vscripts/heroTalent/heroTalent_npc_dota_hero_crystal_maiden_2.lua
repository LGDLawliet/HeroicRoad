LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_crystal_maiden_2", "heroTalent/heroTalent_npc_dota_hero_crystal_maiden_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if heroTalent_npc_dota_hero_crystal_maiden_2 == nil then
	heroTalent_npc_dota_hero_crystal_maiden_2 = class({})
end

-- function heroTalent_npc_dota_hero_crystal_maiden_2:OnSpellStart()
-- 	if IsServer() then
-- 		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_crystal_maiden_2", {duration = self:GetSpecialValueFor("duration")})
-- 	end
-- end

function heroTalent_npc_dota_hero_crystal_maiden_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/crystal_maiden_2/effect_stack.vpcf", context )
end

function heroTalent_npc_dota_hero_crystal_maiden_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_crystal_maiden_2"
end

if modifier_heroTalent_npc_dota_hero_crystal_maiden_2 == nil then
	modifier_heroTalent_npc_dota_hero_crystal_maiden_2 = advanced_modifier({})
end
function modifier_heroTalent_npc_dota_hero_crystal_maiden_2:OnCreated(params)

	self.max_stack = self:GetAbility():GetSpecialValueFor("max_stack")
	self:SetStackCount(1)
	self:StartIntervalThink(0.35)
	if IsServer() then
		local parent = self:GetParent()
		self.particle = ParticleManager:CreateParticle("particles/rebuild/talent/crystal_maiden_2/effect_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
		-- ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl( self.particle, 1, Vector(0,self:GetStackCount(),0) )
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end
function modifier_heroTalent_npc_dota_hero_crystal_maiden_2:OnIntervalThink()
	local stack = self:GetStackCount()
	if stack == 1 then
		self.bonus_spell_damage_amplification = -self:GetAbility():GetSpecialValueFor("spell_amp_1")
	end
	if stack == 2 then
		self.bonus_spell_damage_amplification = self:GetAbility():GetSpecialValueFor("spell_amp_2")
	end
	if stack == 3  then
		self.bonus_spell_damage_amplification = self:GetAbility():GetSpecialValueFor("spell_amp_3")
	end
	--print("现在法强是.."..self.bonus_spell_damage_amplification)
end



function modifier_heroTalent_npc_dota_hero_crystal_maiden_2:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return
	end
	if keys.ability:IsToggle() or keys.ability == self:GetAbility() or (not keys.ability:IsRefreshable()) then
		--print("没过,咋回事捏")
		return
	end
	--print("过了")
	local stack = self:GetStackCount()
	if stack == 1 then
		local cooldown = keys.ability:GetCooldownTimeRemaining()
		local final_cd = cooldown*(self:GetAbility():GetSpecialValueFor("cd_1"))*0.01
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(final_cd)
	end
	if stack == 2 then
		local cooldown = keys.ability:GetCooldownTimeRemaining()
		local final_cd = cooldown*(self:GetAbility():GetSpecialValueFor("cd_2"))*0.01
		keys.ability:EndCooldown()
		keys.ability:StartCooldown(final_cd)
	end
	--层数维护
	self:SetStackCount(self:GetStackCount()+1)
	if self:GetStackCount() > self.max_stack then
		self:SetStackCount(1)
	end 

	ParticleManager:SetParticleControl( self.particle, 1, Vector(0,self:GetStackCount(),0) )

	
	-- self:SetDuration(self:GetAbility():GetSpecialValueFor("duration"),true)
end


function modifier_heroTalent_npc_dota_hero_crystal_maiden_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
    }
end


function modifier_heroTalent_npc_dota_hero_crystal_maiden_2:Advanced_GetModifierSpellAmplifyBonus()	
	return self.bonus_spell_damage_amplification
 end