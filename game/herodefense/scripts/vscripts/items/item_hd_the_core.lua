
--复制用
--   -item item_hd_the_first_core
--   -item item_hd_the_second_core
--   -item item_hd_the_third_core

require('internal/timers')   --计时器功能

LinkLuaModifier( "modifier_unlock_effect_1", "items/item_hd_the_core", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unlock_effect_2", "items/item_hd_the_core", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unlock_effect_3", "items/item_hd_the_core", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_unlock_effect_long1", "items/item_hd_the_core", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unlock_effect_long2", "items/item_hd_the_core", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unlock_effect_long3", "items/item_hd_the_core", LUA_MODIFIER_MOTION_NONE )
item_hd_the_first_core = class({})

function item_hd_the_first_core:CastFilterResult( vLoc )
	-- check nohammer
	if IsServer() then
		local playerHero = self:GetCaster()
		local maxAbilities = playerHero:GetAbilityCount() - 1
		self.playerAbilities = {}
		local i = 0
		for ability_id = 0, maxAbilities do
			local ability = playerHero:GetAbilityByIndex(ability_id)
			-- Make sure it is not a talent and there is level
			if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
			-- if ability and not ability:IsAttributeBonus() then
				local ability_level = ability.classlevel
	
				if ability_level then
					--高阶
					if ability_level==3 and ability:GetSpecialValueFor("advanced_level")>=25 and ability.UnlockFirstCore ~= nil and not ability.CoreUnlock then
						local abilityName = ability:GetAbilityName()
						table.insert(self.playerAbilities, abilityName)
						i = i + 1
					end
				end
				
			end
		end
		if i<=0 then
			return UF_FAIL_CUSTOM
		end
	

		return UF_SUCCESS
	end
	
end

function item_hd_the_first_core:GetCustomCastError( vLoc )
	-- check nohammer
	if IsServer() then

	
		return "#dota_hud_NoSpellCanBeUnlock"
	end

end
function item_hd_the_first_core:OnSpellStart()


	local playerHero = self:GetCaster()
	local nPlayerID = playerHero:GetPlayerID()

	if not self.playerAbilities then
		local maxAbilities = playerHero:GetAbilityCount() - 1
		self.playerAbilities = {}
		local i = 0
		for ability_id = 0, maxAbilities do
			local ability = playerHero:GetAbilityByIndex(ability_id)
			-- Make sure it is not a talent and there is level
			if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
			-- if ability and not ability:IsAttributeBonus() then
				local ability_level = ability.classlevel
	
				if ability_level then
					--高阶
					if ability_level==3 and ability:GetSpecialValueFor("advanced_level")>=25 and ability.UnlockFirstCore ~= nil and not ability.CoreUnlock then
						local abilityName = ability:GetAbilityName()
						table.insert(self.playerAbilities, abilityName)
						i = i + 1
					end
				end
				
			end
		end
		if i<=0 then
			return
		end
	end


	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "spells_menu_get_Mystery", { abilities = self.playerAbilities, class = 1 })
	self.playerAbilities = nil



-- self:SpendCharge(0)
end


function item_hd_the_first_core:Unlock()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/first_core/unlock.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(pos.x,pos.y,pos.z+4000))
	ParticleManager:ReleaseParticleIndex(particle_main_fx)
	caster:AddNewModifier(caster, nil, "modifier_unlock_effect_1", { duration =7} 	)
	caster:AddNewModifier(caster, nil, "modifier_unlock_effect_long1", {} 	)
	for i = 1, 15, 1 do

		Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			vDir.z = 0
			vDir = vDir:Normalized()
			local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
			local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/first_core/unlock.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
			ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(pos_0.x+RandomInt(-2000, 2000),pos_0.y+RandomInt(-2000, 2000),pos_0.z+4000))
			ParticleManager:ReleaseParticleIndex(particle_main_fx)
			caster:EmitSound("Hero_Enchantress.ImpetusDamage.Layer")
		end)

	end
	self:SpendCharge(0)
end







