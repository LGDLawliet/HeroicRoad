heroTalent_npc_dota_hero_elder_titan_2 = heroTalent_npc_dota_hero_elder_titan_2 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_2", "heroTalent/heroTalent_npc_dota_hero_elder_titan_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff", "heroTalent/heroTalent_npc_dota_hero_elder_titan_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_elder_titan_2_buff", "heroTalent/heroTalent_npc_dota_hero_elder_titan_2", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_elder_titan_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_elder_titan_2"
end
function heroTalent_npc_dota_hero_elder_titan_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/elder_titan/elder_titan_2021/elder_titan_2021_earth_splitter.vpcf", context )
end


modifier_heroTalent_npc_dota_hero_elder_titan_2 = modifier_heroTalent_npc_dota_hero_elder_titan_2 or class({})

function modifier_heroTalent_npc_dota_hero_elder_titan_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_elder_titan_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_2:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_elder_titan_2:OnCreated()
	if IsServer() then
		self.center_pos = Vector(0,0,0)
		self:StartIntervalThink(0.1)
	end
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.time = self:GetAbility():GetSpecialValueFor("time")
	self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")
	self.fissure_range = self:GetAbility():GetSpecialValueFor("fissure_range")
	self.fissure_width = self:GetAbility():GetSpecialValueFor("fissure_width")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.fissure_increase = self:GetAbility():GetSpecialValueFor("fissure_increase")
end

function modifier_heroTalent_npc_dota_hero_elder_titan_2:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:GetAutoCastState() then
		self.center_pos = self:GetParent():GetOrigin()
	end
	local parent = self:GetParent()
	if not parent:IsAlive() or parent:IsSilenced() then
		return
	end
	if not Game_State:IsInBattle() then
		return
	end
	if ability:IsCooldownReady() then
		local cooldown = self.interval * parent:GetCooldownReduction()
		ability:StartCooldown(cooldown)
		self:SpellEffect()
	end
end



function modifier_heroTalent_npc_dota_hero_elder_titan_2:SpellEffect()
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local delay = self.time
	local width = self.fissure_width
	local length = self.fissure_range

	

	local start_pos = self.center_pos+Vector(RandomInt(-100, 100),RandomInt(-100, 100))
	start_pos = GetGroundPosition( start_pos, nil )
	local new_pos = start_pos+Vector(RandomInt(-100, 100),RandomInt(-100, 100))
	local new_pos = start_pos+TG_Direction(start_pos,new_pos)*length
	new_pos = GetGroundPosition( new_pos, nil )
	

	
	local damageTable = {
        attacker = caster,
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = ability,
		damage = self.damage + caster:GetMaxHealth()*self.bonus_damage*0.01,
    }

	local buff = caster:FindModifierByName("modifier_heroTalent_npc_dota_hero_elder_titan_2_buff")
	if buff then
		damageTable.damage = damageTable.damage *(1+ buff:GetStackCount()*self.fissure_increase*0.01)
	end

	local particle= ParticleManager:CreateParticle("particles/econ/items/elder_titan/elder_titan_2021/elder_titan_2021_earth_splitter.vpcf", PATTACH_WORLDORIGIN,nil)
    ParticleManager:SetParticleControl(particle, 0,start_pos)
    ParticleManager:SetParticleControl(particle, 1,new_pos)
	ParticleManager:SetParticleControl(particle, 2,Vector(width,width,width))
    ParticleManager:SetParticleControl(particle, 3,Vector(0,delay,0))
    ParticleManager:ReleaseParticleIndex( particle )
	EmitSoundOnLocationWithCaster( start_pos, "Hero_ElderTitan.EarthSplitter.Cast", caster )
	local gain = caster:GetModifierStatusNegativeGainIndex(1)
    Timers:CreateTimer(delay, function()
		EmitSoundOnLocationWithCaster( new_pos, "Hero_ElderTitan.EarthSplitter.Destroy", caster )

        local units = FindUnitsInLine(
            caster:GetTeam(),
            start_pos,
            new_pos,
            caster,
            width,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
            DOTA_UNIT_TARGET_FLAG_NONE)
        for i,unit in pairs(units) do
           
            damageTable.victim = unit
			ApplyDamage(damageTable)
			if not unit:IsAlive() then
				caster:AddNewModifier(caster,ability, "modifier_heroTalent_npc_dota_hero_elder_titan_2_buff", {})
			end
			unit:AddNewModifier(caster,ability, "modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff", {duration=self.slow_duration*unit:GetHDStatusResistanceIndex()*gain})
        end
        return nil
    end)

end


modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff = modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff or class({})

function modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff:IsDebuff()			return true end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff:IsPurgable() 			return true end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff:IsPurgeException() 	return true end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	} 
end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_debuff:GetModifierMoveSpeedBonus_Percentage() return -self:GetAbility():GetSpecialValueFor("slow") end





modifier_heroTalent_npc_dota_hero_elder_titan_2_buff = modifier_heroTalent_npc_dota_hero_elder_titan_2_buff or class({})

function modifier_heroTalent_npc_dota_hero_elder_titan_2_buff:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_buff:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_buff:IsPurgable() 			return false end
function modifier_heroTalent_npc_dota_hero_elder_titan_2_buff:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_elder_titan_2_buff:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_heroTalent_npc_dota_hero_elder_titan_2_buff:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


