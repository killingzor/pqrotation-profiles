﻿using System;
using System.Linq;

using Singular.Dynamics;
using Singular.Helpers;
using Singular.Managers;
using Singular.Settings;
using Styx;
using Styx.Combat.CombatRoutine;
using Styx.Logic;
using Styx.Logic.Combat;
using Styx.WoWInternals;
using Styx.WoWInternals.WoWObjects;

using TreeSharp;
using CommonBehaviors.Actions;
using Action = TreeSharp.Action;


namespace Singular.ClassSpecific.Druid
{
    public class Feral
    {
        #region Properties & Fields

        private static DruidSettings Settings { get { return SingularSettings.Instance.Druid; } }

        private const int FERAL_T11_ITEM_SET_ID = 928;
        private const int FERAL_T13_ITEM_SET_ID = 1058;

        private static int NumTier11Pieces
        {
            get
            {
                return StyxWoW.Me.CarriedItems.Count(i => i.ItemInfo.ItemSetId == FERAL_T11_ITEM_SET_ID);
            }
        }

        private static bool Has4PieceTier11Bonus { get { return NumTier11Pieces >= 4; } }

        private static int NumTier13Pieces
        {
            get
            {
                return StyxWoW.Me.CarriedItems.Count(i => i.ItemInfo.ItemSetId == FERAL_T13_ITEM_SET_ID);
            }
        }

        private static bool Has2PieceTier13Bonus { get { return NumTier13Pieces >= 2; } }

        #endregion

        #region Normal Rotation

        [Spec(TalentSpec.FeralDruid)]
        [Behavior(BehaviorType.Pull)]
        [Class(WoWClass.Druid)]
        [Context(WoWContext.Normal)]
        public static Composite CreateFeralNormalPull()
        {
            return new PrioritySelector(
                Safers.EnsureTarget(),
                Movement.CreateMoveToLosBehavior(),
                Movement.CreateFaceTargetBehavior(),

                Spell.Cast("Shred", ret => StyxWoW.Me.CurrentTarget.MeIsBehind),
                Spell.Cast("Mangle (Cat)"),
                Movement.CreateMoveToMeleeBehavior(true)
                );
        }

        [Spec(TalentSpec.FeralDruid)]
        [Behavior(BehaviorType.Combat)]
        [Class(WoWClass.Druid)]
        [Context(WoWContext.Normal)]
        public static Composite CreateFeralNormalCombat()
        {
            return new PrioritySelector(
                Safers.EnsureTarget(),
                Common.CreateNonRestoHeals(),
                Movement.CreateMoveToLosBehavior(),
                Movement.CreateFaceTargetBehavior(),
                Helpers.Common.CreateAutoAttack(true),
                Helpers.Common.CreateInterruptSpellCast(ret => StyxWoW.Me.CurrentTarget),

                new Decorator(
                    ret => Unit.UnfriendlyUnitsNearTarget(8f).Count() >= 3,
                    new PrioritySelector(
                        Spell.Cast("Swipe (Cat)"),
                        Spell.Cast("Mangle (Cat)")
                        )),

                new Decorator(
                    ret => StyxWoW.Me.Level < 86,
                    CreateFeralCombat()),

                Movement.CreateMoveBehindTargetBehavior(),
                Spell.Cast("Shred", ret => StyxWoW.Me.CurrentTarget.MeIsBehind),
                Spell.Cast("Mangle (Cat)", ret => !StyxWoW.Me.CurrentTarget.MeIsBehind),
                Movement.CreateMoveToMeleeBehavior(true)
                );
        }

        private static Composite CreateFeralCombat()
        {
            return new PrioritySelector(
				Spell.Cast("Shred", ret => StyxWoW.Me.CurrentTarget.MeIsBehind),
                Spell.Cast("Mangle (Cat)"),
                Movement.CreateMoveToMeleeBehavior(true)
                );
        }

        #endregion

        #region Instance Rotation

