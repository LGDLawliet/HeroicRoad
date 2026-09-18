--战意
Advanced_Warpath = class({})


LinkLuaModifier("modifier_Advanced_Warpath_passive", "skills/Advanced_Warpath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Warpath", "skills/Advanced_Warpath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Warpath_buff", "skills/Advanced_Warpath", LUA_MODIFIER_MOTION_NONE) --魔免


LinkLuaModifier("modifier_Advanced_Warpath_unlock1", "skills/Advanced_Warpath", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Warpath_unlock3", "skills/Advanced_Warpath", LUA_MODIFIER_MOTION_NONE)
function Advanced_Warpath:CheckKV(key)
	local table = {
		damage_per_stack=0.5,
		move_speed_per_stack=0.05,
		armor_per_stack=0.03,


	}
	local value = table[key] or -1
	return value

end



function Advanced_Warpath:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_Warpath:UnlockSecondCore(key)
	-- 
	local caster = self:GetCaster()

	if not caster:HasAbility("heroTalent_npc_dota_hero_bristleback") then
		self.CoreUnlock = false
		self.unlock2 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock2",{})

	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Warpath:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf", context )

end

function Advanced_Warpath:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Warpath_unlock3",{})
	return true

end
function Advanced_Warpath:Spawn()
	self.unlock3_gain = 1
end
function Advanced_Warpath:AddGain()
	self.unlock3_gain = math.min(self.unlock3_gain+0.02,10)
	local caster = self:GetCaster()
	caster:EmitSound("Hero_Axe.Berserkers_Call")
	local pfx_name = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_mouth")))
	ParticleManager:SetParticleControl(pfx, 2, Vector(100, 100, 100))
	ParticleManager:ReleaseParticleIndex(pfx)
end

function Advanced_Warpath:GetGain()
	return self.unlock3_gain
end

function Advanced_Warpath:GetIntrinsicModifierName() return "modifier_Advanced_Warpath_passive" end
function Advanced_Warpath:IsHiddenWhenStolen() 		return false end
function Advanced_Warpath:IsRefreshable() 			return true  end
function Advanced_Warpath:IsStealable() 			return true  end
function Advanced_Warpath:IsNetherWardStealable()	return true end
function Advanced_Warpath:AddStack(unit)
	local ModifierStatusGain = unit:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration_warpath")*ModifierStatusGain
	--LV5解锁恋战+
	if self.advanced_level>=5 then
		duration = duration *2
	end
	if self.unlock1 then		
		unit:AddNewModifier(unit,self,"modifier_Advanced_Warpath_unlock1",{duration = 10*ModifierStatusGain})	
	end
	local warpath_Modifier = unit:AddNewModifier(unit,self,"modifier_Advanced_Warpath",{duration = duration})	
	if self.unlock2 then
		local modifier = unit:FindModifierByName("modifier_Advanced_Bristle_Back_passive")
		
		if modifier and warpath_Modifier then
			local gain = 1 + warpath_Modifier:GetStackCount()*0.03
			modifier:start(gain,unit,true)
		end
		-- :start(gain,unit)
	end

end


modifier_Advanced_Warpath= advanced_modifier({})

function modifier_Advanced_Warpath:IsDebuff()			return false end
function modifier_Advanced_Warpath:IsHidden() 			return false end
function modifier_Advanced_Warpath:IsPurgable() 		return false end
function modifier_Advanced_Warpath:IsPurgeException() 	return false end
function modifier_Advanced_Warpath:DeclareFunctions() return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end
function modifier_Advanced_Warpath:GetModifierMoveSpeedBonus_Percentage() return self.ms*self:GetStackCount() * self:GetAbility():GetGain() end
function modifier_Advanced_Warpath:Advanced_GetModifierPhysicalArmorBonus() return self.armor*self:GetStackCount() * self:GetAbility():GetGain() end
function modifier_Advanced_Warpath:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()*self.att * self:GetAbility():GetGain()
end
function modifier_Advanced_Warpath:GetModifierModelScale() 
    return 2*self:GetStackCount()
end
function modifier_Advanced_Warpath:OnCreated()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.att = self:GetAbility():GetSpecialValueFor("damage_per_stack") 
	self.ms = self:GetAbility():GetSpecialValueFor("move_speed_per_stack")
	self.armor = self:GetAbility():GetSpecialValueFor("armor_per_stack")
	if IsServer() then
		self:SetStackCount(0)
		self:OnRefresh()
		self.unlock3_target_table = {}
	end
end
function modifier_Advanced_Warpath:OnRefresh()
	local ability = self:GetAbility()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.att = ability:GetSpecialValueFor("damage_per_stack") 
	self.ms = ability:GetSpecialValueFor("move_speed_per_stack")
	self.armor = ability:GetSpecialValueFor("armor_per_stack")
	if IsServer() then
		if ability.unlock1 then
			self:SetStackCount( ability:GetSpecialValueFor("max_stacks") ) 
		else
			self:SetStackCount( math.min( self:GetStackCount() + 1, ability:GetSpecialValueFor("max_stacks")) ) 
		end
		

		local need_stack = ability:GetSpecialValueFor("max_stacks")
		--LV10解锁怒发冲冠+
		if self.advanced_level>=10 then
			need_stack = need_stack /2
		end
		if self:GetStackCount()>=need_stack then
			self.God_power = true
		end

		--LV20解锁怒发冲冠+
		if self.advanced_level>=20 and  self:GetStackCount()>=ability:GetSpecialValueFor("max_stacks") then
			self:StartIntervalThink(0.3)
		end
	end
end

function modifier_Advanced_Warpath:OnIntervalThink()
	if IsServer() then
		local ability =self:GetAbility()
		
		if ability:IsCooldownReady() then
			local caster = self:GetCaster()
			caster:AddNewModifier(caster,ability,"modifier_Advanced_Warpath_buff",{duration = 5})	
			ability:StartCooldown(20)
		end
	end
end


function modifier_Advanced_Warpath:OnAttackLanded(keys)

	if not IsServer() or keys.attacker ~= self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	if self:GetParent():PassivesDisabled() and not ability.unlock1 then
		return
	end
	if self.advanced_level>=15 and self:GetCaster():GetRandomEffect(10,INT_TYPE,1) >=RandomInt(1, 100) then
		ability:AddStack(self:GetCaster())
	else
		local duration = ability:GetSpecialValueFor("duration_warpath")
		--LV5解锁恋战+
		if self.advanced_level>=5 then
			duration = duration *2
		end
		self:SetDuration(duration,true)
		-- self:GetAbility():AddStack(self:GetCaster())
	end
	
end

function modifier_Advanced_Warpath:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		if not self.God_power  then
			return
		end
		if Attacker:GetHealthPercent()>=100 then
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * 0.05*gain
		if flLifesteal<=0 then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		local ability = self:GetAbility()
		Attacker:Heal( flLifesteal,ability )



	end

	return 0.0

end
function modifier_Advanced_Warpath:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_Wave_End = {},
    }
