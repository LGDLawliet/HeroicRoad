LinkLuaModifier("modifier_chaotic_Thundergods_Wrath_debuff", "chaotic_spell/class_super/chaotic_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Thundergods_Wrath_area", "chaotic_spell/class_super/chaotic_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Thundergods_Wrath_listener", "chaotic_spell/class_super/chaotic_Thundergods_Wrath", LUA_MODIFIER_MOTION_NONE)
chaotic_Thundergods_Wrath = class({})

function chaotic_Thundergods_Wrath:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock1/effect_chaotic.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/thundergods_wrath/unlock1/effect_thunder.vpcf", context )
end

function chaotic_Thundergods_Wrath:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath")

	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
	return true
end

function chaotic_Thundergods_Wrath:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end

function chaotic_Thundergods_Wrath:Thunder(target, damage, index)
	if not IsServer then return end
	if not target then return end
	local caster = self:GetCaster()
	local unit = target 
	local index = index or 1
	local damage = damage*index
	if target:HasModifier("modifier_hd_elecshocking") then
		damage = damage*(1+self:GetSpecialValueFor("index")*0.01)
	end
	local duration = self:GetSpecialValueFor("duration")*index

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, unit)
	if self.type == 3 then
		particle = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock1/effect_thunder.vpcf", PATTACH_WORLDORIGIN, unit)
	end
	local pos = unit:GetAbsOrigin()
	ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
	ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
	ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
	ParticleManager:ReleaseParticleIndex(particle)
	unit:EmitSound("Hero_Zuus.GodsWrath.Target")
	if self.damageTable then
		self.damageTable.victim = unit
		self.damageTable.damage = damage
		ApplyDamage(self.damageTable)
	end
	if unit:IsAlive() then
		unit:AddNewModifier(caster,self,"modifier_chaotic_Thundergods_Wrath_debuff",{duration = duration})
	end
end

