import script.core.Call;
import openfl.Lib;
import script.core.Loop;

class LoopTest {
    
    static function main() {
        var pupil = new Pupil();
        var loop = new Loop(10);
        loop.addScript(new Call(function(){
            trace(1);
        }));
        pupil.addScript(loop);
        pupil.start();
    }

}