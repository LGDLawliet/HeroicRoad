heroTalent_npc_dota_hero_earthshaker = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earthshaker", "heroTalent/heroTalent_npc_dota_hero_earthshaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_earthshaker_buff", "heroTalent/heroTalent_npc_dota_hero_earthshaker", LUA_MODIFIER_MOTION_NONE )

function heroTalent_npc_dota_hero_earthshaker:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_earthshaker"
end



modifier_heroTalent_npc_dota_hero_earthshaker = class({})

function modifier_heroTalent_npc_dota_hero_earthshaker:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_earthshaker:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_earthshaker:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_earthshaker:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,

	}

	return funcs
end
function modifier_heroTalent_npc_dota_hero_earthshaker:OnAbilityFullyCast( params )
	if IsServer() then
		if params.ability:IsItem() then return end
		local cooldown = params.ability:GetCooldown(params.ability:GetLevel())
		if cooldown <= 1 then
			return
		end
		-- local ability = self:GetAbility()
		if self:GetParent():PassivesDisabled() then
			return
		end
		if not self:GetParent():IsRealHero() then
			return false
		end
		if params.unit:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			-- local dis = CalculateDistance(params.unit,self:GetParent())
			-- if dis>1000 then
			-- 	return
			-- end
			local gain = self:GetParent():GetModifierDurationGainIndex(1)
			self:PlayEffects(self:GetParent())
			self:GetParent():AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_heroTalent_npc_dota_hero_earthshaker_buff",
				{	duration = 30*gain})
	
		end
		
	end
end


function modifier_heroTalent_npc_dota_hero_earthshaker:PlayEffects( target )
	local particle_cast = "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(300,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_Earthshaker.Arcana.ComboCounter")
end







modifier_heroTalent_npc_dota_hero_earthshaker_buff = class({})

function modifier_heroTalent_npc_dota_hero_earthshaker_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_earthshaker_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_earthshaker_buff:GetModifierBonusStats_Strength()	return self.str *self:GetStackCount() end

function modifier_heroTalent_npc_dota_hero_earthshaker_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		self.str = self.ability:GetSpecialValueFor("str_bonus")
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_earthshaker_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>= (10+_G.GAME_ROUND*4) then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })

		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:IncrementStackCount()
		end
	end
end

function modifier_heroTalent_npc_dota_hero_earthshaker_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end



