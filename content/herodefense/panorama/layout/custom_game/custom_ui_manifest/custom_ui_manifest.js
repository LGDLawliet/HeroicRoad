{
    var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("minimap_container").FindChildTraverse("minimap");

		newUI.style.width = "240px";
		newUI.style.height = "240px";
		newUI.style.marginLeft = "10px";
		newUI.style.marginBottom = "10px";

		var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("quickbuy").FindChildTraverse("BuybackHeader");
		newUI.style.visibility = "collapse";
		var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("GridShopHeaders");
		newUI.FindChildTraverse("GridUpgradesTab").style.visibility = "collapse";
		newUI.FindChildTraverse("GridNeutralsTab").style.visibility = "collapse";

		$.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("Main").style.visibility = "collapse";
		$.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("ShopButton").style.visibility = "collapse";


		$.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("HudChat").style.marginBottom = "50px";
		var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");


			newUI.FindChildTraverse("AbilitiesAndStatBranch").style.minWidth = "386px";
			// <!-- newUI.FindChildTraverse("AbilitiesAndStatBranch").style.minWidth = "160px"; -->

			// <!-- 生命条跟魔法条 -->
			var health_mana = newUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer");
			var HealthContainer =  health_mana.FindChildTraverse("HealthContainer");
			HealthContainer.FindChildTraverse("HealthProgress_Left").style.backgroundColor = "gradient( linear, 0% 50%, 80% 50%, from( #152701 ), color-stop( 0.8, #036d38 ), color-stop( .9, #00a329), to( #0ffa36cc ))";
			HealthContainer.FindChildTraverse("HealthRegenLabel").style.color = "white";
			// <!-- HealthContainer.FindChildTraverse("HealthProgress_Left").style.opacity = "0.5"; -->
			var ManaContainer =  health_mana.FindChildTraverse("ManaContainer");
			ManaContainer.FindChildTraverse("ManaProgress_Left").style.backgroundColor = "gradient( linear, 0% 50%, 80% 50%, from( #000e3d ), color-stop( 0.8, #003983 ), color-stop( .9, #0431a3), to( #0199c7cc ))";

			// <!-- 调长技能栏 -->
			var HUDSkinAbilityContainerBG = newUI.FindChildTraverse("HUDSkinAbilityContainerBG")
			HUDSkinAbilityContainerBG.style.width = "600px";
			

			// <!-- 重新设置生命周期显示 -->
			var Lifetime = newUI.FindChildTraverse("xp")
			Lifetime.FindChildTraverse("LifetimeProgress").FindChildTraverse("LifetimeProgress_Left").style.backgroundColor = "gradient( linear, 10% 50%, 90% 95%, from( #3f0000 ), color-stop( 0.2, #830b02 ), color-stop( .6, #c71508), to( #ff0000cc ))";
			Lifetime.FindChildTraverse("LifetimeProgress").style.width = "150px";
			Lifetime.FindChildTraverse("LifetimeProgress").style.height = "18px";
			Lifetime.FindChildTraverse("LifetimeProgress").style.marginBottom = "70px";
			Lifetime.FindChildTraverse("LifetimeProgress").style.marginLeft = "-40px";
			Lifetime.FindChildTraverse("LifetimeProgress").style.borderRadius = "40px";
			Lifetime.FindChildTraverse("LifetimeProgress").style.transform = "rotateZ(-90deg)";
			Lifetime.FindChildTraverse("LifetimeLabel").style.fontSize = "30px";
			Lifetime.FindChildTraverse("LifetimeLabel").style.marginBottom = "158px";
			// <!-- Lifetime.FindChildTraverse("LifetimeLabel").style.marginLeft = "0px"; -->
			Lifetime.FindChildTraverse("LifetimeLabel").style.fontFamily = "Goudy Trajan Medium, FZKai-Z03, TH Sarabun New, YDYGO 540";
			Lifetime.FindChildTraverse("LifetimeLabel").style.color = "gradient(linear, 0% 0%, 0% 90%, from(#f8f8f8), to(#3e6461))";


			// <!-- 经验 -->
			var xppanel = newUI.FindChildTraverse("xp")
			xppanel.FindChildTraverse("CircularXPProgress_FG").style.border = "0px"
			xppanel.FindChildTraverse("LevelBackground").style.width = "0px"
			xppanel.FindChildTraverse("LevelBackground").style.height = "0px"

			var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("stackable_side_panels")
			newUI.FindChildTraverse("QuickStatsContainer").style.visibility = "collapse";


			// <!-- 取消防御符文与扫描 -->
			var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
			newUI.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";

			var hudElements = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements");
			var newUI = hudElements.FindChildTraverse("center_block");
		
			// <!-- newUI.FindChildTraverse("HUDSkinPortrait").style.backgroundimage = "url(raw://resource/flash3/images/hud_skins/zodiac_hud/actionpanel/portrait_wide.png)"; -->
			// <!-- 取消天赋树 -->
			newUI.FindChildTraverse("StatBranch").style.visibility = "collapse";
			newUI.FindChildTraverse("AbilitiesAndStatBranch").Children()[0].Children()[1].style.visibility = "collapse";
			// <!-- 因为升到10，15，20，25又会出现 需要把下面这个也删掉 -->
			newUI.FindChildTraverse("level_stats_frame").style.visibility = "collapse";

		
			
	
			// <!-- 取消阿哈利姆格 -->
			newUI.FindChildTraverse("AghsStatusContainer").style.visibility = "collapse";



			// <!-- 正面buff位于下部 -->
			var BuffBar = hudElements.FindChildTraverse("lower_hud").FindChildTraverse("buffs")
			BuffBar.style.width = "30%";
			BuffBar.style.marginLeft = "38.5%";
			BuffBar.style.marginBottom = "32.5%";
			// <!-- debuff设置于上方 -->
			var DeBuffBar = hudElements.FindChildTraverse("lower_hud").FindChildTraverse("debuffs")
			DeBuffBar.style.width = "30%";
			DeBuffBar.style.marginBottom = "52.5%";
			DeBuffBar.style.marginLeft = "38.5%";
			DeBuffBar.style.flowChildren = "right";

			var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements");
			// <!-- 关闭推荐物品 -->
			newUI.FindChildTraverse("CommonItems").style.visibility = "collapse";;
			
			newUI.FindChildTraverse("GuideFlyout").style.visibility = "collapse";;
			newUI.FindChildTraverse("shop_launcher_block").FindChildTraverse("QuickBuyRows").style.visibility = "collapse";







			
			function FindHudRoot(){  
				var hudRoot;
				for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
					hudRoot = panel;
				}
				return hudRoot;
			}
			// <!-- 移除选人界面的一些东西 -->
			$.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("PreMinimapContainer").style.visibility = "collapse";
			$.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("BottomPanelsContainer").FindChildTraverse("BattlePassHeroData").style.visibility = "collapse";
			$.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("DireTeamPlayers").style.visibility = "collapse";
			
			// <!-- 修正英雄的血条位置 -->
			var MainContents = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("MainContents");
			MainContents.FindChildTraverse("HeroInspect").style.backgroundColor = "gradient( linear, 0% 100%, 0% 0%, from( #232429dd ), to( #1f2027dd ) )";
			MainContents.FindChildTraverse("HeroInspect").Children()[3].style.marginTop = "450px";
			MainContents.style.backgroundImage = "url('s2r://panorama/images/compendium/international2018/underhollow_postgame_bg_png.vtex')"

			// <!-- 选人界面 -->
			MainContents.FindChildTraverse("RightContainerMain").style.visibility = "collapse";
			$.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("BottomPanels").FindChildTraverse("Chat").style.width = "700px";
			$.GetContextPanel().GetParent().GetParent().FindChildTraverse("PreGame").FindChildTraverse("PregameBG").style.washColor = "rgba(0, 0, 0, 0.8)";
			MainContents.FindChildTraverse("HeroPickRightColumn").Children()[0].style.height = "100%"
			MainContents.FindChildTraverse("HeroPickRightColumn").style.border = "2px solid rgb(50,50,50)"; 
			MainContents.FindChildTraverse("HeroPickRightColumn").style.boxShadow = "rgba(10, 10, 10,0.1) 0px 0px 00px 0px";
			MainContents.FindChildTraverse("HeroPickRightColumn").style.boxShadow = "rgba(10, 10, 10,0.1) 0px 0px 00px 0px";
			MainContents.FindChildTraverse("HeroPickRightColumn").FindChildTraverse("LockInButton").style.backgroundImage = "url('s2r://panorama/images/hud/reborn/bg_hud_inspect_psd.vtex')";
			MainContents.FindChildTraverse("HeroPickRightColumn").FindChildTraverse("RandomButton").style.backgroundImage = "url('s2r://panorama/images/hud/reborn/bg_hud_inspect_psd.vtex')";


			// <!-- 商店储存仓库向下移动一些距离 -->
			hudElements.FindChildTraverse("lower_hud").FindChildTraverse("stash").style.marginBottom = "10px";
}