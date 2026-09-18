heroTalent_npc_dota_hero_snapfire_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_snapfire_4", "heroTalent/heroTalent_npc_dota_hero_snapfire_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_snapfire_buff", "heroTalent/heroTalent_npc_dota_hero_snapfire", LUA_MODIFIER_MOTION_NONE )

-- function heroTalent_npc_dota_hero_snapfire_4:GetIntrinsicModifierName()
-- 	return "modifier_heroTalent_npc_dota_hero_snapfire_4"
-- end


function heroTalent_npc_dota_hero_snapfire_4:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/snapfire/snapfire_frostivus_2023/snapfire_frostivus_ultimate_lizard_blobs_arced.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/snapfire/snapfire_frostivus_2023/snapfire_frostivus_ultimate_linger.vpcf", context )
end

function heroTalent_npc_dota_hero_snapfire_4:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end
function heroTalent_npc_dota_hero_snapfire_4:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end
function heroTalent_npc_dota_hero_snapfire_4:OnToggle()
	if not IsServer() then return end
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_heroTalent_npc_dota_hero_snapfire_4", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_heroTalent_npc_dota_hero_snapfire_4", self:GetCaster())
	end
end


modifier_heroTalent_npc_dota_hero_snapfire_4 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_snapfire_4:IsHidden()	return self:GetStackCount()<=0 end
function modifier_heroTalent_npc_dota_hero_snapfire_4:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_4:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_snapfire_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_snapfire_4:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_snapfire_4:OnCreated(keys)
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	if IsServer() then
		
		self.attack_speed_require = self:GetAbility():GetSpecialValueFor("attack_speed_require")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.split_damage = self:GetAbility():GetSpecialValueFor("split_damage")*0.01
		self.timer = GameRules:GetGameTime()
		self.record = {}
	end
end
function modifier_heroTalent_npc_dota_hero_snapfire_4:OnRefresh(keys)
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	if IsServer() then
		
		self.attack_speed_require = self:GetAbility():GetSpecialValueFor("attack_speed_require")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.bonus_attack_damage = self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.split_damage = self:GetAbility():GetSpecialValueFor("split_damage")*0.01
		self.timer = GameRules:GetGameTime()
		self.record = {}
	end
end
function modifier_heroTalent_npc_dota_hero_snapfire_4:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end


function modifier_heroTalent_npc_dota_hero_snapfire_4:GetModifierProjectileName()
    if IsServer() and self:GetParent():IsApplyModifier() then
        return "particles/econ/items/snapfire/snapfire_frostivus_2023/snapfire_frostivus_ultimate_lizard_blobs_arced.vpcf" 
    end	
end 

function modifier_heroTalent_npc_dota_hero_snapfire_4:GetAttackSound()
	return "Hero_Snapfire.MortimerBlob.Launch"
end


function modifier_heroTalent_npc_dota_hero_snapfire_4:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL, -- 最终全伤害提升


    }
end

function modifier_heroTalent_npc_dota_hero_snapfire_4:OnAttack(keys)
	if not IsServer() then return end
	if not self:GetAbility():IsCooldownReady() then
		return
	end
	if not self:GetParent():IsRealHero() then
		return false
	end
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then	

		local caster = self:GetCaster()
		if not caster:IsRangedAttacker() or not caster:IsApplyModifier() then
			return
		end
		local time = GameRules:GetGameTime()
		if self.timer>=time then
			return
		end
		local ability = self:GetAbility()
		if ability then	
			-- print("1111 =",self.interval)
			self.record[keys.record]  = true
			keys.attacker:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
			keys.attacker:GameTimer(0.03, function()
				keys.attacker:AttackNoEarlierThan( self.interval,GameRules:GetGameTime()+ self.interval)
			end)
			
			-- self.timer = GameRules:GetGameTime() + 2
			-- keys.attacker:AttackNoEarlierThan( time, 9999)
			-- ability:ReleaseLaser(keys.target)
			-- caster:AddNewModifier(caster,self:GetAbility(),"modifier_heroTalent_npc_dota_hero_sniper_3_debuff",{duration = 2})
		end


	
		
		
		
		
	end
end

function modifier_heroTalent_npc_dota_hero_snapfire_4:Advanced_GetModifierAttackRangeBonus(keys)
	return self.bonus_attack_range
end



function modifier_heroTalent_npc_dota_hero_snapfire_4:OnTakeDamage( keys )

	if IsServer() then
		local Attacker = keys.attacker
		local Target = keys.unit
		local Ability = keys.inflictor
		local flDamage = keys.damage
		local feast_aiblity = self:GetAbility()

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		if self.record[keys.record] then
			self.record[keys.record] = nil
			local pos = Target:GetAbsOrigin()
			EmitSoundOnLocationWithCaster(pos, "SeasonalConsumable.TI10.HotPotato.Explode", Attacker)


			local pfx = ParticleManager:CreateParticle( "particles/econ/items/snapfire/snapfire_frostivus_2023/snapfire_frostivus_ultimate_linger.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( pfx, 0, pos )
			DestroyParticleByDelay(pfx,5)
			

			local enemies = FindUnitsInRadius(Attacker:GetTeamNumber(), pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
			-- local duration =self:GetAbility():GetSpecialValueFor("slow_duration")
			-- print("flDamage*self.split_damage=",flDamage*self.split_damage)
			local damageTable = {
				-- victim = enemy,
				attacker = Attacker,
				damage = flDamage*self.split_damage,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, --Optional.
				ability = self:GetAbility(), --Optional.
				hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY + HD_DAMAGE_FLAG_NO_SPELL_CRIT
			}
			for i, enemy in pairs(enemies) do
				if enemy~=Target then
					damageTable.victim = enemy
					ApplyDamage(damageTable)
				end
			end
		end
	end
	return 0.0
end



function modifier_heroTalent_npc_dota_hero_snapfire_4:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if IsServer() then
		if self.record[keys.record] then
			local as = self:GetParent():GetAttackSpeed(false) * 100
			local bonus = math.floor(as/self.attack_speed_require) * self.bonus_attack_damage
			if bonus>0 then
				-- print("bonus",bonus)
				return math.min(bonus,2000)
			end
		end
	end
	return 0
end


function modifier_heroTalent_npc_dota_hero_snapfire_4:GetModifierMoveSpeedBonus_Constant() 
    return -5000
end

