
chaotic_war_qi_link = class({})
LinkLuaModifier("modifier_chaotic_war_qi_link", "chaotic_spell/class_9/chaotic_war_qi_link", LUA_MODIFIER_MOTION_NONE)



function chaotic_war_qi_link:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_war_qi_link/effect_target/effect_cast_enemy.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", context )

end

function chaotic_war_qi_link:CastFilterResultTarget( hTarget )
	if self:GetCaster()==hTarget then
		self.error = "DOTA_HUB_CANT_CAST_TO_TARGET"
		return UF_FAIL_CUSTOM
	end
	if not hTarget.GetIntellect then
		return
	end
	if hTarget:GetIntellect(false)>=self:GetCaster():GetIntellect(false) then
		self.error = "DOTA_HUB_CANT_CAST_TO_TARGET"
		return UF_FAIL_CUSTOM
	end

	local result = self.BaseClass.CastFilterResultTarget(self,hTarget)
	return result or UF_SUCCESS
end

function chaotic_war_qi_link:GetCustomCastErrorTarget( hTarget )
	return self.error
end



function chaotic_war_qi_link:Spawn()
	if IsServer() then
		self.singleCastList = {}
		self.attack_damage = 0
	end
end


function chaotic_war_qi_link:OnSpellStart()

	if not IsServer() then
		return
	end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	self:CheckSingleCasting()

	self.attack_damage = caster:GetAverageTrueAttackDamage(nil)

	self:ApplyModifier(caster, self:GetSpecialValueFor("duration"))
	self:ApplyModifier(target, self:GetSpecialValueFor("duration"))

	local sound_cast = "Brewmaster_Storm.WindWalk"   
	EmitSoundOn(sound_cast, caster)    
	
end

function chaotic_war_qi_link:ApplyModifier(target, duration)

	local caster = self:GetCaster()

	target:RemoveModifierByName("modifier_chaotic_war_qi_link")

	local gain = caster:GetModifierDurationGainIndex(1)

	local modifier = target:AddNewModifier(caster, self, "modifier_chaotic_war_qi_link", {duration = duration*gain})

	if modifier then
		table.insert(self.singleCastList,modifier)
	end

end

function chaotic_war_qi_link:CheckSingleCasting()
	local i = 0 
	local count = self:GetSpecialValueFor("single_count")-1
    while #self.singleCastList > count and #self.singleCastList>=1 do
		if IsValid(self.singleCastList[1]) then
			self.singleCastList[1]:Destroy()
		end
        table.remove(self.singleCastList, 1)
		-- 防止疏忽
		i = i +1
		if i>=50 then
			break
		end
    end
end

modifier_chaotic_war_qi_link = advanced_modifier({})

function modifier_chaotic_war_qi_link:IsHidden() return false end
function modifier_chaotic_war_qi_link:IsPurgable() return true end
function modifier_chaotic_war_qi_link:IsDebuff() return false end

function modifier_chaotic_war_qi_link:OnCreated(keys)
	if IsServer() then

		self.caster = self:GetCaster()

		self.parent = self:GetParent()

		self.ability = self:GetAbility()

		self.distance = self.ability:GetSpecialValueFor("distance") + 30

		local caster_attack_damage = self.ability.attack_damage

		self.attack_damage = - ( caster_attack_damage * ( self.ability:GetSpecialValueFor("shared_attack_power") * 0.01 ) )

		if self.caster ~= self.parent then

			self.attack_damage = -self.attack_damage

			local eff_link = "particles/rebuild/chaotic_spell/chaotic_war_qi_link/effect_3pnt.vpcf"

			local particle_link = ParticleManager:CreateParticle(eff_link, PATTACH_ABSORIGIN_FOLLOW,self.caster)
			ParticleManager:SetParticleControlEnt(particle_link, 0, self.caster, PATTACH_POINT_FOLLOW, nil, self.caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_link, 1, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
			self:AddParticle(particle_link, false, false, -1, false, false)

		end

		self.caster:GameTimer(0.5,function()

			if IsValid(self) then

				local eff = "particles/rebuild/chaotic_spell/chaotic_war_qi_link/effect_target.vpcf"

				local pos = self.parent:GetAbsOrigin()
	
				local particle = ParticleManager:CreateParticle(eff, PATTACH_ABSORIGIN_FOLLOW,self.parent)
				ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, nil, Vector(pos.x,pos.y,pos.z + 150), true)
				self:AddParticle(particle, false, false, -1, false, false)		

				local sound_cast = "Hero_Omniknight.HammerOfPurity.Crit"    
				EmitSoundOn(sound_cast, self.parent)    

			end

		end)  

		self:SetHasCustomTransmitterData( true )

		self:StartIntervalThink(0.5)
	end