        [Spec(TalentSpec.FeralDruid)]
        [Behavior(BehaviorType.Pull)]
        [Behavior(BehaviorType.Combat)]
        [Class(WoWClass.Druid)]
        [Context(WoWContext.Instances)]
        public static Composite CreateFeralInstanceCombat()
        {
            return new PrioritySelector(
                Safers.EnsureTarget(),
                Movement.CreateMoveToLosBehavior(),
                Movement.CreateFaceTargetBehavior(),
                Spell.WaitForCast(),
                Helpers.Common.CreateAutoAttack(true),
                Helpers.Common.CreateInterruptSpellCast(ret => StyxWoW.Me.CurrentTarget),
                new Decorator(
                    ret => !Group.Tanks.Any() && !Group.Healers.Any(),
                    new PrioritySelector(
                        new Decorator(
                            ret => SingularSettings.Instance.Druid.ManualFeralForm == FeralForm.None && StyxWoW.Me.CurrentMap.IsDungeon,
                            new Action(ret => Logger.Write("Singular can't decide which form to use since there is no roles set in your raid. Please set ManualFeralForm setting to your desired form from Class Config"))),
                        new Decorator(
                            ret => SingularSettings.Instance.Druid.ManualFeralForm == FeralForm.Cat || !StyxWoW.Me.CurrentMap.IsDungeon,
                            CreateFeralCatInstanceCombat()),
                        CreateFeralBearInstanceCombat()
                        )),
                new Decorator(
                    ret => !Group.MeIsTank && Group.Tanks.Any(t => t.IsAlive),
                    CreateFeralCatInstanceCombat()),
                CreateFeralBearInstanceCombat()       
                );
        }

        private static Composite CreateFeralBearInstanceCombat()
        {
            return new PrioritySelector(
                Spell.BuffSelf("Bear Form"),
                Spell.Cast("Feral Charge (Bear)"),
                // Defensive CDs are hard to 'roll' from this type of logic, so we'll simply use them more as 'oh shit' buttons, than anything.
                // Barkskin should be kept on CD, regardless of what we're tanking
                Spell.BuffSelf("Barkskin", ret => StyxWoW.Me.HealthPercent < Settings.FeralBarkskin),
                // Since Enrage no longer makes us take additional damage, just keep it on CD. Its a rage boost, and coupled with King of the Jungle, a DPS boost for more threat.
                Spell.BuffSelf("Enrage"),
                // Only pop SI if we're taking a bunch of damage.
                Spell.BuffSelf("Survival Instincts", ret => StyxWoW.Me.HealthPercent < Settings.SurvivalInstinctsHealth),
                // We only want to pop FR < 30%. Users should not be able to change this value, as FR automatically pushes us to 30% hp.
                Spell.BuffSelf("Frenzied Regeneration", ret => StyxWoW.Me.HealthPercent < Settings.FrenziedRegenerationHealth),
                // Make sure we deal with interrupts...
                //Spell.Cast(80964 /*"Skull Bash (Bear)"*/, ret => (WoWUnit)ret, ret => ((WoWUnit)ret).IsCasting),
                Helpers.Common.CreateInterruptSpellCast(ret => StyxWoW.Me.CurrentTarget),

                new Decorator(
                    ret => Unit.NearbyUnfriendlyUnits.Count(u => u.DistanceSqr < 8 * 8) >= 3,
                    new PrioritySelector(
                        Spell.Cast("Berserk"),
                        Spell.Cast("Demoralizing Roar", 
                            ret => Unit.NearbyUnfriendlyUnits.Any(u => u.DistanceSqr < 10*10 && !u.HasDemoralizing())),
                        Spell.Cast("Maul", ret => TalentManager.HasGlyph("Maul")),
                        Spell.Cast("Thrash"),
                        Spell.Cast("Swipe (Bear)"),
                        Spell.Cast("Mangle (Bear)"),
                        Movement.CreateMoveToMeleeBehavior(true)
                        )),
                // If we have 3+ units not targeting us, and are within 10yds, then pop our AOE taunt. (These are ones we have 'no' threat on, or don't hold solid threat on)
                Spell.Cast(
                    "Challenging Roar", ret => TankManager.Instance.NeedToTaunt.FirstOrDefault(),
                    ret => SingularSettings.Instance.EnableTaunting && TankManager.Instance.NeedToTaunt.Count(u => u.Distance <= 10) >= 3),
                // If there's a unit that needs taunting, do it.
                Spell.Cast(
                    "Growl", ret => TankManager.Instance.NeedToTaunt.FirstOrDefault(),
                    ret => SingularSettings.Instance.EnableTaunting),
                Spell.Cast("Pulverize", ret => ((WoWUnit)ret).HasAura("Lacerate", 3) && !StyxWoW.Me.HasAura("Pulverize")),

                Spell.Buff("Demoralizing Roar", ret => !StyxWoW.Me.CurrentTarget.HasDemoralizing()),

                Spell.Cast("Faerie Fire (Feral)", ret => !((WoWUnit)ret).HasSunders()),
                Spell.Cast("Mangle (Bear)"),
                // Maul is our rage dump... don't pop it unless we have to, or we still have > 2 targets.
                Spell.Cast("Maul", ret => StyxWoW.Me.RagePercent > 60),
                Spell.Cast("Lacerate"),
                Movement.CreateMoveToMeleeBehavior(true)
                );
        }

