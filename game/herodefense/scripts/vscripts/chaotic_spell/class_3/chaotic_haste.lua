
chaotic_haste = class({})
LinkLuaModifier("modifier_chaotic_haste", "chaotic_spell/class_3/chaotic_haste", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_haste_debuff", "chaotic_spell/class_3/chaotic_haste", LUA_MODIFIER_MOTION_NONE)



function chaotic_haste:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_haste/effect_cast/effect_end.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_haste/effect_cast/effect_end_dash.vpcf", context )

end


function chaotic_haste:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end


function chaotic_haste:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	EmitSoundOn("chaotic_haste_target", target)    
	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))
end

function chaotic_haste:ApplyModifier(target, duration)
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_haste/effect_cast/effect_end.vpcf"
	local caster = self:GetCaster()
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt( particle_cast_fx, 0, target, PATTACH_POINT_FOLLOW, "" , target:GetOrigin(), true )
	-- ParticleManager:SetParticleControl(particle_cast_fx, 2, target:GetAbsOrigin())
	DestroyParticleByDelay(particle_cast_fx,2.5)
	local gain = caster:GetModifierDurationGainIndex(1)
	target:RemoveModifierByName("modifier_chaotic_haste")
	target:AddNewModifier(caster, self, "modifier_chaotic_haste", {duration = duration*gain})

end


modifier_chaotic_haste = advanced_modifier({})

function modifier_chaotic_haste:IsHidden() return false end
function modifier_chaotic_haste:IsPurgable() return true end
function modifier_chaotic_haste:IsDebuff() return false end
function modifier_chaotic_haste:GetTexture() return self.texture end
function modifier_chaotic_haste:OnCreated(keys)
	-- 注意，没技能的情况下则是来源于药剂作用
	local ability = self:GetAbility()
	if  ability then
		local gain = ability:GetEffectGain()
		print("gain=",gain)
		self.bonus_move_speed = ability:GetSpecialValueFor("bonus_move_speed") * gain
		self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")* gain
		self.debuff_duration = ability:GetSpecialValueFor("debuff_duration")
		if IsServer() then
			self.distance = ability:GetSpecialValueFor("distance")
			self.cooldown =  ability:GetSpecialValueFor("cooldown")
			self.timer = GameRules:GetGameTime()
		else
			self.texture = ability:GetAbilityTextureName()
		end
		
	else
		-- 采用药剂kv
		self.potionBuff = true
		self.bonus_move_speed = GetPotionSpecial("hd_potion_speed_1","bonus_move_speed")
		self.bonus_attack_speed =GetPotionSpecial("hd_potion_speed_1","bonus_attack_speed")
		self.debuff_duration =GetPotionSpecial("hd_potion_speed_1","debuff_duration")
		if IsServer() then
			self.distance = GetPotionSpecial("hd_potion_speed_1","distance")
			self.cooldown = GetPotionSpecial("hd_potion_speed_1","cooldown")
			self.timer = GameRules:GetGameTime()
		end
		self.texture = GetPotionTexture("hd_potion_speed_1")
	end

end


function modifier_chaotic_haste:Advanced_GetModifierAttackSpeedPercentage()	
	return self.bonus_attack_speed
end


function modifier_chaotic_haste:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_EVENT_ON_ORDER = {self:GetParent(),nil},

    }
end
function modifier_chaotic_haste:DeclareFunctions()   
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	} 
end
function modifier_chaotic_haste:GetModifierMoveSpeedBonus_Percentage() 
    return self.bonus_move_speed
end



function modifier_chaotic_haste:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if IsValid(parent) and parent:IsAlive() then
			local ability = self:GetAbility()
			if ability or self.potionBuff then
				local particle_cast = "particles/rebuild/chaotic_spell/chaotic_haste/effect_cast/effect_disk_steam_end.vpcf"
				local caster = self:GetCaster()
				local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:SetParticleControl(particle_cast_fx, 3, parent:GetAbsOrigin())
				DestroyParticleByDelay(particle_cast_fx,2.5)
				if ability and ability:GetRuneType()==1 then
					return
				end
				local StatusResistance = parent:GetHDStatusResistanceIndex()
				parent:AddNewModifier(caster, ability, "modifier_chaotic_haste_debuff", {duration =self.debuff_duration*StatusResistance})
			end

		
		end
	end
end











modifier_chaotic_haste_debuff = advanced_modifier({})

function modifier_chaotic_haste_debuff:IsHidden() return false end
function modifier_chaotic_haste_debuff:IsPurgable() return true end
function modifier_chaotic_haste_debuff:IsDebuff() return true end
function modifier_chaotic_haste_debuff:GetTexture() return self.texture end
function modifier_chaotic_haste_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	if ability then
		if IsClient() then
			self.texture = ability:GetAbilityTextureName()
		end
	else
		self.texture = GetPotionTexture("hd_potion_speed_1")
	end
	
	
end
function modifier_chaotic_haste_debuff:DeclareFunctions()   
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	} 
end
function modifier_chaotic_haste_debuff:GetModifierMoveSpeedBonus_Percentage() 
    return -1000
end