end




function modifier_Advanced_Warpath:OnWaveEnd()
    if IsServer() then
		self:Destroy()
	end
end







modifier_Advanced_Warpath_passive = class({})

function modifier_Advanced_Warpath_passive:IsDebuff()			return false end
function modifier_Advanced_Warpath_passive:IsHidden() 			return true end
function modifier_Advanced_Warpath_passive:IsPurgable() 		return false end
function modifier_Advanced_Warpath_passive:IsPurgeException() 	return false end
function modifier_Advanced_Warpath_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_Advanced_Warpath_passive:OnAbilityFullyCast(keys)
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
	local ability = self:GetAbility()
	if self:GetParent():PassivesDisabled() and not ability.unlock1 then
		return
	end
	ability:AddStack(keys.unit)

end


modifier_Advanced_Warpath_buff = class({})

-----------------------------------------------------------------------------------------
function modifier_Advanced_Warpath_buff:IsDebuff() return false end
function modifier_Advanced_Warpath_buff:IsHidden() return false end
function modifier_Advanced_Warpath_buff:IsPurgable()
	return false
end
function modifier_Advanced_Warpath_buff:GetEffectName()	return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_Advanced_Warpath_buff:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Warpath_buff:CheckState()
	local state = {}

	if IsServer()  then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
	end

	return state
end





modifier_Advanced_Warpath_unlock1 = advanced_modifier({})

