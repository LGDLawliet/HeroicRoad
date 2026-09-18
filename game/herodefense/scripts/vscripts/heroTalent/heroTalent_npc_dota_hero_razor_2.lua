heroTalent_npc_dota_hero_razor_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_buff", "heroTalent/heroTalent_npc_dota_hero_razor_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_debuff", "heroTalent/heroTalent_npc_dota_hero_razor_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_razor_link", "heroTalent/heroTalent_npc_dota_hero_razor_2", LUA_MODIFIER_MOTION_NONE )



function heroTalent_npc_dota_hero_razor_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/razor/razor_punctured_crest/razor_static_link_blade.vpcf", context )

end
function heroTalent_npc_dota_hero_razor_2:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
		0,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	return UF_SUCCESS
end

function heroTalent_npc_dota_hero_razor_2:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end



function heroTalent_npc_dota_hero_razor_2:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	caster:EmitSound("Ability.static.start")
	target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_razor_link", {duration =10})

end
function heroTalent_npc_dota_hero_razor_2:Unlockachievement()
	self.customAchievement = true
end
function heroTalent_npc_dota_hero_razor_2:OnCustomDataSettlement()
	if self.customAchievement then
		-- print("条件满足")
		local caster = self:GetCaster()
		local modifier = caster:FindModifierByName("modifier_hero_custom_data_manager")
		if modifier then
			-- modifier:razorTalent2()
			modifier:UnlockCustomData("electrostatic_extractor_1")
		end
	end

end


modifier_heroTalent_npc_dota_hero_razor_link = class({})

function modifier_heroTalent_npc_dota_hero_razor_link:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_razor_link:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_razor_link:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_razor_link:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_razor_link:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_razor_link:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_razor_link:OnCreated(keys)
	if IsServer() then
		self.buff_duration = 25
		if customDataManager:IsAchievementUnlocked(tostring(PlayerResource:GetSteamID( self:GetCaster():GetPlayerOwnerID())),"electrostatic_extractor_1") then
			self.buff_duration = self.buff_duration + 4
		end
		self:StartIntervalThink(0.3)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/razor/razor_punctured_crest/razor_static_link_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_whip1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
		
		self.thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_generic_soundPlayer", {duration = 10,attach_caster = 1}, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false)
		self.thinker:EmitSound("Ability.static.loop")
	end
end
function modifier_heroTalent_npc_dota_hero_razor_link:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local damage_stack = 0
	if parent:IsRealHero() then
		damage_stack = parent:GetAverageTrueAttackDamage(nil)*0.02
	else
		damage_stack = parent:GetAverageTrueAttackDamage(nil)*0.01
	end
	damage_stack = math.floor(damage_stack)
	if damage_stack<=0 then
		self:SafeDestroy()
		return
	end
	if not caster:IsAlive() then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	if not self.modifier_buff or self.modifier_buff:IsNull() then
		self.modifier_buff = caster:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_razor_buff", {duration = self.buff_duration,damage_stack = damage_stack})
	else
		local keys = {
			damage_stack = damage_stack
		}
		self.modifier_buff:SetDuration(25, true)
		self.modifier_buff:OnRefresh(keys)
	end
	if not self.modifier_debuff or self.modifier_debuff:IsNull() then
		self.modifier_debuff =parent:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_razor_debuff", {duration = self.buff_duration,damage_stack = damage_stack})
	else
		local keys = {
			damage_stack = damage_stack
		}
		self.modifier_debuff:SetDuration(self.buff_duration, true)
		self.modifier_debuff:OnRefresh(keys)
	end
	



end


function modifier_heroTalent_npc_dota_hero_razor_link:OnDestroy()

	if IsServer() then

		
		self:GetCaster():EmitSound("Ability.static.end")
		ParticleManager:DestroyParticle(self.nFXIndex,false)
		-- StopSoundEvent( "Ability.static.loop", self:GetCaster())
		if not self.thinker:IsNull() then
			self.thinker:StopSound("Ability.static.loop")
			self.thinker:FindModifierByName("modifier_generic_soundPlayer"):SafeDestroy()
		end
	end
end




modifier_heroTalent_npc_dota_hero_razor_debuff = class({})

function modifier_heroTalent_npc_dota_hero_razor_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_razor_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_razor_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_razor_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_razor_debuff:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_razor_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_razor_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.damage_stack)
	end
end
function modifier_heroTalent_npc_dota_hero_razor_debuff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.damage_stack)
	end
end



function modifier_heroTalent_npc_dota_hero_razor_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
	}
end


function modifier_heroTalent_npc_dota_hero_razor_debuff:GetModifierPreAttack_BonusDamage()	return -self:GetStackCount() end



modifier_heroTalent_npc_dota_hero_razor_buff = class({})

function modifier_heroTalent_npc_dota_hero_razor_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_razor_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_razor_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_razor_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_razor_buff:RemoveOnDeath() return true end
function modifier_heroTalent_npc_dota_hero_razor_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_heroTalent_npc_dota_hero_razor_buff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.damage_stack)
	end
end
function modifier_heroTalent_npc_dota_hero_razor_buff:OnRefresh(keys)
	if IsServer() then
		
		self:SetStackCount(math.min(self:GetStackCount()+ keys.damage_stack,8000) )
	end
end

function modifier_heroTalent_npc_dota_hero_razor_buff:OnDestroy()

	if IsServer() then
		if self:GetStackCount()>=3500 then
			self:GetAbility():Unlockachievement()
		end
	end
end




function modifier_heroTalent_npc_dota_hero_razor_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,           --攻击力
	}
end


function modifier_heroTalent_npc_dota_hero_razor_buff:GetModifierPreAttack_BonusDamage()	return self:GetStackCount() end