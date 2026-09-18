LinkLuaModifier("modifier_chaotic_reverse_gravity_thinker", "chaotic_spell/class_7/chaotic_reverse_gravity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_reverse_gravity_buff", "chaotic_spell/class_7/chaotic_reverse_gravity", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_chaotic_reverse_gravity_refresh_buff", "chaotic_spell/class_7/chaotic_reverse_gravity", LUA_MODIFIER_MOTION_NONE)





chaotic_reverse_gravity = class({})






function chaotic_reverse_gravity:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_reverse_gravity/effect_main/warp.vpcf", context )


	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", context )



	
end
function chaotic_reverse_gravity:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function chaotic_reverse_gravity:OnSpellStart()
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	-- local pos = caster:GetOrigin()+Vector(0,0,64)
	-- local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_reverse_gravity/cast_effect/effect_th_cast.vpcf", PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	-- DestroyParticleByDelay(effect_cast1,5)


	CreateModifierThinker(caster, self, "modifier_chaotic_reverse_gravity_thinker", {duration = self:GetSpecialValueFor("duration")}, pos, caster:GetTeamNumber(), false)




	
end





modifier_chaotic_reverse_gravity_thinker = advanced_modifier({})

function modifier_chaotic_reverse_gravity_thinker:IsAura()return true end
function modifier_chaotic_reverse_gravity_thinker:OnCreated(keys)
	if IsServer() then
		self.rune_type = self:GetAbility():GetRuneType()

		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		local parent = self:GetParent()
		parent:EmitSound("chaotic_reverse_gravity_cast")

		self.particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_reverse_gravity/effect_main/warp.vpcf", PATTACH_POINT_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt( self.particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
		ParticleManager:SetParticleControl( self.particle, 1,Vector(self.radius,self.radius,self.radius) )
		self:AddParticle(self.particle, false, false, -1, false, false)
		-- DestroyParticleByDelay(particle,13)
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_reverse_gravity_thinker:OnDestroy(keys)
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle,false)
		UTIL_Remove(self:GetParent())
	end
end
function modifier_chaotic_reverse_gravity_thinker:OnIntervalThink()
	if not self:GetAbility() then
		self:Destroy()
	end
end


function modifier_chaotic_reverse_gravity_thinker:GetAuraRadius()return self.radius end
function modifier_chaotic_reverse_gravity_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_chaotic_reverse_gravity_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_chaotic_reverse_gravity_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_chaotic_reverse_gravity_thinker:GetAuraDuration() return 0.05 end
function modifier_chaotic_reverse_gravity_thinker:GetModifierAura()return "modifier_chaotic_reverse_gravity_buff" end
function modifier_chaotic_reverse_gravity_thinker:GetAuraEntityReject(hEntity)
	if self.rune_type==1 then
		return false
	end
	if hEntity:IsGiant() then
		return true
	end
	return false
end






modifier_chaotic_reverse_gravity_buff = advanced_modifier({})

function modifier_chaotic_reverse_gravity_buff:IsHidden() 			return false end
function modifier_chaotic_reverse_gravity_buff:IsPurgable() 			return false end
function modifier_chaotic_reverse_gravity_buff:IsPurgeException() 	return false end
function modifier_chaotic_reverse_gravity_buff:IsDebuff() return self.debuff end

function modifier_chaotic_reverse_gravity_buff:OnCreated(keys)
	self.height_add_rate = self:GetAbility():GetSpecialValueFor("height_add_rate")
	self.bonus_move_speed= -self:GetAbility():GetSpecialValueFor("move_slow")
	self.timer = GameRules:GetGameTime()
	self.height = 0
	
	if IsServer() then
		self.height_min_require = self:GetAbility():GetSpecialValueFor("height_min_require")
		self.damage_per_100_height = self:GetAbility():GetSpecialValueFor("damage_per_100_height")
		self:SetHasCustomTransmitterData( true )
		if self:GetAbility():GetRuneType()==1 and not self:GetParent():IsGiant() then
			self.height_add_rate = self.height_add_rate * (1+0.01*self:GetAbility():GetSpecialValueFor("rune_1_bonus"))
			
		end
		self:SetStackCount(self.height_add_rate)


		
		
	end
end




function modifier_chaotic_reverse_gravity_buff:OnDestroy()
	if IsServer() then

		self.height = math.min((GameRules:GetGameTime()-self.timer)*self.height_add_rate,3000)
		if self.debuff and self.height>=self.height_min_require then
			local caster = self:GetCaster()
			local damage = self.height/100* self.damage_per_100_height *caster:HDGetPrimaryStatValue()
			local ability = self:GetAbility()
			local parent = self:GetParent()
			local damageTable = {
				victim = parent,
				attacker = caster,
				damage = damage,
				damage_type = ability:GetAbilityDamageType(),
				ability = ability, --Optional.
			}
			self:PlayEffect()
			parent:AddNewModifier(caster, ability, "modifier_chaotic_reverse_gravity_refresh_buff", {duration =0.1})
			self:GetParent():GameTimer(0.1, function()
				if IsValid(parent) and parent:IsAlive() then
					ApplyDamage(damageTable)
				end
			end)
			
		end
	end
end









function modifier_chaotic_reverse_gravity_buff:PlayEffect()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", PATTACH_CUSTOMORIGIN,self:GetParent() )
	
		
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(100,100,0))
	self:GetParent():EmitSound("Hero_Techies.StickyBomb.Detonate")
end

function modifier_chaotic_reverse_gravity_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Flying_Pathing_Purposes_Only

    }
end

function modifier_chaotic_reverse_gravity_buff:Advanced_GetModifier_FlyingPathing()	
	return 1
end

function modifier_chaotic_reverse_gravity_buff:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
	if IsEnemy(self:GetParent(),self:GetCaster()) then
		self.debuff = true
		table.insert(funcs,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT)
	end
    return funcs
end
function modifier_chaotic_reverse_gravity_buff:GetModifierMoveSpeedBonus_Constant() return   self.bonus_move_speed end
function modifier_chaotic_reverse_gravity_buff:OnTooltip() return self:GetModifierMoveSpeedBonus_Constant() end

function modifier_chaotic_reverse_gravity_buff:GetVisualZDelta( params )
	-- print("self.height_add_rate=",self.height_add_rate)
	self.height = math.min((GameRules:GetGameTime()-self.timer)*self:GetStackCount(),3000)
	return self.height
end








modifier_chaotic_reverse_gravity_refresh_buff = advanced_modifier({})

function modifier_chaotic_reverse_gravity_refresh_buff:IsHidden() 			return true end
function modifier_chaotic_reverse_gravity_refresh_buff:IsPurgable() 			return false end
function modifier_chaotic_reverse_gravity_refresh_buff:IsPurgeException() 	return false end
function modifier_chaotic_reverse_gravity_refresh_buff:IsDebuff() return true end
function modifier_chaotic_reverse_gravity_refresh_buff:RemoveOnDeath() return false end


function modifier_chaotic_reverse_gravity_refresh_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

    return funcs
end

function modifier_chaotic_reverse_gravity_refresh_buff:GetVisualZDelta( params )
	return 25
end






