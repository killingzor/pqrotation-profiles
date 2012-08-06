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