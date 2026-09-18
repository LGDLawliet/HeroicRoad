
modifier_chaotic_era_lava_attack = advanced_modifier({})

function modifier_chaotic_era_lava_attack:IsHidden()return false end
function modifier_chaotic_era_lava_attack:IsDebuff()return false end
function modifier_chaotic_era_lava_attack:IsPurgable()return false end
function modifier_chaotic_era_lava_attack:IsPurgeException() 	return false end
function modifier_chaotic_era_lava_attack:RemoveOnDeath() return true end
function modifier_chaotic_era_lava_attack:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_lava_attack:GetTexture() return self.texture end
function modifier_chaotic_era_lava_attack:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_era_lava_attack/effect_main/effect.vpcf", context )
end
function modifier_chaotic_era_lava_attack:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus1 = GetChaticEraCreep_BuffSpecial(self,"value1")
	self.bonus2 = GetChaticEraCreep_BuffSpecial(self,"value2")
    if IsServer() then
		-- self:SetStackCount(GetChaticEraCreep_BuffSpecial(self,"value1"))
    end
end



function modifier_chaotic_era_lava_attack:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(), nil},
	}

	return funcs
end

function modifier_chaotic_era_lava_attack:OnAttackLanded(keys)
	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end


	if keys.target:IsMagicImmune() then
		return
	end
	if keys.damage<=0 then
		return
	end
	

	--禁用溅射
	if keys.attacker:IsDisableCleave() then
		return
	end
	local enemies = FindUnitsInRadius(keys.attacker:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self.bonus1, DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	table.remove(enemies,1)  --移除目标
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/spell/chaotic_era_lava_attack/effect_main/effect.vpcf", PATTACH_CUSTOMORIGIN, keys.target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, keys.target, PATTACH_POINT_FOLLOW, "" ,Vector(0,0,0), true )
	DestroyParticleByDelay(effect_cast1,3)


	local damage =  keys.damage*self.bonus2*0.01
	local damageTable = {
	attacker = keys.attacker,
	damage = damage,
	damage_type = DAMAGE_TYPE_PHYSICAL,
	damage_flags =  DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
	hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
	-- ability = nil, --Optional.
	}
	for _, enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)	
	end
	

end


function modifier_chaotic_era_lava_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_lava_attack:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self.bonus1
	elseif self._tooltip == 2 then
		return  self.bonus2
	end
end