function chaotic_Thundergods_Wrath:OnSpellStart() 
	if IsServer() then
		self:EndCooldown()
		self:StartCooldown(self:GetSpecialValueFor("cd"))
		
		local ability 				= self
		local caster 				= self:GetCaster()
		local position 				= self:GetCaster():GetAbsOrigin()	
		self.type					= ability:GetRuneType()

        local max = self:GetSpecialValueFor("max")
        local mp_damage = self:GetSpecialValueFor("mp_damage")*0.01
		local damage = ability:GetSpecialValueFor("basic_damage") + ability:GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue() + caster:GetMaxMana()*mp_damage
		self.damageTable = {
			attacker 		= caster,
			ability 		= ability,
			damage_type 	= ability:GetAbilityDamageType(),
			hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
		}

		if self.thundergod_spell_cast then
			ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
		end
		
		if self.type == 1 then
			self.rune_1_index = ability:GetSpecialValueFor("rune_1_index")*0.01
			self.strongest = FindStrongestEnemyInRangeAndPosition(caster,position,100000,DOTA_UNIT_TARGET_FLAG_NONE)
		elseif self.type == 3 then
			local rune_3_radius = self:GetSpecialValueFor("rune_3_radius")
			local rune_3_duration = self:GetSpecialValueFor("rune_3_duration")
			local rune_3_index = self:GetSpecialValueFor("rune_3_index") * 0.01
			local rune_3_cd = self:GetSpecialValueFor("rune_3_cd")

			local particle = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock1/effect_thunder.vpcf", PATTACH_WORLDORIGIN, caster)

			local pos = caster:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle, 0, Vector(pos.x, pos.y, pos.z+1500))
			ParticleManager:SetParticleControl(particle, 1, Vector(pos.x, pos.y, pos.z))
			ParticleManager:SetParticleControl(particle, 2, Vector(pos.x, pos.y, pos.z))
			ParticleManager:ReleaseParticleIndex(particle)
			caster:EmitSound("Hero_Zuus.GodsWrath.Target")

			-- 创建黯云雷涌区域
			CreateModifierThinker(
				caster,
				self,
				"modifier_chaotic_Thundergods_Wrath_area",
				{ 
					duration = rune_3_duration,
					radius = rune_3_radius,
					rune_3_damage = damage,
					rune_3_index = rune_3_index,
					rune_3_cd = rune_3_cd
				},
				position,
				caster:GetTeamNumber(),
				false
			)
			return
		end
		local rune_2_index = 1
		local nearby_enemy_units = FindUnitsInRadius(caster:GetTeamNumber(), position , nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #nearby_enemy_units ~= 0 then

			table.sort(nearby_enemy_units,function(a,b) return a:GetHealth()<b:GetHealth() end)

			for i, unit in ipairs(nearby_enemy_units) do
				if self.type == 2 then
					local captured_i = i
					caster:GameTimer(0.2*captured_i,function ()
                		self:Thunder(unit,damage,rune_2_index)
						if not unit:IsAlive() then
							local rune_2_bonus = ability:GetSpecialValueFor("rune_2_bonus")*0.01
							local rune_2_mp = ability:GetSpecialValueFor("rune_2_mp")*0.01
							rune_2_index = rune_2_index + rune_2_bonus
							caster:Script_ReduceMana(caster:GetMaxMana()*rune_2_mp, ability)
						end
					end)
				else
					self:Thunder(unit,damage,1)
					if not unit:IsAlive() then
						if self.type == 1 and self.strongest then
							self:Rune1(unit, self.strongest, damage*self.rune_1_index)
						end
					end
				end
				if i >= max then
					break
				end
			end
		end
	end
end

function chaotic_Thundergods_Wrath:Rune1(source,target,damage)
	if not target then return end
	if not source then return end
	local damage = damage or 0
    local info = {
        Target = target,
        -- Source = caster,
        Ability = self,	
        EffectName = "particles/rebuild/spell/static_field/gauss.vpcf",
        iMoveSpeed = 2000,
        -- iSourceAttach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
       
        bDrawsOnMinimap = false,
        bDodgeable = true,
        bIsAttack = false,
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 10,
        bProvidesVision = false,
        ExtraData = {damage = damage},	
    }
               
    local pos = source:GetAbsOrigin()
    local forward = source:GetForwardVector()
    pos = pos - forward*200
    pos.z = pos.z +100
    info.vSourceLoc = Vector(pos.x+RandomInt(-50,50),pos.y+RandomInt(-50,50),pos.z+RandomInt(0,100))
    ProjectileManager:CreateTrackingProjectile(info)
end

function chaotic_Thundergods_Wrath:OnProjectileHit_ExtraData(target, pos, keys)
	if not target then return end
	if not target:IsAlive() then return end
	if not self then return end
	target:EmitSound("ContinuumDevice.Activate")

	local caster = self:GetCaster()
	local pfx_aoe = ParticleManager:CreateParticle("particles/rebuild/spell/static_field_aoe/lighting_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_aoe, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_aoe, 2, Vector(300, 300, 300))
	ParticleManager:ReleaseParticleIndex(pfx_aoe)

	local damagetable = {
		attacker = caster,
		ability = self,
		damage = keys.damage,
		damage_type = self:GetAbilityDamageType(),
        hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	
	local pfx = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, target:GetAttachmentOrigin(target:ScriptLookupAttachment("attach_hitloc")))
	ParticleManager:ReleaseParticleIndex(pfx)
    damagetable.victim = target
    ApplyDamage(damagetable)
	target:EmitSound("Hero_Zuus.StaticField")
end

modifier_chaotic_Thundergods_Wrath_debuff = advanced_modifier({})

function modifier_chaotic_Thundergods_Wrath_debuff:IsDebuff() return true end
function modifier_chaotic_Thundergods_Wrath_debuff:IsHidden() return false end
function modifier_chaotic_Thundergods_Wrath_debuff:IsPurgable() 		return false end
function modifier_chaotic_Thundergods_Wrath_debuff:IsPurgeException() 	return false end
function modifier_chaotic_Thundergods_Wrath_debuff:CheckState()
    return{
        [MODIFIER_STATE_STUNNED] = true,
    }
end

modifier_chaotic_Thundergods_Wrath_area = advanced_modifier({})
function modifier_chaotic_Thundergods_Wrath_area:OnCreated(params)
    if IsServer() then
        self.radius = params.radius
        self.rune_3_index = params.rune_3_index
        self.rune_3_cd = params.rune_3_cd
        self.rune_3_damage = params.rune_3_damage
        
        local caster = self:GetParent()
		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/thundergods_wrath/unlock1/effect_chaotic.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle,1,Vector(self.radius,0,0))
		self:AddParticle( self.particle, false, false, -1, true, false )

		-- print("[Debug] 创建点位:", self:GetParent():GetAbsOrigin())
		-- print("[Debug] 特效名:", self.particle)
		-- DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255,0,0), 100, self.radius, true, 5)
		self:StartIntervalThink(self.rune_3_cd)
		self:OnIntervalThink()
    end
end

function modifier_chaotic_Thundergods_Wrath_area:OnIntervalThink()
    if not self:GetAbility() then self:Destroy() return end
	local parent = self:GetParent()
	local target = FindStrongestEnemyInRangeAndPosition( parent,parent:GetAbsOrigin(), self.radius,DOTA_UNIT_TARGET_FLAG_NONE)
    self:GetAbility():Thunder(target, self.rune_3_damage, self.rune_3_index)
end

function modifier_chaotic_Thundergods_Wrath_area:OnDestroy()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
	end
end
