Middle_corrosive_haze = class({})
LinkLuaModifier( "modifier_Middle_corrosive_haze", "skills/Middle_corrosive_haze", LUA_MODIFIER_MOTION_NONE )

function Middle_corrosive_haze:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/corrosive_haze/corrosive_hazeamp_damage.vpcf", context )


end
function Middle_corrosive_haze:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	if target:TriggerSpellAbsorb( self ) then
		return
	end
	local debuff_duration = self:GetSpecialValueFor("duration")
	target:AddNewModifier(caster, self, "modifier_Middle_corrosive_haze", { duration = debuff_duration } )
	EmitSoundOn( "Hero_Slardar.Amplify_Damage", target )
end
function Middle_corrosive_haze:TalentBuff(target)
	target:AddNewModifier(self:GetCaster(), self, "modifier_Middle_corrosive_haze", { duration = 5 } )
end


modifier_Middle_corrosive_haze = advanced_modifier({})

function modifier_Middle_corrosive_haze:IsHidden()	return false end
function modifier_Middle_corrosive_haze:IsDebuff()	return true end
function modifier_Middle_corrosive_haze:IsStunDebuff()	return false end
function modifier_Middle_corrosive_haze:IsPurgable()	return true end
function modifier_Middle_corrosive_haze:OnCreated( kv )

	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" ) 

	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_Middle_corrosive_haze:OnRefresh( kv )
	self.armor_reduction = -self:GetAbility():GetSpecialValueFor( "armor_reduce" ) 
	if IsServer() then
		self:SetStackCount(math.min(5,self:GetStackCount()+1))
	end
end


function modifier_Middle_corrosive_haze:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

function modifier_Middle_corrosive_haze:Advanced_GetModifierPhysicalArmorBonus()
	return self.armor_reduction * (1+self:GetStackCount()*0.07)
end

function modifier_Middle_corrosive_haze:GetModifierProvidesFOWVision()
	return 1
end

--------------------------------------------------------------------------------

function modifier_Middle_corrosive_haze:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_Middle_corrosive_haze:PlayEffects()
	local particle_cast = "particles/rebuild/spell/corrosive_haze/corrosive_hazeamp_damage.vpcf"
	local caster = self:GetCaster()
	local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControlEnt(pfx,0,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx,1,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	ParticleManager:SetParticleControlEnt(pfx,2,self:GetParent(),PATTACH_OVERHEAD_FOLLOW,nil,self:GetParent():GetOrigin(), true)
	self:AddParticle(pfx,false,false,-1,false,true)
end

function modifier_Middle_corrosive_haze:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_Middle_corrosive_haze:Advanced_GetModifier_StatusResistance(keys)
	return -30
end

