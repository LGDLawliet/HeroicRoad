LinkLuaModifier("modifier_Primary_summon_immortal_sarcophagus_idle", "skills/Primary_summon_immortal_sarcophagus", LUA_MODIFIER_MOTION_NONE)

Primary_summon_immortal_sarcophagus						= Primary_summon_immortal_sarcophagus or class({})



function Primary_summon_immortal_sarcophagus:IsSummonSpell()return true end







function Primary_summon_immortal_sarcophagus:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_immortal_sarcophagus/dead_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold.vpcf", context )
	PrecacheResource( "particle", "particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_sparkle.vpcf", context )
	PrecacheResource( "particle", "particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_ray.vpcf", context )



end

function Primary_summon_immortal_sarcophagus:OnSpellStart()

	
	local caster =self:GetCaster()
	EmitSoundOn("Creep_Siege_Dire.Destruction", caster)	

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()
	
	local pos = caster:GetAbsOrigin() + (caster:GetForwardVector() * 200)
	local unit = caster:SummonUnit("npc_hd_immortal_sarcophagus",life_duration,
	pos,
	caster:GetForwardVector(),self,0,heal,0,damage,armor,1,1)

	unit:AddNewModifier(caster, self, "modifier_Primary_summon_immortal_sarcophagus_idle", {})
	local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold.vpcf", PATTACH_ABSORIGIN, unit)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetOrigin())
	DestroyParticleByDelay(particle_cast_fx,4)
end


modifier_Primary_summon_immortal_sarcophagus_idle = modifier_Primary_summon_immortal_sarcophagus_idle or class({})

function modifier_Primary_summon_immortal_sarcophagus_idle:IsDebuff()			return false end
function modifier_Primary_summon_immortal_sarcophagus_idle:IsHidden() 			return true end
function modifier_Primary_summon_immortal_sarcophagus_idle:IsPurgable() 		return false end
function modifier_Primary_summon_immortal_sarcophagus_idle:IsPurgeException() 	return false  end


function modifier_Primary_summon_immortal_sarcophagus_idle:OnCreated()
	if IsServer() then
		-- local parent = self:GetParent()
		-- parent:AddActivityModifier("showcase")
		local ability = self:GetAbility()
		self.damage_index = ability:GetSpecialValueFor("damage_change_rate")*0.01
		self.radius =  ability:GetSpecialValueFor("radius")
		self.effect_count = 4
		self.damageTable ={
			-- victim = parent, 
			attacker = self:GetCaster(),
			-- damage = dmg, 
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = ability
		}
		self:StartIntervalThink(1.5)

	end
end

function modifier_Primary_summon_immortal_sarcophagus_idle:OnIntervalThink()

	local parent = self:GetParent()
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.damageTable.damage = parent:GetDamageMax() * self.damage_index
	local count = self.effect_count
	for i, unit in ipairs(units) do
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_ray.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetOrigin())
		DestroyParticleByDelay(particle_cast_fx,1.5)
		self.damageTable.victim = unit
		ApplyDamage(self.damageTable)
		count = count - 1
		if count<=0 then
			break
		end
	end
	

	if count<self.effect_count then
		parent:EmitSound("Tower.Fire.Attack")
		local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_sparkle.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetOrigin())
		DestroyParticleByDelay(particle_cast_fx,3)
	end

end

function modifier_Primary_summon_immortal_sarcophagus_idle:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/summon_immortal_sarcophagus/dead_effect/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin())
		ParticleManager:SetParticleControlForward(effect_cast, 0, parent:GetForwardVector()) 
		local skin_type = 0
		local level = 1
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(skin_type,level-1,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		-- local scale = parent:GetModelScale()
		-- local timer = 0

		parent:EmitSound("Building_Generic.PartialDestruction")
		parent:AddNoDraw()
		
	end
end
function modifier_Primary_summon_immortal_sarcophagus_idle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_Primary_summon_immortal_sarcophagus_idle:GetOverrideAnimation(params)
	return ACT_DOTA_CAPTURE
end
function modifier_Primary_summon_immortal_sarcophagus_idle:GetActivityTranslationModifiers()	
	return "level1" 
end