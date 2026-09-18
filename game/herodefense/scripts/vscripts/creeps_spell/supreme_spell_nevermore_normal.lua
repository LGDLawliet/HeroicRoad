LinkLuaModifier( "modifier_supreme_spell_nevermore_normal", "creeps_spell/supreme_spell_nevermore_normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_normal_tri", "creeps_spell/supreme_spell_nevermore_normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_supreme_spell_nevermore_normal_last", "creeps_spell/supreme_spell_nevermore_normal", LUA_MODIFIER_MOTION_NONE )
supreme_spell_nevermore_normal = class({})

function supreme_spell_nevermore_normal:GetIntrinsicModifierName()
	return "modifier_supreme_spell_nevermore_normal"
end
function supreme_spell_nevermore_normal:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/sf/final_end.vpcf", context )
end
---------------------------------------------------------------------


modifier_supreme_spell_nevermore_normal = advanced_modifier({})
function modifier_supreme_spell_nevermore_normal:IsPurgable() return false end

function modifier_supreme_spell_nevermore_normal:OnCreated(params)
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
	self.incoming_max = self:GetAbility():GetSpecialValueFor("incoming_max")
	self.tri_line = self:GetAbility():GetSpecialValueFor("tri_line")
	self.tri_duration = self:GetAbility():GetSpecialValueFor("tri_duration")
	self.rise = false
	if IsServer() then
		self:GetCaster():GameTimer(0.05,function ()
			local heroes = GetAllRealHeroes()
			for _,hero in pairs(heroes)do
				local soul = hero:FindModifierByName("modifier_creep_act1_treasure_debuff")
				if soul then
					soul:Destroy()
					self:SetStackCount(math.min((self:GetStackCount() + self.incoming),self.incoming_max))
				end
			end
		end)
	end
end

function modifier_supreme_spell_nevermore_normal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end

function modifier_supreme_spell_nevermore_normal:GetMinHealth()
	if self.rise == false then
		return self:GetParent():GetMaxHealth()*self.tri_line*0.01
	end
	return
end

function modifier_supreme_spell_nevermore_normal:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH = {nil,nil},
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
	}
end

function modifier_supreme_spell_nevermore_normal:OnTakeDamage(keys)
	if not IsServer() then return end
	if keys.unit ~= self:GetParent() then return end
	if self:GetParent():GetHealthPercent() <= self.tri_line and self.rise == false then
		if not self:GetParent():HasModifier("modifier_supreme_spell_nevermore_normal_tri") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_supreme_spell_nevermore_normal_tri", {duration = self.tri_duration})
		end
	end
end

function modifier_supreme_spell_nevermore_normal:OnDeath(keys)
	if not IsServer() then return end
	self.hp_get = self:GetAbility():GetSpecialValueFor("hp_get")
	self.index = self:GetAbility():GetSpecialValueFor("index")
	if keys.unit:IsRealHero() then
		self.hp_get = self.hp_get*(1+self.index*0.01)
	end
	self:GetParent():Heal(self:GetParent():GetMaxHealth()*self.hp_get, self:GetAbility())
end

function modifier_supreme_spell_nevermore_normal:Advanced_GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()
end

--------------------------------------------------------
modifier_supreme_spell_nevermore_normal_tri = advanced_modifier({})

function modifier_supreme_spell_nevermore_normal_tri:IsPurgable() return false end
function modifier_supreme_spell_nevermore_normal_tri:IsHidden() return true end
function modifier_supreme_spell_nevermore_normal_tri:OnDestroy()
	if IsServer() then
		local modifier = self:GetParent():FindModifierByName("modifier_supreme_spell_nevermore_normal")
		modifier.rise = true
		self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_supreme_spell_nevermore_normal_last",{})
	end
end
function modifier_supreme_spell_nevermore_normal_tri:CheckState()
	return{
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_supreme_spell_nevermore_normal_tri:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_supreme_spell_nevermore_normal_tri:Advanced_GetModifierIncomingDamage_Percentage()
	return -200
end

-----
modifier_supreme_spell_nevermore_normal_last = advanced_modifier({})
function modifier_supreme_spell_nevermore_normal_last:IsDebuff() return false end
function modifier_supreme_spell_nevermore_normal_last:IsHidden() return true end
function modifier_supreme_spell_nevermore_normal_last:IsPurgable() return false end

function modifier_supreme_spell_nevermore_normal_last:OnCreated(params)
	if IsServer() then
		self:GetCaster():GameTimer(0.05,function ()
			local caster = self:GetCaster()
			local effect_name = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
			local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleShouldCheckFoW( effect_cast,false )
			ParticleManager:SetParticleControl(effect_cast,0,Vector(-300,-1053,64))
			ParticleManager:ReleaseParticleIndex(effect_cast)

			local effect_name2 = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
			local effect_cast2 = ParticleManager:CreateParticle( effect_name2, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleShouldCheckFoW( effect_cast2,false )
			ParticleManager:SetParticleControl(effect_cast2,0,Vector(-300,-1053,64))
			ParticleManager:ReleaseParticleIndex(effect_cast2)
		end)
		self:StartIntervalThink(1)
	end
end

function modifier_supreme_spell_nevermore_normal_last:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_supreme_spell_nevermore_normal_last:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_supreme_spell_nevermore_normal_last:GetOverrideAnimationRate( params )
	return 1.7
end

function modifier_supreme_spell_nevermore_normal_last:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_6
end

function modifier_supreme_spell_nevermore_normal_last:OnIntervalThink()
	local caster = self:GetCaster()

	local effect_name = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
	local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleShouldCheckFoW( effect_cast,false )
	ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 100000,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_ANY_ORDER, false )
	local damage = self:GetAbility():GetSpecialValueFor("damage") * self:GetCaster():GetAverageTrueAttackDamage(nil)
	for _,enemy in pairs(enemies)do
		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			--damage = ,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
			--hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}
		local damage = self:GetAbility():GetSpecialValueFor("damage") * self:GetCaster():GetAverageTrueAttackDamage(nil) +self:GetAbility():GetSpecialValueFor("damage_pct")*0.01*enemy:GetMaxHealth()
		if enemy:IsMagicImmune() then
			self.damageTable.damage = damage *0.5
		else
			self.damageTable.damage = damage
		end
		ApplyDamage(self.damageTable)
	end
end