--------------------------------------------------------------------------------
modifier_unlock_effect_1 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unlock_effect_1:IsHidden()return true end
function modifier_unlock_effect_1:IsDebuff()return false end
function modifier_unlock_effect_1:IsStunDebuff()return false end
function modifier_unlock_effect_1:IsPurgable()return false end
function modifier_unlock_effect_1:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
function modifier_unlock_effect_1:IsPurgeException() 	return false end
function modifier_unlock_effect_1:RemoveOnDeath() return false end
function modifier_unlock_effect_1:GetEffectName() return "particles/rebuild/spell/last_hero/the_last_hero_ambient.vpcf" end
function modifier_unlock_effect_1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_unlock_effect_1:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	pos.z = pos.z +32
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/last_hero/last_hero_lighting.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 60, Vector(31,222,229))
	ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)

end

modifier_unlock_effect_long1 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unlock_effect_long1:IsHidden()return true end
function modifier_unlock_effect_long1:IsDebuff()return false end
function modifier_unlock_effect_long1:IsStunDebuff()return false end
function modifier_unlock_effect_long1:IsPurgable()return false end
function modifier_unlock_effect_long1:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
function modifier_unlock_effect_long1:IsPurgeException() 	return false end
function modifier_unlock_effect_long1:RemoveOnDeath() return false end
function modifier_unlock_effect_long1:GetAttributes() return  MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_unlock_effect_long1:OnCreated(keys)
	if IsServer() then

		if not IsInToolsMode() then
			self:StartIntervalThink(1.5)
		end
	end
end
function modifier_unlock_effect_long1:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	pos.z = pos.z +32
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/last_hero/last_hero_lighting.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 60, Vector(31,222,229))
	ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)

end



item_hd_the_second_core = class({})

function item_hd_the_second_core:CastFilterResult( vLoc )
	-- check nohammer
	if IsServer() then
		local playerHero = self:GetCaster()
		local maxAbilities = playerHero:GetAbilityCount() - 1
		self.playerAbilities = {}
		local i = 0
		for ability_id = 0, maxAbilities do
			local ability = playerHero:GetAbilityByIndex(ability_id)
			-- Make sure it is not a talent and there is level
			if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
			-- if ability and not ability:IsAttributeBonus() then
				local ability_level = ability.classlevel
	
				if ability_level then
					--高阶
					if ability_level==3 and ability:GetSpecialValueFor("advanced_level")>=25 and ability.UnlockSecondCore ~= nil and not ability.CoreUnlock then
						local abilityName = ability:GetAbilityName()
						table.insert(self.playerAbilities, abilityName)
						i = i + 1
					end
				end
				
			end
		end
		if i<=0 then
			return UF_FAIL_CUSTOM
		end
	

		return UF_SUCCESS
	end
	
end

function item_hd_the_second_core:GetCustomCastError( vLoc )
	-- check nohammer
	if IsServer() then

	
		return "#dota_hud_NoSpellCanBeUnlock"
	end

end
function item_hd_the_second_core:OnSpellStart()


	local playerHero = self:GetCaster()
	local nPlayerID = playerHero:GetPlayerID()

	if not self.playerAbilities then
		local maxAbilities = playerHero:GetAbilityCount() - 1
		self.playerAbilities = {}
		local i = 0
		for ability_id = 0, maxAbilities do
			local ability = playerHero:GetAbilityByIndex(ability_id)
			-- Make sure it is not a talent and there is level
			if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
			-- if ability and not ability:IsAttributeBonus() then
				local ability_level = ability.classlevel
	
				if ability_level then
					--高阶
					if ability_level==3 and ability:GetSpecialValueFor("advanced_level")>=25 and ability.UnlockSecondCore ~= nil and not ability.CoreUnlock then
						local abilityName = ability:GetAbilityName()
						table.insert(self.playerAbilities, abilityName)
						i = i + 1
					end
				end
				
			end
		end
		if i<=0 then
			return
		end
	end


	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "spells_menu_get_Mystery", { abilities = self.playerAbilities, class = 2 })
	self.playerAbilities = nil



-- self:SpendCharge(0)
end


