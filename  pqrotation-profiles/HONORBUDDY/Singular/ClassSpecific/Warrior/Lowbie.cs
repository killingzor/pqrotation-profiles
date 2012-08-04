using Singular.Dynamics;
using Singular.Helpers;
using Singular.Managers;

using Styx;
using Styx.Combat.CombatRoutine;

using TreeSharp;

namespace Singular.ClassSpecific.Warrior
{
    public class Lowbie
    {
        [Spec(TalentSpec.Lowbie)]
        [Behavior(BehaviorType.Combat)]
        [Class(WoWClass.Warrior)]
        [Priority(500)]
        [Context(WoWContext.Normal)]
        public static Composite CreateLowbieWarriorCombat()
        {
            return new PrioritySelector(
                // Ensure Target
                Safers.EnsureTarget(),
                // LOS Check
                Movement.CreateMoveToLosBehavior(),
                // face target
                Movement.CreateFaceTargetBehavior(),
                // Auto Attack
                Common.CreateAutoAttack(false),
                Helpers.Common.CreateInterruptSpellCast(ret => StyxWoW.Me.CurrentTarget),
                //move to melee
                Movement.CreateMoveToTargetBehavior(true, 5f)
                );
        }

        [Spec(TalentSpec.Lowbie)]
        [Behavior(BehaviorType.Pull)]
        [Class(WoWClass.Warrior)]
        [Priority(500)]
        [Context(WoWContext.Normal)]
        public static Composite CreateLowbieWarriorPull()
        {
            return new PrioritySelector(
                // Ensure Target
                Safers.EnsureTarget(),
                // LOS
                Movement.CreateMoveToLosBehavior(),
                // face target
                Movement.CreateFaceTargetBehavior(),
                // Auto Attack
                Common.CreateAutoAttack(false),
                // move to melee
                Movement.CreateMoveToTargetBehavior(true, 5f)
                );
        }
    }
}
