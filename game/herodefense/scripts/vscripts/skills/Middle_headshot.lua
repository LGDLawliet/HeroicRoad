Middle_headshot = class({})
LinkLuaModifier( "modifier_Middle_headshot_buff", "skills/Middle_headshot", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_headshot_debuff", "skills/Middle_headshot", LUA_MODIFIER_MOTION_NONE )


function Middle_headshot:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )

end


function Middle_headshot:GetIntrinsicModifierName()
	return "modifier_Middle_headshot_buff"
end





modifier_Middle_headshot_buff = modifier_Middle_headshot_buff or class({})
function modifier_Middle_headshot_buff:IsHidden()	return true end
function modifier_Middle_headshot_buff:IsPurgable()	return false end

function modifier_Middle_headshot_buff:OnCreated( kv )
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" ) 
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) 

end

function modifier_Middle_headshot_buff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_Middle_headshot_buff:OnDestroy( kv )

end


function modifier_Middle_headshot_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

function modifier_Middle_headshot_buff:GetModifierProcAttack_BonusDamage_Physical( keys )
	if IsServer() then
		local caster = self:GetCaster()
		if caster:PassivesDisabled() or not caster:IsApplyModifier() then
			return
		end
		if self:GetCaster():RollRandom(self.proc_chance,1)  then
			keys.target:EmitSound("Hero_Sniper.MKG_impact")
			keys.target:AddNewModifier(
				caster,
				self:GetAbility(),
				"modifier_Middle_headshot_debuff",
				{ 
					duration = self.slow_duration,
				} -- kv
			)
			local distance =  CalculateDistance(keys.target,caster)
			local bonus_damage = math.min(distance/100,30)*caster:GetAverageTrueAttackDamage(nil)*0.03
			return self:GetAbility():GetSpecialValueFor( "bonus_damage" ) +bonus_damage
		end
	end
end







modifier_Middle_headshot_debuff = modifier_Middle_headshot_debuff or class({})


function modifier_Middle_headshot_debuff:IsHidden()	return false end
function modifier_Middle_headshot_debuff:IsDebuff()	return true end
function modifier_Middle_headshot_debuff:IsPurgable()	return true end
function modifier_Middle_headshot_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor("move_slow")
end


function modifier_Middle_headshot_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end
function modifier_Middle_headshot_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.slow
end
function modifier_Middle_headshot_debuff:GetEffectName()
	return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end

function modifier_Middle_headshot_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end