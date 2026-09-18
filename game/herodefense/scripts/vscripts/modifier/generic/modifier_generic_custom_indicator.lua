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
modifier_generic_custom_indicator = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_custom_indicator:IsHidden()
	return true
end

function modifier_generic_custom_indicator:IsPurgable()
	return true
end

function modifier_generic_custom_indicator:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_custom_indicator:OnCreated( kv )
	if IsServer() then return end

	-- register modifier to ability
	self:GetAbility().custom_indicator = self
end

function modifier_generic_custom_indicator:OnRefresh( kv )
end

function modifier_generic_custom_indicator:OnRemoved()
end

function modifier_generic_custom_indicator:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
--定时器运行后首先会关闭自己 所以这个定时器只会进行一次 当然由于Register( loc )每帧都被调用了 所以定时器会被不断刷新不执行 等到你施法或者取消技能
--CastFilterResultLocation( vLoc )就不会运行 计时器不被刷新也就得以运行了
--获取一下技能里是否有DestroyCustomIndicator函数 如果有将init设置为nil 并允许销毁程序
--注意看最下面的启用定时器self:StartIntervalThink( 0.1 ) 里面的数值是0.1 这个数值将会是检测间隔 如果你设置成1了 那么当你释放技能或者取消技能 指示器会延迟1秒销毁
--当时其实特效做不到瞬间销毁 所以会有一小点延迟

function modifier_generic_custom_indicator:OnIntervalThink()
	if IsClient() then
		-- end
		self:StartIntervalThink(-1)
		-- print("diao yong")
		-- destroy effect
		local ability = self:GetAbility()
		if self.init and ability.DestroyCustomIndicator then
			self.init = nil
			ability:DestroyCustomIndicator()
		end
	end
end

--------------------------------------------------------------------------------
-- Helper
--第一次跳转到这：
--从技能那里呼出这个函数 我们现在得到了一个Vector参数
--一开始self.init当然是nil 所以执行了第一个if  ability.CreateCustomIndicator应该是判断技能里有没有定义这个函数
--如果有 就将self.init设置为true 同时执行函数  当然下面的东西也会执行 但我们留到第二次跳转再说 跳转到技能的CreateCustomIndicator()继续阅读

--第二次跳转到这：
--接下来是第二次以后的调用了 我们会发现 第一个if不会执行 只会执行第二个if了 跳转到UpdateCustomIndicator( loc )

--第三次跳转到这：
--最后是定时器的功能 我们再跳转到定时器那里阅读

function modifier_generic_custom_indicator:Register( loc )
	-- TODO: check if self.ability can persist through disconnect if declared in OnCreated
	local ability = self:GetAbility()

	-- init
	if (not self.init) and ability.CreateCustomIndicator then
		self.init = true
		ability:CreateCustomIndicator()
	end

	-- update
	if ability.UpdateCustomIndicator then
		ability:UpdateCustomIndicator( loc )
	end

	-- start interval
	self:StartIntervalThink( 0.1 )
end
