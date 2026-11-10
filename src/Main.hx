package mods.instant_victory_reveal;

import mods.api.Context;
import mods.api.Mod;
import openfl.events.Event;
import brain.workLoop.DoLater;
import brain.workLoop.WorkComponent;
import brain.workLoop.WorkLoopManager;

/** Runs the original reveal callbacks early, without changing reward data. */
class Main extends Mod {
    var context:Context;
    var summary:Dynamic;
    var failed:Bool = false;
    var logged:Bool = false;

    override public function init(context:Context):Void {
        this.context = context;
        context.core.onObjectReady(function(object) {
            if (Type.getClassName(Type.getClass(object)) == "distributedObjects.DistributedDungeonSummary") {
                summary = object;
                failed = false;
                logged = false;
            }
        });
        context.core.onObjectGone(function(object) {
            if (object == summary) summary = null;
        });
        context.overlay.addEventListener(Event.ENTER_FRAME, advance);
        context.log("loaded; waiting for the dungeon summary");
    }

    override public function dispose():Void {
        context.overlay.removeEventListener(Event.ENTER_FRAME, advance);
        summary = null;
    }

    function advance(event:Event):Void {
        if (summary == null || failed || !context.core.alive) return;
        try {
            var work:WorkComponent = cast Reflect.field(summary, "mWorkComponent");
            if (work == null) return;
            var reveal:Dynamic = Reflect.field(summary, "updateRevealState");
            if (!Reflect.isFunction(reveal)) throw "updateRevealState is not exposed by this game build";
            var manager:WorkLoopManager = cast Reflect.field(work, "mWorkLoopManager");
            var tasks:Dynamic = Reflect.field(work, "mTasks");
            if (manager == null || tasks == null) throw "reveal scheduler is not exposed by this game build";

            // Bound work per display frame, even with unusually large kill totals.
            // Leave the banner fade, chat timers, and four-second trophy reveal alone.
            for (step in 0...512) {
                var found:DoLater = null;
                var keys:Iterator<Dynamic> = tasks.keys();
                for (key in keys) {
                    if (!Std.isOfType(key, DoLater)) continue;
                    var task:DoLater = cast key;
                    if (!task.isDestroyed() && task.callback != null && task.delay <= 0.450001
                        && Reflect.compareMethods(task.callback, reveal)) {
                        found = task;
                        break;
                    }
                }
                if (found == null) break;
                var callback:Dynamic = found.callback;
                manager.removeDoLater(found);
                Reflect.callMethod(summary, callback, [work.gameClock]);
                if (!logged) {
                    logged = true;
                    context.log("fast-forwarding summary reveal");
                }
            }
        } catch (error:Dynamic) {
            failed = true;
            context.log("fast-forward stopped: " + Std.string(error));
        }
    }
}
