--CreateEmptyTalents("axe")

Primary_Berserkers_Call = class({})
LinkLuaModifier("modifier_Primary_Berserkers_Call_as", "skills/Primary_Berserkers_Call", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Berserkers_Call_armor", "skills/Primary_Berserkers_Call", LUA_MODIFIER_MOTION_NONE)
-- modifier_Primary_Berserkers_Call

function Primary_Berserkers_Call:IsHiddenWhenStolen() 		return false end
function Primary_Berserkers_Call:IsRefreshable() 			return false end
function Primary_Berserkers_Call:IsStealable() 			return true end
function Primary_Berserkers_Call:IsNetherWardStealable() 	return true end

function Primary_Berserkers_Call:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Primary_Berserkers_Call:OnAbilityPhaseStart()
	print(self:GetCaster():GetAbilityPoints())
	self:GetCaster():EmitSound("Hero_Axe.BerserkersCall.Start")
	-- self:GetCaster():AddActivityModifier("hd_avtivity")
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	-- self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_4,1)

	return true
end

function Primary_Berserkers_Call:OnAbilityPhaseInterrupted() self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1) end

function Primary_Berserkers_Call:OnSpellStart()



	local caster = self:GetCaster()
	caster:EmitSound("Hero_Axe.Berserkers_Call")
	caster:AddNewModifier(caster, self, "modifier_Primary_Berserkers_Call_armor", {duration = self:GetSpecialValueFor("duration")})
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									self:GetSpecialValueFor("radius"),
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER,
									false)
	for _, enemy in pairs(enemies) do
		if not enemy:ImmuneForceAttack() then
			enemy:AddNewModifier(caster, self, "modifier_Primary_Berserkers_Call_as", {duration = self:GetSpecialValueFor("duration")})
		end
		-- enemy:AddNewModifier(caster, self, "modifier_Primary_Berserkers_Call", {duration = self:GetSpecialValueFor("duration")})
		
	end
	local pfx_name = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_mouth")))
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
end
MUSIC={
	"teamfandom.2.8204512.140239",
	"teamfandom.2.7407260.140175"
}
function Primary_Berserkers_Call:EndAbility()
	local caster = self:GetCaster()
	caster:EmitSound(MUSIC[RandomInt(1, 2)])
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									self:GetSpecialValueFor("radius"),
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER,
									false)
	for _, enemy in pairs(enemies) do
		local buffs = enemy:FindAllModifiersByName("modifier_Primary_Berserkers_Call_as")
		if  #buffs ~= 0 then
			buffs[1]:SafeDestroy()
		end

	end

end



modifier_Primary_Berserkers_Call_as = class({})

function modifier_Primary_Berserkers_Call_as:IsDebuff()				return true end
function modifier_Primary_Berserkers_Call_as:IsHidden() 			return true end
function modifier_Primary_Berserkers_Call_as:IsPurgable() 			return true end
function modifier_Primary_Berserkers_Call_as:IsPurgeException() 	return true end
function modifier_Primary_Berserkers_Call_as:CheckState() return {[MODIFIER_STATE_TAUNTED]=true} end
function modifier_Primary_Berserkers_Call_as:StatusEffectPriority(  )
	return 10
end


function modifier_Primary_Berserkers_Call_as:OnCreated( kv )
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) 
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end

end

function modifier_Primary_Berserkers_Call_as:OnRemoved()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end

function modifier_Primary_Berserkers_Call_as:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end


modifier_Primary_Berserkers_Call_armor = advanced_modifier({})

function modifier_Primary_Berserkers_Call_armor:IsDebuff()				return false end
function modifier_Primary_Berserkers_Call_armor:IsHidden() 			return false end
function modifier_Primary_Berserkers_Call_armor:IsPurgable() 			return false end
function modifier_Primary_Berserkers_Call_armor:IsPurgeException() 	return false end
-- function modifier_Primary_Berserkers_Call_armor:StatusEffectPriority(  )return MODIFIER_PRIORITY_LOW end
function modifier_Primary_Berserkers_Call_armor:DeclareFunctions() return {
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	
} 
end

function modifier_Primary_Berserkers_Call_armor:Advanced_GetModifierPhysicalArmorBonus() return self:GetAbility():GetSpecialValueFor("bonus_armor") end
	
	
function modifier_Primary_Berserkers_Call_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end