LinkLuaModifier("modifier_chaotic_blade_barrier_thinker_particle", "chaotic_spell/class_6/chaotic_blade_barrier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_blade_barrier_thinker_effect", "chaotic_spell/class_6/chaotic_blade_barrier", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_blade_barrier_debuff", "chaotic_spell/class_6/chaotic_blade_barrier", LUA_MODIFIER_MOTION_NONE)

chaotic_blade_barrier = class({})

function chaotic_blade_barrier:OnAbilityPhaseInterrupted()

end
function chaotic_blade_barrier:OnAbilityPhaseStart()
	if not self:CheckVectorTargetPosition() then return false end
	SendToConsole("-dota_ability_execute")  --由于ntV蛇不知道改了什么东西需要手动取消施法状态
	return true 
end


function chaotic_blade_barrier:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/blade_barrier/effect.vpcf", context )


end



function chaotic_blade_barrier:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local targets = self:GetVectorTargetPosition()


	local distance = self:GetSpecialValueFor("vector_distance_max")

	local startPos = targets.init_pos
	local endPos = startPos +  distance *  targets.direction


	local duration = self:GetSpecialValueFor("duration")
	local thinker = CreateModifierThinker(caster, self, "modifier_chaotic_blade_barrier_thinker_particle", {duration = duration,endPos_x = endPos.x, endPos_y = endPos.y}, startPos, caster:GetTeamNumber(), false)




	local blocks = distance/175
	local block_pos = 175

	local gain = self:GetEffectGain()
	for i=1,blocks do
		local block_vec = startPos + targets.direction*block_pos
		local thinker = CreateModifierThinker(
			caster, -- player source
			self, -- ability source
			"modifier_chaotic_blade_barrier_thinker_effect", -- modifier name
			{ duration = duration ,gain=gain}, -- kv
			block_vec,
			caster:GetTeamNumber(),
			true
		)

		block_pos = block_pos + 175
	end


end







modifier_chaotic_blade_barrier_thinker_particle = advanced_modifier({})

function modifier_chaotic_blade_barrier_thinker_particle:IsAura()return true end
function modifier_chaotic_blade_barrier_thinker_particle:OnCreated(keys)
	if IsServer() then

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local parent = self:GetParent()
		parent:EmitSound("Hero_Clinkz.TarBomb.Target")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/blade_barrier/effect.vpcf", PATTACH_POINT_FOLLOW, parent)
		-- ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		-- ParticleManager:SetParticleControlEnt( self.particle,3, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl(self.particle,0,parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle,1,Vector(keys.endPos_x,keys.endPos_y,0))
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_blade_barrier_thinker_particle:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_blade_barrier_thinker_particle:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end

function modifier_chaotic_blade_barrier_thinker_particle:CheckState()
	local state	=	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end








modifier_chaotic_blade_barrier_thinker_effect = advanced_modifier({})

function modifier_chaotic_blade_barrier_thinker_effect:IsAura()return true end
function modifier_chaotic_blade_barrier_thinker_effect:OnCreated(keys)
	if IsServer() then
		self:GetParent().ability_gain = keys.gain
		self.radius = self:GetAbility():GetSpecialValueFor("vector_radius")
		local parent = self:GetParent()
		parent:GameTimer(RandomFloat(0.03, 0.5), function()
			if IsValid(parent) then
				parent:EmitSound("DOTA_Item.BladeMail.Activate")
			end
		end)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_blade_barrier_thinker_effect:OnDestroy(keys)
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_blade_barrier_thinker_effect:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end



function modifier_chaotic_blade_barrier_thinker_effect:GetAuraRadius()return self.radius end
function modifier_chaotic_blade_barrier_thinker_effect:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_blade_barrier_thinker_effect:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_chaotic_blade_barrier_thinker_effect:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_blade_barrier_thinker_effect:GetAuraDuration() return 0.05 end
function modifier_chaotic_blade_barrier_thinker_effect:GetModifierAura()return "modifier_chaotic_blade_barrier_debuff" end
function modifier_chaotic_blade_barrier_thinker_effect:GetAuraEntityReject(hEntity)
	-- if hEntity:IsFlying() or hEntity:IsFlyingPathing() then
	-- 	return true
	-- end
	if hEntity:IsImmuneDisadvantagedTerrain() then
		-- 免疫劣势地形影响
		return true
	end
	return false
end

function modifier_chaotic_blade_barrier_thinker_effect:CheckState()
	local state	=	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return state
end


-- 






modifier_chaotic_blade_barrier_debuff = advanced_modifier({})

function modifier_chaotic_blade_barrier_debuff:IsHidden() 			return false end
function modifier_chaotic_blade_barrier_debuff:IsPurgable() 			return false end
function modifier_chaotic_blade_barrier_debuff:IsPurgeException() 	return false end
function modifier_chaotic_blade_barrier_debuff:IsDebuff() return true end



function modifier_chaotic_blade_barrier_debuff:OnCreated(keys)
	self.move_speed_reduction = -self:GetAbility():GetSpecialValueFor("move_slow")
	if IsServer() then
		if not IsEnemy(self:GetParent(),self:GetCaster()) then
			return
		end
		self.gain = 1
		if self:GetAuraOwner() then
			self.gain = self:GetAuraOwner().ability_gain or 1
		end

		local ability = self:GetAbility()
		-- local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*ability:GetCaster():HDGetPrimaryStatValue()
		self:GetParent():EmitSound("DOTA_Item.BladeMail.Damage")
		self.rune_1_bonus = ability:GetSpecialValueFor("rune_1_bonus")*0.01+1
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability, --Optional.
		}
		



		self:StartIntervalThink(RandomFloat(0.3, 0.8))
	end
end

function modifier_chaotic_blade_barrier_debuff:OnIntervalThink()
	self:StartIntervalThink(1)
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*self:GetCaster():HDGetPrimaryStatValue()
	self.damageTable.damage = damage*self.gain
	if ability:GetRuneType()==1 and self:GetParent():IsMoving() then
		-- print("self.damageTable.damage=",self.damageTable.damage)
		self.damageTable.damage = self.damageTable.damage * self.rune_1_bonus
		-- print("self.damageTable.damage=",self.damageTable.damage)
	end
	ApplyDamage(self.damageTable)

end


function modifier_chaotic_blade_barrier_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_chaotic_blade_barrier_debuff:GetModifierMoveSpeedBonus_Constant() 
	if self:GetParent():IsImmuneDisadvantagedTerrain_Slow() then
		-- 免疫劣势地形减速
		return 0
	end
	return   self.move_speed_reduction 
end
function modifier_chaotic_blade_barrier_debuff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end


