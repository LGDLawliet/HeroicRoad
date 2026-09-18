LinkLuaModifier("modifier_Middle_summon_immortal_sarcophagus_idle", "skills/Middle_summon_immortal_sarcophagus", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
Middle_summon_immortal_sarcophagus						= Middle_summon_immortal_sarcophagus or class({})



function Middle_summon_immortal_sarcophagus:IsSummonSpell()return true end



function Middle_summon_immortal_sarcophagus:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_immortal_sarcophagus/dead_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold.vpcf", context )
	PrecacheResource( "particle", "particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_sparkle.vpcf", context )
	PrecacheResource( "particle", "particles/econ/world/towers/ti10_radiant_tower/ti10_radiant_tower_destruction_ray.vpcf", context )
	PrecacheResource( "particle", "particles/world_tower/tower_upgrade/ti7_radiant_tower_orb.vpcf", context )


	
end

function Middle_summon_immortal_sarcophagus:OnSpellStart()

	
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

	unit:AddNewModifier(caster, self, "modifier_Middle_summon_immortal_sarcophagus_idle", {})
	local particle_cast_fx = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_gold.vpcf", PATTACH_ABSORIGIN, unit)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, unit:GetOrigin())
	DestroyParticleByDelay(particle_cast_fx,4)
end


modifier_Middle_summon_immortal_sarcophagus_idle = modifier_Middle_summon_immortal_sarcophagus_idle or class({})

function modifier_Middle_summon_immortal_sarcophagus_idle:IsDebuff()			return false end
function modifier_Middle_summon_immortal_sarcophagus_idle:IsHidden() 			return false end
function modifier_Middle_summon_immortal_sarcophagus_idle:IsPurgable() 		return false end
function modifier_Middle_summon_immortal_sarcophagus_idle:IsPurgeException() 	return false  end


function modifier_Middle_summon_immortal_sarcophagus_idle:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		parent:AddActivityModifier("showcase")
		parent:StartGesture(ACT_DOTA_IDLE)
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
		self.bonus_damage_index = 0.7
		self.timer = 0


		self.nFXIndex = ParticleManager:CreateParticle( "particles/world_tower/tower_upgrade/ti7_radiant_tower_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, nil, parent:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
	end
end

function modifier_Middle_summon_immortal_sarcophagus_idle:OnIntervalThink()

	self:SetStackCount(self:GetStackCount()*0.92)
	self:ReleaseDamage(1)
end

function modifier_Middle_summon_immortal_sarcophagus_idle:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/summon_immortal_sarcophagus/dead_effect/effect.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin())
		ParticleManager:SetParticleControlForward(effect_cast, 0, parent:GetForwardVector()) 
		local skin_type = 0
		local level = 2
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(skin_type,level-1,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
		-- local scale = parent:GetModelScale()
		-- local timer = 0

		parent:EmitSound("Building_Generic.PartialDestruction")
		local scale = parent:GetModelScale()
		local timer = 0
		Timers:CreateTimer(FrameTime(), function()
			timer = timer + FrameTime()
			if timer>=0.4 then
				parent:AddNoDraw()
				return nil
			end
			scale = scale*0.95
			parent:SetModelScale(scale)

			return FrameTime()
			
		end)
		
	end
end
function modifier_Middle_summon_immortal_sarcophagus_idle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_Middle_summon_immortal_sarcophagus_idle:GetOverrideAnimation(params)
	return ACT_DOTA_CAPTURE
end
function modifier_Middle_summon_immortal_sarcophagus_idle:GetActivityTranslationModifiers()	
	return "level2" 
end
function modifier_Middle_summon_immortal_sarcophagus_idle:ReleaseDamage(mul)
	local parent = self:GetParent()
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	self.damageTable.damage = parent:GetDamageMax() * self.damage_index*mul
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

function modifier_Middle_summon_immortal_sarcophagus_idle:OnTakeDamage( params )

	if IsServer() then
		-- local Attacker = params.attacker
		local Target = params.unit
		-- local Ability = params.inflictor
		local flDamage = params.damage

		if Target ~= self:GetParent() then
			return 0
		end
		if flDamage<=0 then
			
			return
		end
		self:SetStackCount(self:GetStackCount()+flDamage*0.5)


		local parent_damage = Target:GetDamageMax()
		local stack = self:GetStackCount()
		if stack>=parent_damage then
			local time = GameRules:GetGameTime()
			if self.timer>=time then
				return
			end
			if 20>=RandomInt(1, 100) then
				local mul = math.floor(stack/parent_damage)
			
				if mul>1 then
					mul = 1 + (mul-1)*self.bonus_damage_index 
				end
				self:ReleaseDamage(mul)
				self:SetStackCount(0)
				self.timer = time +0.3
			end
		end


	end

	return 0.0

end