function modifier_Advanced_Warpath_unlock1:IsHidden()	return false end
function modifier_Advanced_Warpath_unlock1:IsDebuff()	return false end
function modifier_Advanced_Warpath_unlock1:IsPurgable()	return false end
function modifier_Advanced_Warpath_unlock1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_Advanced_Warpath_unlock1:GetModifierBonusStats_Agility()	return self:GetStackCount() end






function modifier_Advanced_Warpath_unlock1:OnCreated(params)
	self.ability = self:GetAbility()
	self.att = self.ability:GetSpecialValueFor("damage_per_stack") 
		self.ms = self.ability:GetSpecialValueFor("move_speed_per_stack")
		self.armor = self.ability:GetSpecialValueFor("armor_per_stack")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:IncrementStackCount()
		self:StartIntervalThink(0.1)
		
		
	
	end
end
function modifier_Advanced_Warpath_unlock1:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Warpath_unlock1:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end

		local ability = self:GetAbility()

		self.God_power = false
		local need_stack = ability:GetSpecialValueFor("max_stacks")/2
		if self:GetStackCount()>=need_stack then
			self.God_power = true
		end
		-- if self:GetStackCount()>=ability:GetSpecialValueFor("max_stacks") then
		-- 	if ability:IsCooldownReady() then
		-- 		local caster = self:GetCaster()
		-- 		caster:AddNewModifier(caster,ability,"modifier_Advanced_Warpath_buff",{duration = 5})	
		-- 		ability:StartCooldown(20)
		-- 	end
		-- end

	end
end


function modifier_Advanced_Warpath_unlock1:DeclareFunctions() return 
	{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_EVENT_ON_TAKEDAMAGE,} end
function modifier_Advanced_Warpath_unlock1:GetModifierMoveSpeedBonus_Percentage() return self.ms*self:GetStackCount() end
function modifier_Advanced_Warpath_unlock1:Advanced_GetModifierPhysicalArmorBonus() return self.armor*self:GetStackCount() end
function modifier_Advanced_Warpath_unlock1:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()*self.att
end
function modifier_Advanced_Warpath_unlock1:GetModifierModelScale() 
    return 2*self:GetStackCount()
end

function modifier_Advanced_Warpath_unlock1:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		if not self.God_power  then
			return
		end
		if Attacker:GetHealthPercent()>=100 then
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal = flDamage * 0.05*gain
		if flLifesteal<=0 then
			return
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		Attacker:Heal( flLifesteal, self:GetAbility() )

	end

	return 0.0

end




function modifier_Advanced_Warpath_unlock1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

modifier_Advanced_Warpath_unlock3= class({})

function modifier_Advanced_Warpath_unlock3:IsDebuff()			return false end
function modifier_Advanced_Warpath_unlock3:IsHidden() 			return false end
function modifier_Advanced_Warpath_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Warpath_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Warpath_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Warpath_unlock3:DeclareFunctions() return 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	} 
end

function modifier_Advanced_Warpath_unlock3:OnCreated()
	if IsServer() then
		self.unlock3_target_table = {}
		self:StartIntervalThink(2)
		self:SetStackCount(self:GetAbility().unlock3_gain*100)
	end
end


function modifier_Advanced_Warpath_unlock3:OnIntervalThink()
	if IsServer() then

		for key, value in pairs(self.unlock3_target_table) do
			if not key or key:IsNull() or not key:IsAlive() then
				self.unlock3_target_table[key] = nil
			end
		end
	end
end


function modifier_Advanced_Warpath_unlock3:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end


		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if self:GetParent():PassivesDisabled() then
			return
		end
	
		local ability = self:GetAbility()
	

		if params.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK  then
			return
		end
		if Target.warpath_unlock3 then
			return
		end
		if not self.unlock3_target_table[Target] then
			self.unlock3_target_table[Target] = {
				count = 0,
				damage = 0,
			}
		end
		self.unlock3_target_table[Target].count = self.unlock3_target_table[Target].count + 1
		self.unlock3_target_table[Target].damage = self.unlock3_target_table[Target].damage + flDamage
		if self.unlock3_target_table[Target].count>=6 then
			if self.unlock3_target_table[Target].damage<=Target:GetMaxHealth()*0.05  then
				ability:AddGain()
				self:SetStackCount(ability.unlock3_gain*100)
			end
			self.unlock3_target_table[Target] = nil
			Target.warpath_unlock3 = true

		end


	end

	return 0.0

end