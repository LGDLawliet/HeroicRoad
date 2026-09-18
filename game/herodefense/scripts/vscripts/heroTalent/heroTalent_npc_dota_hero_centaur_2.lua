heroTalent_npc_dota_hero_centaur_2 = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_centaur_2", "heroTalent/heroTalent_npc_dota_hero_centaur_2", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_heroTalent_npc_dota_hero_centaur_2_effect", "heroTalent/heroTalent_npc_dota_hero_centaur_2", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_centaur_2:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_centaur_2:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_centaur_2:IsStealable() 				return true end
function heroTalent_npc_dota_hero_centaur_2:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_centaur_2:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_centaur_2" end
function heroTalent_npc_dota_hero_centaur_2:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/centaur_2/effect_charge_active.vpcf", context )

end


function heroTalent_npc_dota_hero_centaur_2:Unlockachievement()
	-- print("oooooooooooook")
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_centaur_2:OnCustomDataSettlement()
	if self.customAchievement then
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			modifier:UnlockCustomData("24_hours_1")
		end
	end

end



modifier_heroTalent_npc_dota_hero_centaur_2 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_centaur_2:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_centaur_2:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_centaur_2:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_centaur_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_centaur_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_centaur_2:OnCreated(keys)
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/centaur_2/effect_charge_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(1,0,0))
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		self.reduce_step = 0.9
		if customDataManager:IsAchievementUnlockedWithUnit(self:GetCaster(),"24_hours_1") then
			self.reduce_step = 0.93
		end

		self.moveSpeedRecord = 0
		self:StartIntervalThink(0.2)
	end
end

function modifier_heroTalent_npc_dota_hero_centaur_2:OnWaveStart()
	self.moveSpeedRecord = self:GetModifierMoveSpeedBonus_Constant()
end


function modifier_heroTalent_npc_dota_hero_centaur_2:OnWaveEnd()
	if self.moveSpeedRecord>=3000 then
		self:GetAbility():Unlockachievement()
	end
end



function modifier_heroTalent_npc_dota_hero_centaur_2:OnIntervalThink()
	local parent = self:GetParent()

	self.moveSpeedRecord = math.min(self.moveSpeedRecord,self:GetModifierMoveSpeedBonus_Constant())
	

	if parent:PassivesDisabled() or not parent:IsAlive() or not parent:IsMoving() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
			ParticleManager:ReleaseParticleIndex(self.nFXIndex)
			self.nFXIndex = nil
		end
		self:SetStackCount(self:GetStackCount()*self.reduce_step)
		return
	else
		if not self.nFXIndex then
			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/talent/centaur_2/effect_charge_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
			ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(1,0,0))
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		end
	end


	self:SetStackCount(math.min((self:GetStackCount()+2)*1.02,100000))
	ParticleManager:SetParticleControl(self.nFXIndex, 60, Vector(math.min(self:GetStackCount()/10,200),0,0))

end


function modifier_heroTalent_npc_dota_hero_centaur_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end

function modifier_heroTalent_npc_dota_hero_centaur_2:GetModifierMoveSpeedBonus_Constant(keys)
   return self:GetParent():PassivesDisabled() and 0 or math.min(self:GetStackCount(),3000)
end


function modifier_heroTalent_npc_dota_hero_centaur_2:GetModifierIgnoreMovespeedLimit()          
	if self:GetStackCount()>=200 then
		return   1  
	end   
end

function modifier_heroTalent_npc_dota_hero_centaur_2:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_End = {},
        MODIFIER_EVENT_ON_Wave_Start = {},
    }
end