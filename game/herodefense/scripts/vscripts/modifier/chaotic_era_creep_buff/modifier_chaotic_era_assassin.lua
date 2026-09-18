
modifier_chaotic_era_assassin = advanced_modifier({})

function modifier_chaotic_era_assassin:IsHidden()return false end
function modifier_chaotic_era_assassin:IsDebuff()return false end
function modifier_chaotic_era_assassin:IsPurgable()return false end
function modifier_chaotic_era_assassin:IsPurgeException() 	return false end
function modifier_chaotic_era_assassin:RemoveOnDeath() return true end
function modifier_chaotic_era_assassin:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_assassin:GetTexture() return self.texture end
-- function modifier_chaotic_era_assassin:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", context )
-- end
function modifier_chaotic_era_assassin:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus = GetChaticEraCreep_BuffSpecial(self,"value1")
	self.trigger = true
    if IsServer() then
		self.heroes = GetAllRealHeroes()
		self.heroes = randomTable(self.heroes)
		self:StartIntervalThink(0.3)
    end
end

function modifier_chaotic_era_assassin:OnIntervalThink()
	local parent = self:GetParent()
	if not parent or parent:IsNull() or not parent:IsAlive() then return end
	local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.bonus, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if #units>=1 then
		self.trigger = false
		self:StartIntervalThink(3)
	else
		self.trigger = true
		self:StartIntervalThink(0.3)
	end
	local heroes = GetAllRealHeroes()
	for index, unit in ipairs(self.heroes) do
		if unit and not unit:IsNull() and unit:IsAlive() and not unit:IsInvulnerable() and not unit:IsInvisible()  then
			parent:MoveToPositionAggressive(unit:GetAbsOrigin())
		end
	end

end


function modifier_chaotic_era_assassin:GetModifierInvisibilityLevel()	
	if not self.trigger then
		return 0
	end
	return 2 
end


function modifier_chaotic_era_assassin:CheckState()
	if not self.trigger then
		return
	end
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		-- [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
	return state
end



-- function modifier_chaotic_era_assassin:PlayEffect(parent)
--     parent:EmitSound("hd_potion_arcane_boost_active")

--     local particle_cast_fx = ParticleManager:CreateParticle("particles/rebuild/potion/hd_potion_arcane_boost/effect_active/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
-- 	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, parent:GetAbsOrigin())
-- 	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" , parent:GetOrigin(), true )
-- 	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, parent:GetAbsOrigin())
-- 	DestroyParticleByDelay(particle_cast_fx,2.5)
-- end





function modifier_chaotic_era_assassin:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end

function modifier_chaotic_era_assassin:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus
	end
end