function item_hd_the_second_core:Unlock()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	local particle_main_fx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti10_helmet/sven_ti10_helmet_gods_strength.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
	ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
	ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos, true)
	ParticleManager:ReleaseParticleIndex(particle_main_fx)
	caster:AddNewModifier(caster, nil, "modifier_unlock_effect_2", { duration =7} 	)
	caster:AddNewModifier(caster, nil, "modifier_unlock_effect_long2", {} 	)
	for i = 1, 10, 1 do

		Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			vDir.z = 0
			vDir = vDir:Normalized()
			local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
			local particle_main_fx = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti10_helmet/sven_ti10_helmet_gods_strength.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
			ParticleManager:SetParticleControlEnt(particle_main_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
			ParticleManager:SetParticleControlEnt(particle_main_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", pos_0, true)
			ParticleManager:ReleaseParticleIndex(particle_main_fx)
			caster:EmitSound("Hero_Sven.GodsStrength")
		end)

	end
	self:SpendCharge(0)
end
--------------------------------------------------------------------------------
modifier_unlock_effect_2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unlock_effect_2:IsHidden()return true end
function modifier_unlock_effect_2:IsDebuff()return false end
function modifier_unlock_effect_2:IsStunDebuff()return false end
function modifier_unlock_effect_2:IsPurgable()return false end
function modifier_unlock_effect_2:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
function modifier_unlock_effect_2:IsPurgeException() 	return false end
function modifier_unlock_effect_2:RemoveOnDeath() return false end
function modifier_unlock_effect_2:GetEffectName() return "particles/rebuild/spell/last_hero/the_last_hero_ambient.vpcf" end
function modifier_unlock_effect_2:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_unlock_effect_2:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	pos.z = pos.z +32
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/last_hero/last_hero_lighting.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:ReleaseParticleIndex(pfx)

end




modifier_unlock_effect_long2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unlock_effect_long2:IsHidden()return true end
function modifier_unlock_effect_long2:IsDebuff()return false end
function modifier_unlock_effect_long2:IsStunDebuff()return false end
function modifier_unlock_effect_long2:IsPurgable()return false end
function modifier_unlock_effect_long2:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
function modifier_unlock_effect_long2:IsPurgeException() 	return false end
function modifier_unlock_effect_long2:RemoveOnDeath() return false end
function modifier_unlock_effect_long2:GetAttributes() return  MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_unlock_effect_long2:OnCreated(keys)
	if IsServer() then
		if not IsInToolsMode() then
			self:StartIntervalThink(1.5)
		end
	end
end
function modifier_unlock_effect_long2:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	pos.z = pos.z +32
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/last_hero/last_hero_lighting.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:ReleaseParticleIndex(pfx)

end






item_hd_the_third_core = class({})

function item_hd_the_third_core:CastFilterResult( vLoc )
	-- check nohammer
	if IsServer() then
		local playerHero = self:GetCaster()
		local maxAbilities = playerHero:GetAbilityCount() - 1
		self.playerAbilities = {}
		local i = 0
		for ability_id = 0, maxAbilities do
			local ability = playerHero:GetAbilityByIndex(ability_id)
			-- Make sure it is not a talent and there is level
			if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
			-- if ability and not ability:IsAttributeBonus() then
				local ability_level = ability.classlevel
	
				if ability_level then
					--高阶
					if ability_level==3 and ability:GetSpecialValueFor("advanced_level")>=25 and ability.UnlockThirdCore ~= nil and not ability.CoreUnlock then
						local abilityName = ability:GetAbilityName()
						table.insert(self.playerAbilities, abilityName)
						i = i + 1
					end
				end
				
			end
		end
		if i<=0 then
			return UF_FAIL_CUSTOM
		end
	

		return UF_SUCCESS
	end
	
end

function item_hd_the_third_core:GetCustomCastError( vLoc )
	-- check nohammer
	if IsServer() then

	
		return "#dota_hud_NoSpellCanBeUnlock"
	end

end
function item_hd_the_third_core:OnSpellStart()


	local playerHero = self:GetCaster()
	local nPlayerID = playerHero:GetPlayerID()

	if not self.playerAbilities then
		local maxAbilities = playerHero:GetAbilityCount() - 1
		self.playerAbilities = {}
		local i = 0
		for ability_id = 0, maxAbilities do
			local ability = playerHero:GetAbilityByIndex(ability_id)
			-- Make sure it is not a talent and there is level
			if ability and not ability:IsAttributeBonus() and not ability:IsHidden() then
			-- if ability and not ability:IsAttributeBonus() then
				local ability_level = ability.classlevel
	
				if ability_level then
					--高阶
					if ability_level==3 and ability:GetSpecialValueFor("advanced_level")>=25 and ability.UnlockThirdCore ~= nil and not ability.CoreUnlock then
						local abilityName = ability:GetAbilityName()
						table.insert(self.playerAbilities, abilityName)
						i = i + 1
					end
				end
				
			end
		end
		if i<=0 then
			return
		end
	end


	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(nPlayerID), "spells_menu_get_Mystery", { abilities = self.playerAbilities, class = 3 })
	self.playerAbilities = nil



