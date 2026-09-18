
chaotic_witch_bolt = class({})
LinkLuaModifier("modifier_chaotic_witch_bolt", "chaotic_spell/class_1/chaotic_witch_bolt", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_witch_bolt_debuff", "chaotic_spell/class_1/chaotic_witch_bolt", LUA_MODIFIER_MOTION_NONE)



function chaotic_witch_bolt:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/witch_bolt/link_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_arcana/razor_arcana_v2_unstable_current.vpcf", context )



	
end

function chaotic_witch_bolt:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end

function chaotic_witch_bolt:GetCooldown(iLevel)

	return self:GetSpecialValueFor("cooldown_time")
end




function chaotic_witch_bolt:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return self.BaseClass.GetBehavior(self)
end
function chaotic_witch_bolt:GetAOERadius()
	if self:GetRuneType()==1 then
		return  self:GetSpecialValueFor("rune_1_radius")
	end
	return 0
end
function chaotic_witch_bolt:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("max_distance") - self:GetCaster():GetCastRangeBonus() -100
end



function chaotic_witch_bolt:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	-- self:PlayEffect(target)
	   

	local type = self:GetRuneType()
	if type==1 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local count = self:GetSpecialValueFor("rune_1_bouns_count")
		for index, unit in ipairs(enemies) do
		
			if unit~=target then
				count = count - 1
				unit:AddNewModifier(caster, self, "modifier_chaotic_witch_bolt_debuff", {duration =self:GetSpecialValueFor("duration")})
				if count<=0 then
					break
				end
			end
		end
	
	end
	if self:GetRuneType()==2 then
		self.duration = self:GetSpecialValueFor("duration")*(1-self:GetSpecialValueFor("rune_2_interval_down")*0.01)
	end
	target:AddNewModifier(caster, self, "modifier_chaotic_witch_bolt_debuff", {duration = self.duration})
	caster:EmitSound("chaotic_witch_bolt_cast")
	

end





modifier_chaotic_witch_bolt_debuff = class({})

function modifier_chaotic_witch_bolt_debuff:IsHidden()	return false end
function modifier_chaotic_witch_bolt_debuff:IsDebuff()	return false end
function modifier_chaotic_witch_bolt_debuff:IsPurgable()	return true end
function modifier_chaotic_witch_bolt_debuff:IsPurgeException() return true end
function modifier_chaotic_witch_bolt_debuff:RemoveOnDeath() return true end
function modifier_chaotic_witch_bolt_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_chaotic_witch_bolt_debuff:OnCreated(keys)
	if IsServer() then

		local ability = self:GetAbility()
		self.interval = ability:GetSpecialValueFor("interval")
		if self:GetAbility():GetRuneType()==2 then
			self.interval = ability:GetSpecialValueFor("interval")*(1-ability:GetSpecialValueFor("rune_2_interval_down")*0.01)
		end

		self.timer = GameRules:GetGameTime()
		self:StartIntervalThink(0.1)

		self.distance = ability:GetSpecialValueFor("max_distance")
		self.min_distance = 500
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/witch_bolt/link_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		
		-- self.thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_generic_soundPlayer", {duration = self:GetRemainingTime(),attach_caster = 1}, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false)
		-- self.thinker:EmitSound("Ability.static.loop")
	end
end
function modifier_chaotic_witch_bolt_debuff:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end

	local parent = self:GetParent()
	local caster = self:GetCaster()
	local dis = CalculateDistance(parent,caster)
	if dis>= self.distance then
		self:Destroy()
		return
	end
	local time = GameRules:GetGameTime()
	if time>=self.timer then
		self.timer = self.timer + self.interval
		local head_particle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_v2_unstable_current.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(head_particle)
		parent:EmitSound("chaotic_witch_bolt_hit")
	
		local ability = self:GetAbility()
		local damage = ability:GetSpecialValueFor( "base_damage" ) + ability:GetSpecialValueFor( "bonus_damage" )*ability:GetCaster():HDGetPrimaryStatValue()
		local damageDecayRate = (damage / (self.distance - self.min_distance)) -- 计算每单位距离的伤害衰减值
	
		if dis <= self.min_distance then
			-- 如果距离小于等于500，不衰减
		elseif dis >= self.distance then
			damage =  0  -- 如果距离大于等于1400，伤害为0
		else
			if self:GetAbility():GetRuneType()==3 then
				damage = damage + damageDecayRate * (dis - self.min_distance)  -- 线性增加伤害值
			else
				damage = damage - damageDecayRate * (dis - self.min_distance)  -- 线性衰减伤害值
			end
		end
		if damage>=10 then
			local damageTable = {
				victim = parent,
				attacker = caster,
				damage = damage* ability:GetEffectGain(),
				damage_type = ability:GetAbilityDamageType(),
				ability = ability, --Optional.
				hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
			}
			ApplyDamage(damageTable)
		end
	end














end


function modifier_chaotic_witch_bolt_debuff:OnDestroy()

	if IsServer() then

		
		self:GetCaster():EmitSound("Ability.static.end")
		ParticleManager:DestroyParticle(self.nFXIndex,false)
		-- StopSoundEvent( "Ability.static.loop", self:GetCaster())
		-- if not self.thinker:IsNull() then
		-- 	self.thinker:StopSound("Ability.static.loop")
		-- 	self.thinker:FindModifierByName("modifier_generic_soundPlayer"):SafeDestroy()
		-- end
	end
end
