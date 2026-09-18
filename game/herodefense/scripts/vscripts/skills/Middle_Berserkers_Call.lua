--CreateEmptyTalents("axe")

Middle_Berserkers_Call = class({})
LinkLuaModifier("modifier_Middle_Berserkers_Call_as", "skills/Middle_Berserkers_Call", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Berserkers_Call_armor", "skills/Middle_Berserkers_Call", LUA_MODIFIER_MOTION_NONE)
-- modifier_Middle_Berserkers_Call
require('internal/timers')   --计时器功能
function Middle_Berserkers_Call:IsHiddenWhenStolen() 		return false end
function Middle_Berserkers_Call:IsRefreshable() 			return false end
function Middle_Berserkers_Call:IsStealable() 			return true end
function Middle_Berserkers_Call:IsNetherWardStealable() 	return true end

function Middle_Berserkers_Call:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus() end

function Middle_Berserkers_Call:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Axe.BerserkersCall.Start")
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	return true
end

function Middle_Berserkers_Call:OnAbilityPhaseInterrupted() self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1) end

function Middle_Berserkers_Call:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Axe.Berserkers_Call")
	caster:AddNewModifier(caster, self, "modifier_Middle_Berserkers_Call_armor", {duration = self:GetSpecialValueFor("duration")})
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
			enemy:AddNewModifier(caster, self, "modifier_Middle_Berserkers_Call_as", {duration = self:GetSpecialValueFor("duration")})
		end
		-- enemy:AddNewModifier(caster, self, "modifier_Middle_Berserkers_Call", {duration = self:GetSpecialValueFor("duration")})
		
	end
	local pfx_name = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"

	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_mouth")))
	ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
end





modifier_Middle_Berserkers_Call_as = class({})

function modifier_Middle_Berserkers_Call_as:IsDebuff()				return true end
function modifier_Middle_Berserkers_Call_as:IsHidden() 			return true end
function modifier_Middle_Berserkers_Call_as:IsPurgable() 			return true end
function modifier_Middle_Berserkers_Call_as:IsPurgeException() 	return true end
function modifier_Middle_Berserkers_Call_as:CheckState() return {[MODIFIER_STATE_TAUNTED]=true} end
function modifier_Middle_Berserkers_Call_as:StatusEffectPriority(  )
	return 10
end
function modifier_Middle_Berserkers_Call_as:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,}
	return funcs
end

function modifier_Middle_Berserkers_Call_as:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_as") end


function modifier_Middle_Berserkers_Call_as:OnCreated( kv )
	if not IsServer() then
		return
	end
	if not self:GetCaster():IsAttackImmune() and not self:GetCaster():IsInvulnerable() then
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) 
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) 
	end
end

function modifier_Middle_Berserkers_Call_as:OnRemoved()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end

function modifier_Middle_Berserkers_Call_as:OnDestroy()
	if not IsServer() then
		return
	end
	self:GetParent():SetForceAttackTarget( nil )
	self:GetParent():Stop()
end


modifier_Middle_Berserkers_Call_armor = class({})

function modifier_Middle_Berserkers_Call_armor:IsDebuff()				return false end
function modifier_Middle_Berserkers_Call_armor:IsHidden() 			return false end
function modifier_Middle_Berserkers_Call_armor:IsPurgable() 			return false end
function modifier_Middle_Berserkers_Call_armor:IsPurgeException() 	return false end
-- function modifier_Middle_Berserkers_Call_armor:StatusEffectPriority(  )return MODIFIER_PRIORITY_LOW end
function modifier_Middle_Berserkers_Call_armor:DeclareFunctions() return {
	MODIFIER_EVENT_ON_TAKEDAMAGE,} end

function modifier_Middle_Berserkers_Call_armor:OnTakeDamage(keys)
	if keys.unit ~= self:GetParent() then
		return 
	end
	--不反映刃甲伤害
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
		return
	end
	--生命丢失也不要
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then 
		return 0
	end
	--技能伤害不要
	-- print(" keys.damage_category=".. keys.damage_category)
	if keys.damage_category~=1 then 
		return 0
	end
	if IsServer() then
		--返还生命值
		local dmg = keys.damage*0.3
		local parent = self:GetParent()
		Timers:CreateTimer(0.2, function()
			parent:Heal(dmg, parent)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent,dmg, nil) 
		end)
		-- parent:Heal(dmg, parent)
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,parent,dmg, nil) 

		
	end
end