-- self:SpendCharge(0)
end


function item_hd_the_third_core:Unlock()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/unlockcore/unlock_3.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_main_fx, 0, pos)
	ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(500,0,0))
	ParticleManager:SetParticleControl(particle_main_fx, 10, Vector(3,0,0))
	ParticleManager:SetParticleControl(particle_main_fx,60, Vector(165,0,255))
	ParticleManager:SetParticleControl(particle_main_fx,61, Vector(1,0,0))
	-- ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(pos.x,pos.y,pos.z+4000))
	ParticleManager:ReleaseParticleIndex(particle_main_fx)
	caster:AddNewModifier(caster, nil, "modifier_unlock_effect_3", { duration =7} 	)
	caster:AddNewModifier(caster, nil, "modifier_unlock_effect_long3", {} 	)
	for i = 1, 5, 1 do

		Timers:CreateTimer(RandomFloat(0.1, 0.5), function()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			vDir.z = 0
			vDir = vDir:Normalized()
			local pos_0 = caster:GetAbsOrigin() +Vector(RandomInt(-200, 200),RandomInt(-200, 200),0)
			local particle_main_fx = ParticleManager:CreateParticle("particles/rebuild/spell/unlockcore/unlock_3.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_main_fx, 0, pos_0)
			ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(500,0,0))
			ParticleManager:SetParticleControl(particle_main_fx, 10, Vector(3,0,0))
			ParticleManager:SetParticleControl(particle_main_fx,60, Vector(165,0,255))
			ParticleManager:SetParticleControl(particle_main_fx,61, Vector(1,0,0))
			-- ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(pos_0.x+RandomInt(-2000, 2000),pos_0.y+RandomInt(-2000, 2000),pos_0.z+4000))
			ParticleManager:ReleaseParticleIndex(particle_main_fx)
			caster:EmitSound("Hero_EarthShaker.EchoSlam.Arcana")
		end)

	end
	self:SpendCharge(0)
end







--------------------------------------------------------------------------------
modifier_unlock_effect_3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unlock_effect_3:IsHidden()return true end
function modifier_unlock_effect_3:IsDebuff()return false end
function modifier_unlock_effect_3:IsStunDebuff()return false end
function modifier_unlock_effect_3:IsPurgable()return false end
function modifier_unlock_effect_3:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
function modifier_unlock_effect_3:IsPurgeException() 	return false end
function modifier_unlock_effect_3:RemoveOnDeath() return false end
function modifier_unlock_effect_3:GetEffectName() return "particles/rebuild/spell/last_hero/the_last_hero_ambient.vpcf" end
function modifier_unlock_effect_3:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_unlock_effect_3:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	pos.z = pos.z +32
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/last_hero/last_hero_lighting.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 60, Vector(170,0,255))
	ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)

end









modifier_unlock_effect_long3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unlock_effect_long3:IsHidden()return true end
function modifier_unlock_effect_long3:IsDebuff()return false end
function modifier_unlock_effect_long3:IsStunDebuff()return false end
function modifier_unlock_effect_long3:IsPurgable()return false end
function modifier_unlock_effect_long3:GetTexture() return "sven/sven_ti10_immortal_ability_icon/sven_ti10_immortal_gods_strength" end
function modifier_unlock_effect_long3:IsPurgeException() 	return false end
function modifier_unlock_effect_long3:RemoveOnDeath() return false end
function modifier_unlock_effect_long3:GetAttributes() return  MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_unlock_effect_long3:OnCreated(keys)
	if IsServer() then
		if not IsInToolsMode() then
			self:StartIntervalThink(1.5)
		end
	end
end
function modifier_unlock_effect_long3:OnIntervalThink()
	local caster = self:GetParent()
	local pos = caster:GetAbsOrigin()
	pos.z = pos.z +32
	local pfx = ParticleManager:CreateParticle("particles/rebuild/spell/last_hero/last_hero_lighting.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, pos)
	ParticleManager:SetParticleControl(pfx, 60, Vector(170,0,255))
	ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)

end
