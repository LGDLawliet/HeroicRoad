
LinkLuaModifier("modifier_wind_element_death", "skills/Primary_summon_wind_element", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_summon_wind_element_buff", "skills/Primary_summon_wind_element", LUA_MODIFIER_MOTION_NONE)


Primary_summon_wind_element	= Primary_summon_wind_element or class({})
require("internal/timers")
function Primary_summon_wind_element:IsSummonSpell()return true end
function Primary_summon_wind_element:IsElementSummon()return true end

function Primary_summon_wind_element:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", context )
	-- PrecacheResource( "particle", "particles/rebuild/spell/dark_rift/little_demon/status_effect.vpcf", context )

end
function Primary_summon_wind_element:OnSpellStart()

	local caster =self:GetCaster()
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = self:GetSpecialValueFor("bonus_health")*0.01 * caster:GetMaxHealth()
	local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)+self:GetSpecialValueFor("basic_armor")
	local damage = self:GetSpecialValueFor("bonus_damage")*0.01 * caster:GetBaseDamageMax()--召唤兽攻击力
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 

	local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_storm_spirit_4")
	if ability then
		if ability:IsCooldownReady() then
			local cooldown = self:GetCooldownTimeRemaining()
			self:EndCooldown()
			ability:StartCooldown(ability:GetSpecialValueFor("CD_index")*cooldown)
		end
		damage = damage + (ability:GetSpecialValueFor("bonus_damage")*0.01)*caster:GetAverageTrueAttackDamage(nil)
	end
	EmitSoundOn("Hero_Windrunner.GaleForce", caster)	
	local pfx_name = "particles/rebuild/spell/summon_wind_element/effect.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, unit_pos)
	DestroyParticleByDelay(pfx,3)
	

	local unit = caster:SummonUnit("npc_hd_wind_element",life_duration,
	unit_pos,
	self:GetCaster():GetForwardVector(),self,0,heal,nil,damage,armor,1,1)
	unit:AddNewModifier(caster, self, "modifier_wind_element_death", {})
	unit:AddNewModifier(caster, self, "modifier_Primary_summon_wind_element_buff", {})

end



modifier_wind_element_death = modifier_wind_element_death or class({})

function modifier_wind_element_death:IsDebuff()			return false end
function modifier_wind_element_death:IsHidden() 			return true end
function modifier_wind_element_death:IsPurgable() 		return false end
function modifier_wind_element_death:IsPurgeException() 	return false  end
function modifier_wind_element_death:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_storm_death.vpcf", context )
end

function modifier_wind_element_death:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_storm_death.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin())
		ParticleManager:SetParticleControlForward(effect_cast, 0, parent:GetForwardVector()) 
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex( effect_cast )
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

modifier_Primary_summon_wind_element_buff = modifier_Primary_summon_wind_element_buff or advanced_modifier({})

function modifier_Primary_summon_wind_element_buff:IsDebuff()			return false end
function modifier_Primary_summon_wind_element_buff:IsHidden() 			return true end
function modifier_Primary_summon_wind_element_buff:IsPurgable() 		return false end
function modifier_Primary_summon_wind_element_buff:IsPurgeException() 	return false  end

function modifier_Primary_summon_wind_element_buff:Advanced_GetModifierIncomingDamage_Percentage( params )
	local avoid_chance = self:GetAbility():GetSpecialValueFor("avoid_chance")
	if not IsServer() then
		return
	end
	if avoid_chance >= RandomInt(1, 100) then
		self:SpellToTarget()
		return -100
	end

end




function modifier_Primary_summon_wind_element_buff:SpellToTarget()
	if IsServer() then
		local parent = self:GetParent()
        local particle = ParticleManager:CreateParticle("particles/rebuild/spell/summon_wind_element/trigger_effect.vpcf", PATTACH_POINT_FOLLOW, parent)
        -- ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
        DestroyParticleByDelay(particle,1)
    
	end

end


function modifier_Primary_summon_wind_element_buff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
-------------------------------------
