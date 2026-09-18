--用于无目标技能的指示器，延迟2秒销毁
--中文注释关联starbreaker这个技能，如果你想阅读，请从starbreaker里的创建本特效开始阅读
-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_generic_custom_indicator_delay = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_custom_indicator_delay:IsHidden()
	return true
end

function modifier_generic_custom_indicator_delay:IsPurgable()
	return true
end

function modifier_generic_custom_indicator_delay:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_custom_indicator_delay:OnCreated( kv )
	if IsServer() then return end

	-- register modifier to ability
	self:GetAbility().custom_indicator = self
end

function modifier_generic_custom_indicator_delay:OnRefresh( kv )
end

function modifier_generic_custom_indicator_delay:OnRemoved()
end

function modifier_generic_custom_indicator_delay:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
--定时器运行后首先会关闭自己 所以这个定时器只会进行一次 当然由于Register( loc )每帧都被调用了 所以定时器会被不断刷新不执行 等到你施法或者取消技能
--CastFilterResultLocation( vLoc )就不会运行 计时器不被刷新也就得以运行了
--获取一下技能里是否有DestroyCustomIndicator函数 如果有将init设置为nil 并允许销毁程序
--注意看最下面的启用定时器self:StartIntervalThink( 0.1 ) 里面的数值是0.1 这个数值将会是检测间隔 如果你设置成1了 那么当你释放技能或者取消技能 指示器会延迟1秒销毁
--当时其实特效做不到瞬间销毁 所以会有一小点延迟

function modifier_generic_custom_indicator_delay:OnIntervalThink()
	if IsClient() then

		local ability = self:GetAbility()
		if not ability then
			self:StartIntervalThink(-1)
			if self.init then
				self.init = nil
				ParticleManager:DestroyParticle( self.effect_cast, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
				ParticleManager:ReleaseParticleIndex( self.effect_cast )
			end
		end
		self.timer = self.timer+0.02


	
		ParticleManager:SetParticleControl( self.effect_cast, self.point, self:GetCaster():GetAbsOrigin() )

		if self.timer>=self.delay then
			self:StartIntervalThink(-1)
			if self.init then
				self.init = nil
				ParticleManager:DestroyParticle( self.effect_cast, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
				ParticleManager:ReleaseParticleIndex( self.effect_cast )
			end
		end
		-- end
		
	end
end


function modifier_generic_custom_indicator_delay:Register( loc,point ,delay)
	-- TODO: check if self.ability can persist through disconnect if declared in OnCreated
	local ability = self:GetAbility()
	self.timer = 0
	ability.currentIndicator = self
	self.point = point
	self.delay = delay


	-- init
	if (not self.init) and ability.CreateCustomIndicator then
		self.init = true
		ability:CreateCustomIndicator()
	end


	-- start interval
	self:StartIntervalThink( 0.02 )
end


function modifier_generic_custom_indicator_delay:Destroy()
	if self.init then
		self.init = nil
		ParticleManager:DestroyParticle( self.effect_cast, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
	end
end