        private static Composite CreateFeralCatInstanceCombat()
        {
            return new PrioritySelector(

                new Decorator(
                    ret => Unit.NearbyUnfriendlyUnits.Count(u => u.DistanceSqr < 5*5) >= 3,
                    new PrioritySelector(
                        Spell.BuffSelf("Tiger's Fury"),
                        Spell.BuffSelf("Berserk"),
                        Spell.Cast("Swipe (Cat)"),
                        Movement.CreateMoveToMeleeBehavior(true)
                        )),

                Movement.CreateMoveBehindTargetBehavior(),

                Spell.Cast("Mangle (Cat)", 
                    ret => Has4PieceTier11Bonus && StyxWoW.Me.GetAuraTimeLeft("Strength of the Panther", false).TotalSeconds < 3),
                Spell.Buff("Mangle (Cat)", "Mangle", "Trauma", "Stampede"),
                Spell.Cast("Shred", 
                    ret => TalentManager.HasGlyph("Bloodletting") && StyxWoW.Me.CurrentTarget.HasMyAura("Rip") &&
                           StyxWoW.Me.CurrentTarget.MeIsBehind &&
                           StyxWoW.Me.CurrentTarget.GetAuraTimeLeft("Rip", true).TotalSeconds < 14),
                Spell.Cast("Shred", ret => StyxWoW.Me.HasAura("Omen of Clarity") && StyxWoW.Me.CurrentTarget.MeIsBehind),
                Spell.Cast("Mangle (Cat)", ret => StyxWoW.Me.HasAura("Omen of Clarity") && !StyxWoW.Me.CurrentTarget.MeIsBehind),
                Spell.Cast("Mangle (Cat)", ret => Has4PieceTier11Bonus && !StyxWoW.Me.HasAura("Strength of the Panther", 3)),
                new Decorator(
                    ret => StyxWoW.Me.CurrentTarget.MeIsBehind,
                    new PrioritySelector(
                        Spell.Cast("Shred", ret => StyxWoW.Me.HasAura("Tiger's Fury") && StyxWoW.Me.HasAura("Berserk")),
                        Spell.Cast("Shred", 
                            ret => SpellManager.HasSpell("Tiger's Fury") && !SpellManager.GlobalCooldown &&
                                   SpellManager.Spells["Tiger's Fury"].CooldownTimeLeft.TotalSeconds <= 3),
                        Spell.Cast("Shred", ret => StyxWoW.Me.ComboPoints == 4),
                        Spell.Cast("Shred", ret => StyxWoW.Me.EnergyPercent >= 85))),
                new Decorator(
                    ret => !StyxWoW.Me.CurrentTarget.MeIsBehind,
                    new PrioritySelector(
                        Spell.Cast("Mangle (Cat)", ret => StyxWoW.Me.HasAura("Tiger's Fury") && StyxWoW.Me.HasAura("Berserk")),
                        Spell.Cast("Mangle (Cat)", 
                            ret => SpellManager.HasSpell("Tiger's Fury") && !SpellManager.GlobalCooldown &&
                                   SpellManager.Spells["Tiger's Fury"].CooldownTimeLeft.TotalSeconds <= 3),
                        Spell.Cast("Mangle (Cat)", ret => StyxWoW.Me.ComboPoints == 4),
                        Spell.Cast("Mangle (Cat)", ret => StyxWoW.Me.EnergyPercent >= 85))),
                Movement.CreateMoveToMeleeBehavior(true)
                );
        }

        #endregion

    }
}