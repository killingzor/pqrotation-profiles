using Singular.Dynamics;
using Singular.Helpers;
using Singular.Managers;
using Singular.Settings;

using Styx;
using Styx.Combat.CombatRoutine;

using TreeSharp;
using Styx.Logic.Combat;
using Styx.Helpers;
using System;
using Action = TreeSharp.Action;

namespace Singular.ClassSpecific.Warrior
{
    public class Arms
    {
        private static string[] _slows;
        [Spec(TalentSpec.ArmsWarrior)]
        [Behavior(BehaviorType.Combat)]
        [Class(WoWClass.Warrior)]
        [Priority(500)]
        [Context(WoWContext.All)]
        public static Composite CreateArmsCombat()
        {
          return new PrioritySelector(
                //Ensure Target
                Safers.EnsureTarget(),
                //LOS check
                Movement.CreateMoveToLosBehavior(),
                // face target
                Movement.CreateFaceTargetBehavior(),
                // Auto Attack
                Common.CreateAutoAttack(false),

                //Stance Dancing
                //Pop over to Zerker
                Spell.BuffSelf("Berserker Stance", ret => StyxWoW.Me.CurrentTarget.HasMyAura("Rend") && !StyxWoW.Me.ActiveAuras.ContainsKey("Taste for Blood") && StyxWoW.Me.RagePercent < 75 && StyxWoW.Me.CurrentTarget.IsBoss() && SingularSettings.Instance.Warrior.UseWarriorStanceDance),
                //Keep in Battle Stance
                Spell.BuffSelf("Battle Stance", ret => !StyxWoW.Me.CurrentTarget.HasMyAura("Rend") || ((StyxWoW.Me.ActiveAuras.ContainsKey("Overpower") || StyxWoW.Me.ActiveAuras.ContainsKey("Taste for Blood")) && SpellManager.Spells["Mortal Strike"].Cooldown) && StyxWoW.Me.RagePercent <= 75 && SingularSettings.Instance.Warrior.UseWarriorKeepStance),

                //ensure were in melee
                Movement.CreateMoveToMeleeBehavior(true)
                );
        }

        [Spec(TalentSpec.ArmsWarrior)]
        [Behavior(BehaviorType.Pull)]
        [Class(WoWClass.Warrior)]
        [Priority(500)]
        [Context(WoWContext.All)]
        public static Composite CreateArmsPull()
        {
            return new PrioritySelector(
                // Ensure Target
                Safers.EnsureTarget(),
                //face target
                Movement.CreateFaceTargetBehavior(),
                // LOS check
                Movement.CreateMoveToLosBehavior(),
                // Auto Attack
                Common.CreateAutoAttack(false),
                // Move to Melee
                Movement.CreateMoveToMeleeBehavior(true)
                );
        }
    }
}