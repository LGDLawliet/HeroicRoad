
LinkLuaModifier( "modifier_Primary_summon_healing_ward_buff", "skills/Primary_summon_healing_ward", LUA_MODIFIER_MOTION_NONE )
 Primary_summon_healing_ward						=  Primary_summon_healing_ward or class({})
require("internal/timers")
function Primary_summon_healing_ward:IsSummonSpell()return true end

function  Primary_summon_healing_ward:OnSpellStart()
	if not IsServer() then
		return
	end
	local caster =self:GetCaster()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  100000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		if unit:FindModifierByNameAndCaster("modifier_Primary_summon_healing_ward_buff", caster) then
			TrueKill(caster,unit,self)
		end
	end

	--召唤强度
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = 0
	local damage = 0
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 
	EmitSoundOn("Hero_Juggernaut.HealingWard.Cast", caster)	

	local unit = caster:SummonUnit("npc_hd_healing_ward",life_duration,unit_pos,self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
	unit:AddNewModifier(caster, self, "modifier_Primary_summon_healing_ward_buff", {})
end

--------------------------------------------------------------

modifier_Primary_summon_healing_ward_buff = advanced_modifier({})

function modifier_Primary_summon_healing_ward_buff:IsDebuff()			return false end
function modifier_Primary_summon_healing_ward_buff:IsHidden() 		return true end
function modifier_Primary_summon_healing_ward_buff:IsPurgable() 		return false end
function modifier_Primary_summon_healing_ward_buff:IsPurgeException() return false end
function modifier_Primary_summon_healing_ward_buff:GetEffectName() return "particles/rebuild/spell/healing_ward/healing_ward.vpcf" end


function modifier_Primary_summon_healing_ward_buff:OnCreated(keys)
	if IsServer() then
        local caster = self:GetParent()
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		
        --self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/healing_ward/healing_ward.vpcf", PATTACH_ABSORIGIN_FOLLOW, nil )
        --ParticleManager:SetParticleShouldCheckFoW( self.nFXIndex,false )
        --ParticleManager:SetParticleControl( self.nFXIndex, 0, Vector(self.radius,self.radius,self.radius))
        --ParticleManager:SetParticleControl( self.nFXIndex, 1, caster:GetAbsOrigin())
		--ParticleManager:SetParticleControl( self.nFXIndex, 2, caster:GetAbsOrigin())
        --ParticleManager:SetParticleControl( self.nFXIndex, 3, caster:GetAbsOrigin())

		--ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(self.radius,self.radius,self.radius))
		--ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector(self.radius,self.radius,self.radius))
        --ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector(self.radius,self.radius,self.radius))
        --self:AddParticle( self.nFXIndex, false, false, 0, true, false )

		self:StartIntervalThink(self.interval)
	end
end

function modifier_Primary_summon_healing_ward_buff:OnIntervalThink()

	local ability = self:GetAbility()
	if not ability then
		return
	end
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local caster = self:GetCaster()
	for _, unit in pairs(enemies) do
		if unit ~= self:GetParent() then
			local heal = ability:GetSpecialValueFor("heal") + ability:GetSpecialValueFor("hp_heal")*0.01 * unit:GetMaxHealth()
			local healing = HealWithGain(heal,caster,unit,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, healing, nil)
		end
	end
end

function modifier_Primary_summon_healing_ward_buff:CheckState()
	return{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY  ] = true,
	}
end