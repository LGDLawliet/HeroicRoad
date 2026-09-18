creeps_spell_dragon_blood = class({})



LinkLuaModifier( "modifier_creeps_spell_dragon_blood_damage_count", "creeps_spell/creeps_spell_dragon_blood", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_blood_damage_count", "creeps_spell/creeps_spell_dragon_blood", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_dragon_blood_triger", "creeps_spell/creeps_spell_dragon_blood", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imgeneric_knockback_lua", "modifier/modifier_imgeneric_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
require('internal/timers')

function creeps_spell_dragon_blood:GetIntrinsicModifierName() return "modifier_creeps_spell_dragon_blood_damage_count" end
--------------------------------------------------------------------------------





modifier_creeps_spell_dragon_blood_damage_count = class({})
function modifier_creeps_spell_dragon_blood_damage_count:IsHidden() return true end
function modifier_creeps_spell_dragon_blood_damage_count:IsDebuff() return false end
function modifier_creeps_spell_dragon_blood_damage_count:IsPurgable() 		return false end
function modifier_creeps_spell_dragon_blood_damage_count:IsPurgeException() 	return false end
function modifier_creeps_spell_dragon_blood_damage_count:RemoveOnDeath()  return false end
function modifier_creeps_spell_dragon_blood_damage_count:IsStunDebuff() return false end
function modifier_creeps_spell_dragon_blood_damage_count:AllowIllusionDuplicate() return false end

function modifier_creeps_spell_dragon_blood_damage_count:DeclareFunctions() return
    {MODIFIER_EVENT_ON_TAKEDAMAGE} end


function modifier_creeps_spell_dragon_blood_damage_count:OnTakeDamage(keys)
	if not IsServer() then 
		return
    end
    --self.off 是判定是否进入了第二状态，如果进入了则以下效果均取消，不再触发电场
    if  self.off~=nil then
        return
    end

	if keys.unit ~= self:GetParent() then
		return
	end
	if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
		return
    end
    local ability = self:GetAbility()
    local caster = self:GetParent()
    caster:AddNewModifier(caster, ability, "modifier_dragon_blood_damage_count", {duration= 40,stack=keys.damage})
end






modifier_dragon_blood_damage_count = class({})

function modifier_dragon_blood_damage_count:IsDebuff() return false end
function modifier_dragon_blood_damage_count:IsHidden() return false end
function modifier_dragon_blood_damage_count:IsPurgable() return false end


function modifier_dragon_blood_damage_count:OnCreated(keys)
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime(),stack = keys.stack })
		self:SetStackCount(keys.stack )
		self:StartIntervalThink(0.1)
	end
end
function modifier_dragon_blood_damage_count:OnRefresh(keys)
	if IsServer() then
		table.insert(self.tData, {dieTime = self:GetDieTime(),stack = keys.stack  })
		self:SetStackCount(self:GetStackCount()+keys.stack )
	end
end

function modifier_dragon_blood_damage_count:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				self:SetStackCount(self:GetStackCount()-self.tData[i].stack )
				table.remove(self.tData, i)

			end
		end
		local stack = self:GetStackCount()
		if stack>=self:GetParent():GetMaxHealth()*0.2 then
			local healing = HealWithGain(stack*0.7,self:GetParent(),self:GetParent(),self:GetAbility())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), healing, nil)
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creeps_spell_dragon_blood_triger", {duration= 0.5})
			self:SafeDestroy()
		end




	end
end








modifier_creeps_spell_dragon_blood_triger = class({})
function modifier_creeps_spell_dragon_blood_triger:IsHidden() return true end
function modifier_creeps_spell_dragon_blood_triger:IsDebuff() return false end
function modifier_creeps_spell_dragon_blood_triger:IsPurgable() return false end
function modifier_creeps_spell_dragon_blood_triger:IsPurgeException() return false end
function modifier_creeps_spell_dragon_blood_triger:IsStunDebuff() return false end
function modifier_creeps_spell_dragon_blood_triger:AllowIllusionDuplicate() return false end
function modifier_creeps_spell_dragon_blood_triger:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED]   = true,
        [MODIFIER_STATE_SILENCED]   = true,
		[MODIFIER_STATE_INVULNERABLE]   = true,
    }
    return state
end
function modifier_creeps_spell_dragon_blood_triger:DeclareFunctions() return {
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
} end
function modifier_creeps_spell_dragon_blood_triger:GetOverrideAnimation( params ) return ACT_DOTA_FLAIL end
function modifier_creeps_spell_dragon_blood_triger:GetOverrideAnimationRate( params ) return 0.5 end

function modifier_creeps_spell_dragon_blood_triger:OnCreated(table)
    if IsServer() then
		self.next_step = 0
		self:StartIntervalThink(FrameTime())
        local particle_cast = "particles/rebuild/spell/fire_dragon_fly/before_fly.vpcf"
        local caster = self:GetCaster()
		local ability = self:GetAbility()
        caster:EmitSound("Hero_Sven.WarCry.Shield")
		local damageTable = {

			attacker = caster,
			damage = 3*caster:GetDamageMax(),
			damage_type = ability:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = ability, --Optional.
			}
	
		Timers:CreateTimer(0.3, function()
			local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleControl( effect_cast, 0,caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( effect_cast, 61,Vector(5,0,0))
			ParticleManager:ReleaseParticleIndex(effect_cast)
			-- caster:AddNewModifier(caster, self:GetAbility(), "modifier_creeps_spell_dracarys", {duration= 10})
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	
			for _, enemy in ipairs(units) do
				local enemy_direction = (enemy:GetOrigin() - caster:GetAbsOrigin()):Normalized()
				enemy:AddNewModifier(
					caster, -- player source
					ability, -- ability source
					"modifier_imgeneric_knockback_lua", -- modifier name
					{
						duration = 0.3,
						distance = 500,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
					} -- kv
				)
				damageTable.victim = enemy
				
	


				ApplyDamage(damageTable)
			
					
				
			end
		end)

    end
end


function modifier_creeps_spell_dragon_blood_triger:OnIntervalThink(table)
	self.next_step = self.next_step + 30
	self.facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, -self.next_step , 0 ), Vector(0,1,0) )
	self:GetParent():SetForwardVector( self.facing )
end







