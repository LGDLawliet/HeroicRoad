
LinkLuaModifier( "modifier_Chaotic_Offering_ambient", "skills/Middle_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_channeling", "skills/Middle_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Chaotic_Offering_move", "skills/Middle_Chaotic_Offering", LUA_MODIFIER_MOTION_NONE )
Middle_Chaotic_Offering = class({})
function Middle_Chaotic_Offering:GetAOERadius() return self:GetSpecialValueFor("radius") end
function Middle_Chaotic_Offering:IsRefreshable() return false end
function Middle_Chaotic_Offering:IsSummonSpell() return true end
function Middle_Chaotic_Offering:GetChannelTime() return self:GetSpecialValueFor("channel_time") end
function Middle_Chaotic_Offering:GetIntrinsicModifierName()
	return "modifier_Chaotic_Offering_move"
end
function Middle_Chaotic_Offering:OnChannelFinish()
	local ability = self
	local radius = self:GetSpecialValueFor("radius")
	local position = self.pos
	local caster = self:GetCaster()
	local channel_finish = caster:FindModifierByName("modifier_Chaotic_Offering_channeling")
	if not ability or ability:IsNull() then
		return
	end
	if channel_finish then
		self:EndCooldown()
		channel_finish:SafeDestroy()
		return
	end

	local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_finish.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_main_fx, 0, position)
	ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(particle_main_fx)

	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth() +1000
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false) +20
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax() +150

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	for i,unit in pairs(units) do
		unit:AddNewModifier( caster, self, "modifier_stunned", { duration = stun_duration} )
	end

	local unit = caster:SummonUnit("npc_hd_Golem",life_duration,
	position,
	self:GetCaster():GetForwardVector(),self,0,heal,0,damage,armor,1,1)
	unit:AddNewModifier( caster, self, "modifier_Chaotic_Offering_ambient", {})
end

function Middle_Chaotic_Offering:OnSpellStart()
	local caster =self:GetCaster()
	local position = self:GetCursorPosition()
	self.pos = position
	
	local particleID2 = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_wave.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(particleID2,0,position)
	caster:AddNewModifier( caster, self, "modifier_Chaotic_Offering_channeling", {duration = self:GetSpecialValueFor("channel_time")-0.1})
end


----------------------------------
modifier_Chaotic_Offering_ambient = class({})

function modifier_Chaotic_Offering_ambient:IsDebuff() return false end
function modifier_Chaotic_Offering_ambient:IsHidden() return true end
function modifier_Chaotic_Offering_ambient:IsPurgable() return false end
function modifier_Chaotic_Offering_ambient:OnCreated( kv )
	if IsServer() then	
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_offering/ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 10, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hand_r", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 11, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hand_l", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 12, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
	end
end
----------------------------------
modifier_Chaotic_Offering_channeling = advanced_modifier({})

function modifier_Chaotic_Offering_channeling:IsDebuff() return false end
function modifier_Chaotic_Offering_channeling:IsHidden() return true end
function modifier_Chaotic_Offering_channeling:IsPurgable() return false end
function modifier_Chaotic_Offering_channeling:OnCreated(keys)
	if IsServer() then
		self.pos = self:GetAbility():GetCursorPosition()
		self:StartIntervalThink(1)
	end
end
function modifier_Chaotic_Offering_channeling:OnIntervalThink()
	local position = self.pos
	local particleID2 = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_wave.vpcf",PATTACH_WORLDORIGIN,nil)
	ParticleManager:SetParticleControl(particleID2,0,position)
end

----------------------------------
modifier_Chaotic_Offering_move = advanced_modifier({})

function modifier_Chaotic_Offering_move:IsDebuff() return false end
function modifier_Chaotic_Offering_move:IsHidden() return false end
function modifier_Chaotic_Offering_move:IsPurgable() return false end

function modifier_Chaotic_Offering_move:Fireblast()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	self.middle_radius = self:GetAbility():GetSpecialValueFor("middle_radius")
	self.middle_damage = self:GetAbility():GetSpecialValueFor("middle_damage")
	--print("开始找")
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	--print("找单位中")
	for _,unit in pairs(units) do
		--print("找到了单位")
		local modifier = unit:FindModifierByNameAndCaster("modifier_Chaotic_Offering_ambient",caster)
		if modifier then
		--print("找到了地狱火")
		local particleID2 = ParticleManager:CreateParticle("particles/rebuild/spell/chaotic_offering/summon_wave.vpcf",PATTACH_WORLDORIGIN,nil)
		ParticleManager:SetParticleControl(particleID2,0,unit:GetAbsOrigin())
		
		local damage = unit:GetAverageTrueAttackDamage(nil)*self.middle_damage
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), unit:GetAbsOrigin(), nil, self.middle_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			if enemy ~= nil then
                local damageTable= {
                    victim = enemy,
                    attacker = unit,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags =DOTA_DAMAGE_FLAG_NONE, 
                    ability = self:GetAbility(),
                    hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
                }
	    	    enemy:ApplyMergeDamage(damageTable)
			end
		end
		end
	end
end