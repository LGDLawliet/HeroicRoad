
chaotic_protection_of_dodge = class({})
LinkLuaModifier("modifier_chaotic_protection_of_dodge", "chaotic_spell/class_4/chaotic_protection_of_dodge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_protection_of_dodge_active", "chaotic_spell/class_4/chaotic_protection_of_dodge", LUA_MODIFIER_MOTION_NONE)


function chaotic_protection_of_dodge:Precache( context )

	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_protection_of_dodge/effect_buff/effect_lvl2.vpcf", context )

	
end

function chaotic_protection_of_dodge:GetIntrinsicModifierName() return "modifier_chaotic_protection_of_dodge" end


function chaotic_protection_of_dodge:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	-- local target = self:GetCursorTarget() 
	local sound_cast = "chaotic_protection_of_dodge_cast"    
	EmitSoundOn(sound_cast, caster)    
	self:ApplyModifier(caster)
end

function chaotic_protection_of_dodge:ApplyModifier(target)
	local gain = self:GetCaster():GetModifierDurationGainIndex(0.45)
	local duration = self:GetSpecialValueFor("duration")*gain
	target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_protection_of_dodge_active", {duration =  duration})
end


modifier_chaotic_protection_of_dodge = advanced_modifier({})

function modifier_chaotic_protection_of_dodge:IsHidden() return true end
function modifier_chaotic_protection_of_dodge:IsPurgable() return false end
function modifier_chaotic_protection_of_dodge:IsDebuff() return false end
function modifier_chaotic_protection_of_dodge:OnCreated(keys)
	local ability = self:GetAbility()

	if IsServer() then
		self:StartIntervalThink(ability:GetSpecialValueFor("interval"))
	end
end
function modifier_chaotic_protection_of_dodge:OnRefresh(keys)
	local ability = self:GetAbility()

	if IsServer() then
		self:StartIntervalThink(ability:GetSpecialValueFor("interval"))
	end
end


function modifier_chaotic_protection_of_dodge:OnIntervalThink()
	ProjectileManager:ProjectileDodge(self:GetParent())
end








modifier_chaotic_protection_of_dodge_active = advanced_modifier({})

function modifier_chaotic_protection_of_dodge_active:IsHidden() return false end
function modifier_chaotic_protection_of_dodge_active:IsPurgable() return false end
function modifier_chaotic_protection_of_dodge_active:IsDebuff() return false end
function modifier_chaotic_protection_of_dodge_active:OnCreated(keys)
	if IsServer() then

		local modifier = self:GetParent():FindModifierByName("modifier_chaotic_protection_of_dodge")
		if modifier then
			modifier:StartIntervalThink(self:GetAbility():GetSpecialValueFor("active_interval"))
		end
		local parent = self:GetParent()
		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_protection_of_dodge/effect_buff/effect_lvl2.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( self.particle, 1, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControlEnt( self.particle, 3, parent, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
		-- ParticleManager:SetParticleControl( self.particle, 1,Vector(self.radius,self.radius,self.radius) )
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		-- self:StartIntervalThink(1)
	end
end
function modifier_chaotic_protection_of_dodge_active:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(0)
	end
end
function modifier_chaotic_protection_of_dodge_active:OnDestroy(keys)
	if IsServer() then
		local modifier = self:GetParent():FindModifierByName("modifier_chaotic_protection_of_dodge")
		if modifier then
			modifier:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
		end
		ParticleManager:DestroyParticle(self.particle,false)
	end
end


function modifier_chaotic_protection_of_dodge_active:ADDeclareFunctions()
	local funcs = {

	}
	if self:GetAbility():GetRuneType()==1 then
		self.rune_1_bonus_damage = self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")
		funcs["MODIFIER_EVENT_ON_PROJECTILE_DODGE"]= {nil,self:GetParent()}
		table.insert(funcs,advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE)
	end
    return funcs
   
end
function modifier_chaotic_protection_of_dodge_active:OnProjectileDodge(keys)

	if keys.target==self:GetParent() then
		self:SetStackCount(self:GetStackCount()+self.rune_1_bonus_damage)
	end
end

function modifier_chaotic_protection_of_dodge_active:Advanced_GetModifierPreAttack_BonusDamage(keys)
	return self:GetStackCount()
end