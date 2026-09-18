heroTalent_npc_dota_hero_storm_spirit_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_storm_spirit_3", "heroTalent/heroTalent_npc_dota_hero_storm_spirit_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect", "heroTalent/heroTalent_npc_dota_hero_storm_spirit_3", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus", "heroTalent/heroTalent_npc_dota_hero_storm_spirit_3", LUA_MODIFIER_MOTION_NONE )



function heroTalent_npc_dota_hero_storm_spirit_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/storm_spirit_4/effect_owner_body.vpcf", context )

end

function heroTalent_npc_dota_hero_storm_spirit_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_storm_spirit_3"
end

function heroTalent_npc_dota_hero_storm_spirit_3:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end


modifier_heroTalent_npc_dota_hero_storm_spirit_3 = class({})

function modifier_heroTalent_npc_dota_hero_storm_spirit_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_storm_spirit_3:IsAura()
	if not self:GetParent():IsRealHero() then
		return false
	end
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_heroTalent_npc_dota_hero_storm_spirit_3:GetModifierAura()	return "modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect" end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:GetAuraRadius()	return self.radius  end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end

function modifier_heroTalent_npc_dota_hero_storm_spirit_3:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end

function modifier_heroTalent_npc_dota_hero_storm_spirit_3:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return
		end
		local ability = self:GetAbility()
		self.radius = ability:GetSpecialValueFor("radius")

		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/storm_spirit_4/effect_owner_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetAbsOrigin(), true )
		-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
		ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(75,0,0) )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self:StartIntervalThink(0.5)




		local parent = self:GetParent()
		parent:SetOriginalModel("models/custom/panda/panda_red.vmdl")
		parent:UpdateOriginModel()
		local model = parent:FirstMoveChild()
		-- self.modelName = self.hero:GetModelName()
		local model_list = {}
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				-- print(model)
				-- PrintTable(model)
				-- print(model:GetModelName())
	
				table.insert(model_list,model)
				
			end
			model = model:NextMovePeer()
		end
		for _, model in ipairs(model_list) do
			UTIL_Remove(model)
		end	
	end

end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:OnRefresh(keys)
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

	end
end

function modifier_heroTalent_npc_dota_hero_storm_spirit_3:OnIntervalThink()
	if self:GetParent():PassivesDisabled()  or not self:GetParent():IsAlive() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/storm_spirit_4/effect_owner_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "", self:GetCaster():GetAbsOrigin(), true )
			-- ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(650,1,1) )
			ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(75,0,0) )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
		if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus") then
			ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(500,0,0) )
		else
			ParticleManager:SetParticleControl( self.nFXIndex, 60, Vector(75,0,0) )
		end
	end
end


function modifier_heroTalent_npc_dota_hero_storm_spirit_3:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
		return
	end

	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end
	if self:GetParent():PassivesDisabled() then
		return
	end

	local mana_cost = keys.ability:GetManaCost(-1) * self:GetAbility():GetSpecialValueFor("mana_damage_index")*0.01

	-- local ModifierStatusGain = keys.unit:GetModifierDurationGainIndex(1)
	keys.unit:EmitSound("Hero_Batrider.Flamebreak")
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	keys.unit:AddNewModifier(keys.unit,self:GetAbility(),"modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus",{duration = duration,stack_time = duration,stack=mana_cost})	

end





modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect = class({})
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect:IsPurgable()	return false end
-- function modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect:OnCreated()
	self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow")
	if IsServer() then
		self.damage_index =self:GetAbility():GetSpecialValueFor("damage_index") *0.01
 		self.damageTable = {
			victim = self:GetParent(),
			attacker =self:GetCaster(),
			-- damage = caster:GetStrength(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), 
		}
		self:StartIntervalThink(1)
	end
end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_effect:OnIntervalThink()
	local damage =  self:GetCaster():GetMana() * self.damage_index 
	-- self.damageTable.damage = self:GetCaster():GetAverageTrueAttackDamage(nil) * self.damage_index 
	local modifier = self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus")
	if modifier then
		damage = damage + modifier:GetStackCount()
	end
	self.damageTable.damage  = damage
	ApplyDamage(self.damageTable)
end




modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus = class({})
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus:IsPurgable()	return false end

function modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus:OnCreated(keys)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack= keys.stack})
		self:SetStackCount(keys.stack)
		self:StartIntervalThink(0.1)
		
		-- self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
		-- self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	end
end
function modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus:OnRefresh(keys)
	if IsServer() then
		-- local dieTime = self:GetDieTime()
		local dieTime = GameRules:GetGameTime()+keys.stack_time

		
		table.insert(self.tData, {dieTime = dieTime,stack= keys.stack })
		self:SetStackCount( self:GetStackCount()+ keys.stack)
	end
end

function modifier_heroTalent_npc_dota_hero_storm_spirit_3_bonus:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack)
				table.remove(self.tData, i)
				
			end
		end
	end
end



