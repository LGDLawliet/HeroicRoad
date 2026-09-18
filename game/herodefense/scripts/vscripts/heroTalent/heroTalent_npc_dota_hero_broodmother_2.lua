heroTalent_npc_dota_hero_broodmother_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_broodmother_2", "heroTalent/heroTalent_npc_dota_hero_broodmother_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_broodmother_2_effect", "heroTalent/heroTalent_npc_dota_hero_broodmother_2", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_broodmother_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_broodmother_2"
end

function heroTalent_npc_dota_hero_broodmother_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/broodmother_2/effect.vpcf", context )

end

function heroTalent_npc_dota_hero_broodmother_2:Spawn()
	self.enable_state = true
	self.min_speed = 0
	self.achievement_count = 0
end
function heroTalent_npc_dota_hero_broodmother_2:SetMinMoveSpeed(value)
	self.min_speed = math.max(value,1)
end
function heroTalent_npc_dota_hero_broodmother_2:GetMinMoveSpeed()
	return self.min_speed
end
function heroTalent_npc_dota_hero_broodmother_2:SetState(state)
	self.enable_state = state
end
function heroTalent_npc_dota_hero_broodmother_2:IsWorking()
	return self.enable_state
end

function heroTalent_npc_dota_hero_broodmother_2:AddCount()
    self.achievement_count =  self.achievement_count+  1
end



function heroTalent_npc_dota_hero_broodmother_2:OnCustomDataSettlement()
	-- if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomDataWithValue("flame_resistance_1",self.achievement_count)
		end
	-- end

end










modifier_heroTalent_npc_dota_hero_broodmother_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_broodmother_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_broodmother_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_broodmother_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_broodmother_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_broodmother_2:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_broodmother_2:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end

function modifier_heroTalent_npc_dota_hero_broodmother_2:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		self.count = 0
		self:StartIntervalThink(1)
		self:PlayEffect()
		-- ability:SetState(true)
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"flame_resistance_1") then
			self.flame_resistance_1 = true
		end
	end
end
function modifier_heroTalent_npc_dota_hero_broodmother_2:PlayEffect()
	-- self:AttachEffect(nfx)
	if self.effect then
		return
	end
	self.effect = {}
	local parent = self:GetParent()
	for i = 0, 6, 1 do
		for j = 0, 6, 1 do
			local pos = GetGroundPosition( Vector(-5000+i*1500,5000-j*1500,0), parent ) + Vector(0,0,128)
			local nfx = ParticleManager:CreateParticle("particles/rebuild/talent/broodmother_2/effect.vpcf", PATTACH_POINT,parent)
			ParticleManager:SetParticleControl(nfx, 0, pos)
			ParticleManager:SetParticleControl(nfx, 1, Vector(1500, 1500, 1500))
			ParticleManager:SetParticleControlEnt(nfx,2,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			ParticleManager:SetParticleControlEnt(nfx,3,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,10,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,11,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,12,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,13,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,14,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,15,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,16,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			-- ParticleManager:SetParticleControlEnt(nfx,17,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true )
			table.insert(self.effect,nfx)
			self:AddParticle( nfx, false, false, -1, true, false )
		end
		
	end

end
function modifier_heroTalent_npc_dota_hero_broodmother_2:RemoveEffect()
	if self.effect then
		for _, nfx in ipairs(self.effect) do
			ParticleManager:DestroyParticle(nfx, false)
			ParticleManager:ReleaseParticleIndex(nfx)
		end
		self.effect = nil
	end

end
function modifier_heroTalent_npc_dota_hero_broodmother_2:OnWaveStart()
	self.startState = self:GetAbility():IsWorking()
end
function modifier_heroTalent_npc_dota_hero_broodmother_2:OnWaveEnd()
	if self.startState and self:GetAbility():IsWorking() then
		self:GetAbility():AddCount()
	end
end
function modifier_heroTalent_npc_dota_hero_broodmother_2:OnIntervalThink()
	if not self:GetParent():IsAlive() then
		return
	end
	local parent = self:GetParent()
	local speed = self:GetParent():GetMoveSpeedModifier(parent:GetBaseMoveSpeed(),false)
	local ability = self:GetAbility()
	ability:SetMinMoveSpeed(speed)
	
	if self.flame_resistance_1 then
		return
	end

	self.count = self.count + 1
	if self.count>=5 then
		self.count = 0
		local count = 0
		local heroes = GetAllRealHeroes()
		for  _, hero in pairs(heroes) do
			for i=0, hero:GetAbilityCount() - 1 do
				local Ability = hero:GetAbilityByIndex(i)
				if Ability ~= nil  then
					if Ability:IsFireSpell() then
						count = count + 1
					end
				end
			end
		end
		if count>=3 then
			self:RemoveEffect()
			ability:SetState(false)
		else
			self:PlayEffect()
			ability:SetState(true)
		end
	end

	
end


function modifier_heroTalent_npc_dota_hero_broodmother_2:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		unit:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_broodmother_2_effect", {})

	end
end


function modifier_heroTalent_npc_dota_hero_broodmother_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only,
		MODIFIER_EVENT_ON_Wave_End = {},
        MODIFIER_EVENT_ON_Wave_Start = {},

    }
end

function modifier_heroTalent_npc_dota_hero_broodmother_2:Advanced_GetModifier_FlyingPathing()	
	if self:GetAbility():IsWorking() then
		return 1
	end
	return 0
end






modifier_heroTalent_npc_dota_hero_broodmother_2_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:IsPurgable() 		return false end
function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:IsPurgeException() 	return false end

function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:DeclareFunctions() 
	return {

	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,


}
end


function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1)

	end
end

function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:GetModifierMoveSpeed_AbsoluteMin(keys)
	if IsServer() then
		if self:GetAbility():IsWorking() then
			return self:GetAbility():GetMinMoveSpeed()
		end
	end
end


function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:ADDeclareFunctions()
    return 
    {
        -- advanced_MODIFIER_PROPERTY_Flying,
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_heroTalent_npc_dota_hero_broodmother_2_effect:Advanced_GetModifier_FlyingPathing()	
	if self:GetAbility():IsWorking() then
		return 1
	end
	return 0
end


-- Advanced_GetModifier_FlyingPathing