end

function modifier_chaotic_war_qi_link:OnRefresh(keys)

	if IsServer() then

		self.caster = self:GetCaster()

		self.parent = self:GetParent()

		self.ability = self:GetAbility()

		self.distance = self.ability:GetSpecialValueFor("distance")

		local caster_attack_damage = self.ability.attack_damage

		self.attack_damage = - (caster_attack_damage * ( self.ability:GetSpecialValueFor("shared_attack_power") * 0.01 ) )

		if self.caster ~= self.parent then

			self.attack_damage = -self.attack_damage

			local eff_link = "particles/rebuild/chaotic_spell/chaotic_war_qi_link/effect_3pnt.vpcf"

			local particle_link = ParticleManager:CreateParticle(eff_link, PATTACH_ABSORIGIN_FOLLOW,self.caster)
			ParticleManager:SetParticleControlEnt(particle_link, 0, self.caster, PATTACH_POINT_FOLLOW, nil, self.caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_link, 1, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
			self:AddParticle(particle_link, false, false, -1, false, false)

		end

		self.caster:GameTimer(0.5,function()

			if IsValid(self) then

				local eff = "particles/rebuild/chaotic_spell/chaotic_war_qi_link/effect_target.vpcf"

				local pos = self.parent:GetAbsOrigin()
	
				local particle = ParticleManager:CreateParticle(eff, PATTACH_ABSORIGIN_FOLLOW,self.parent)
				ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, nil, Vector(pos.x,pos.y,pos.z + 150), true)
				self:AddParticle(particle, false, false, -1, false, false)		

				local sound_cast = "Hero_Omniknight.HammerOfPurity.Crit"    
				EmitSoundOn(sound_cast, self.parent)    

			end

		end)

		self:SetHasCustomTransmitterData( true )

		self:StartIntervalThink(0.5)

	end

end

function modifier_chaotic_war_qi_link:OnDestroy()

	if not IsServer() then
		return
	end

	local modifier = self.caster:FindModifierByName("modifier_chaotic_war_qi_link")

	if modifier then

		modifier:Destroy()

	end

end

function modifier_chaotic_war_qi_link:OnIntervalThink()

	if not IsServer() then
		return
	end

	local distance = CalculateDistance(self.parent,self.caster)

	if distance >= self.distance then

		local modifier = self.caster:FindModifierByName("modifier_chaotic_war_qi_link")

		if modifier then

			modifier:Destroy()

		end

		self:Destroy()

	end

end

function modifier_chaotic_war_qi_link:AddCustomTransmitterData( )
	return
	{
		attack_damage = self.attack_damage,
	}
end

function modifier_chaotic_war_qi_link:HandleCustomTransmitterData( data )
	self.attack_damage = data.attack_damage
end

function modifier_chaotic_war_qi_link:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_war_qi_link:OnTooltip() return self:Advanced_GetModifierPreAttack_BonusDamage() end

function modifier_chaotic_war_qi_link:ADDeclareFunctions()
    
    return {advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
    
end

function modifier_chaotic_war_qi_link:Advanced_GetModifierPreAttack_BonusDamage(keys)

	return self.attack_damage

end
