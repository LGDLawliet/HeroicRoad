
LinkLuaModifier("modifier_Middle_gravity_thinker", "skills/Middle_gravity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_gravity_damage", "skills/Middle_gravity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_gravity_motion", "skills/Middle_gravity", LUA_MODIFIER_MOTION_NONE)
Middle_gravity = class ({})




function Middle_gravity:GetAOERadius()return self:GetSpecialValueFor("radius") end

function Middle_gravity:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local forward = 1
	if self:GetAutoCastState() then
		forward = -1
	end
	local thinker = CreateModifierThinker(caster, self, "modifier_Middle_gravity_thinker", {duration = duration,posx=point.x,posy=point.y,forward=forward}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
	thinker:AddNewModifier(caster, self, "modifier_Middle_gravity_damage", {duration =duration})

end

modifier_Middle_gravity_thinker = class({})

function modifier_Middle_gravity_thinker:IsDebuff()			return true end
function modifier_Middle_gravity_thinker:IsHidden() 			return true end
function modifier_Middle_gravity_thinker:IsPurgable() 		return true end
function modifier_Middle_gravity_thinker:IsPurgeException() 	return true end
function modifier_Middle_gravity_thinker:OnCreated(keys)
	if IsServer() then
		EmitSoundOn( "Hero_Enigma.Black_Hole", self:GetParent() )
		EmitSoundOn( "gravity.Black_Hole", self:GetParent() )
		
		self.caster = self:GetCaster()
		self.thinker = self:GetParent()
		self.ability = self:GetAbility()
		self.thinker_loc = self.thinker:GetAbsOrigin()
		self.target = Vector(keys.posx,keys.posy,1500)

		self.radius			= self.ability:GetSpecialValueFor("radius")
		self.forward = keys.forward

		self.particle = ParticleManager:CreateParticle("particles/rebuild/spell/gravity/gravity.vpcf", PATTACH_CUSTOMORIGIN, nil)
		self.pos = self:GetCaster():GetAbsOrigin()
		self.pos.z = self.pos.z +128
		self.dir = ( self.target-self.pos):Normalized()
		ParticleManager:SetParticleControl(self.particle, 0, self.pos)
		ParticleManager:SetParticleControl(self.particle, 4, self.pos)
		self:GetParent():SetAbsOrigin(self.pos)
		self:AddParticle(self.particle, false, false, 15, false, false)

		self:StartIntervalThink(FrameTime())
	end
end
function modifier_Middle_gravity_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	-- self.pos.z = self.pos.z +100*FrameTime()
	self.pos = self.pos +self.dir*100*FrameTime()
	ParticleManager:SetParticleControl(self.particle, 0, self.pos)
	ParticleManager:SetParticleControl(self.particle, 4, self.pos)
	self:GetParent():SetAbsOrigin(self.pos)
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"),
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local ability = self:GetAbility()
	for _, unit in pairs(enemies) do
		unit:AddNewModifier(self:GetParent(), ability, "modifier_Middle_gravity_motion", {duration = 0.6,forward = self.forward})
	end
end

function modifier_Middle_gravity_thinker:OnDestroy(keys)
	if IsServer() then
		-- local thinker = self:GetParent()
		self:GetParent():StopSound("Hero_Enigma.Black_Hole")
		self:GetParent():StopSound("gravity.Black_Hole")
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		if self:GetAbility() then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, nil)
			local pos = self:GetParent():GetAbsOrigin()
			pos.z = pos.z-64
			ParticleManager:SetParticleControl(pfx, 0, pos)
			ParticleManager:SetParticleControl(pfx, 60, Vector(70,70,70))
			ParticleManager:SetParticleControl(pfx, 1, Vector(700,700,700))
			ParticleManager:SetParticleControl(pfx, 3, pos)
			ParticleManager:SetParticleControl(pfx, 61, Vector(1,0,0))
			ParticleManager:ReleaseParticleIndex(pfx)
			local caster = self:GetCaster()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(),
			nil, 700,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE ,
				FIND_ANY_ORDER, false)
			local damageTable = {

				attacker = caster,
				damage = caster:GetIntellect(false)*self:GetAbility():GetSpecialValueFor("explosion_damage"),
				damage_type =  self:GetAbility():GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
				ability = self:GetAbility(), --Optional.
				}
			for _, enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage(damageTable)  

				
			end
			caster:EmitSound("Hero_Phoenix.SuperNova.Explode")
		end

		
		

		UTIL_Remove(self:GetParent())
		
	end
end










modifier_Middle_gravity_damage = class({})

function modifier_Middle_gravity_damage:IsDebuff()			return true end
function modifier_Middle_gravity_damage:IsHidden() 			return true end
function modifier_Middle_gravity_damage:IsPurgable() 		return true end
function modifier_Middle_gravity_damage:IsPurgeException() 	return true end
function modifier_Middle_gravity_damage:OnCreated(keys)
	if IsServer() then
		local ability = self:GetAbility()
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetIntellect(false)*ability:GetSpecialValueFor("bonus_damage")+ability:GetSpecialValueFor("damage"),
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}

		self:StartIntervalThink(1)
	end
end
function modifier_Middle_gravity_damage:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"),
	 DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	 for _, unit in pairs(enemies) do
		 self.damageTable.victim = unit
		 ApplyDamage(self.damageTable)
	 end
end












modifier_Middle_gravity_motion = class({})

function modifier_Middle_gravity_motion:IsDebuff()			return true end
function modifier_Middle_gravity_motion:IsHidden() 			return true end
function modifier_Middle_gravity_motion:IsPurgable() 		return false end
function modifier_Middle_gravity_motion:IsPurgeException() 	return false end
function modifier_Middle_gravity_motion:IsMotionController() return true end

function modifier_Middle_gravity_motion:OnCreated(keys)
	if IsServer() then
		self.forward = keys.forward
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/fall_2021/radiance_fall_2021.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )

	
		self:AddParticle( self.nFXIndex, false, false, -1, false, false )
		


		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Middle_gravity_motion:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetOrigin(), true)
	end
end




function modifier_Middle_gravity_motion:OnIntervalThink(keys)   
	if  IsServer() then
		if not self:GetCaster() or not self:GetAbility() then
			self:SafeDestroy()
			return
		end
		local direction = ((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
		direction.z = 0  --初始化Z值
		local me = self:GetParent()
		local dt = FrameTime()
		local new_pos = me:GetAbsOrigin() + direction * (200 / (1.0 / dt))  *self.forward
		new_pos = GetGroundPosition(new_pos, nil)   
		me:SetOrigin(new_pos)  
		ResolveNPCPositions(new_pos, 70)
    end
end