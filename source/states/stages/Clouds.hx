package states.stages;

import states.stages.objects.*;
import openfl.display.BlendMode;
import shaders.flixel.system.FlxShader;
import shaders.AdjustColorShader;
import openfl.display.BlendMode;

class Clouds extends BaseStage
{
    var layer0:FlxSprite;
    var layer1:FlxSprite;
    var layer2:FlxSprite;
    var layer3:FlxSprite;
	var layer5:FlxSprite;
    var casa:FlxSprite;
    var nuvem0:FlxSprite;
    var nuvem0b:FlxSprite; // Segunda instância
    var nuvem1:FlxSprite;
    var nuvem1b:FlxSprite; // Segunda instância
    var nuvem2:FlxSprite;
    var nuvem2b:FlxSprite; // Segunda instância
    var nuvem3:FlxSprite;
    var nuvem3b:FlxSprite; // Segunda instância
    var nuvem4:FlxSprite;
    var nuvem4b:FlxSprite; // Segunda instância
    var nuvem5:FlxSprite;
    var nuvem5b:FlxSprite; // Segunda instância
    var nuvem6:FlxSprite;
    var nuvem6b:FlxSprite; // Segunda instância
	var layer4:FlxSprite;
    var layer4b:FlxSprite; // Segunda instância
    var movieBars:FlxSprite;
    var songinfo:FlxSprite;
    var blackScreen:FlxSprite; // Declare blackScreen at the class level
    var songStarted:Bool = false; // Flag to check if the song has started

    override function create()
    {       
        layer0 = new BGSprite('stages/sky/layer0', -500, -300);
        layer0.scrollFactor.set(0.84, 1);
        add(layer0);

		nuvem2 = new BGSprite('stages/sky/nuvem2', -500, -300);
        nuvem2.scrollFactor.set(0.95, 1);
        add(nuvem2);

        nuvem2b = new BGSprite('stages/sky/nuvem2', nuvem2.x + nuvem2.width, nuvem2.y);
        nuvem2b.scrollFactor.set(0.95, 1);
        add(nuvem2b);
        
        nuvem3 = new BGSprite('stages/sky/nuvem3', -500, -300);
        nuvem3.scrollFactor.set(0.95, 1);
        add(nuvem3);

        nuvem3b = new BGSprite('stages/sky/nuvem3', nuvem3.x + nuvem3.width, nuvem3.y);
        nuvem3b.scrollFactor.set(0.95, 1);
        add(nuvem3b);
        
        nuvem4 = new BGSprite('stages/sky/nuvem4', -500, -300);
        nuvem4.scrollFactor.set(0.95, 1);
        add(nuvem4);

        nuvem4b = new BGSprite('stages/sky/nuvem4', nuvem4.x + nuvem4.width, nuvem4.y);
        nuvem4b.scrollFactor.set(0.95, 1);
        add(nuvem4b);
		
        nuvem0 = new BGSprite('stages/sky/nuvem0', -500, -300);
        nuvem0.scrollFactor.set(0.95, 1);
        add(nuvem0);

        nuvem0b = new BGSprite('stages/sky/nuvem0', nuvem0.x + nuvem0.width, nuvem0.y);
        nuvem0b.scrollFactor.set(0.95, 1);
        add(nuvem0b);
        
        nuvem1 = new BGSprite('stages/sky/nuvem1', -500, -300);
        nuvem1.scrollFactor.set(0.95, 1);
        add(nuvem1);

        nuvem1b = new BGSprite('stages/sky/nuvem1', nuvem1.x + nuvem1.width, nuvem1.y);
        nuvem1b.scrollFactor.set(0.95, 1);
        add(nuvem1b);
             
        nuvem5 = new BGSprite('stages/sky/nuvem5', -500, -300);
        nuvem5.scrollFactor.set(0.95, 1);
        add(nuvem5);

        nuvem5b = new BGSprite('stages/sky/nuvem5', nuvem5.x + nuvem5.width, nuvem5.y);
        nuvem5b.scrollFactor.set(0.95, 1);
        add(nuvem5b);

        nuvem6 = new BGSprite('stages/sky/nuvem6', -500, -300);
        nuvem6.scrollFactor.set(0.95, 1);
        add(nuvem6);

        nuvem6b = new BGSprite('stages/sky/nuvem6', nuvem6.x + nuvem6.width, nuvem6.y);
        nuvem6b.scrollFactor.set(0.95, 1);
        add(nuvem6b);
        
        casa = new FlxSprite(-500, -300);
		casa.frames = Paths.getSparrowAtlas('stages/sky/Casa');
		casa.animation.addByPrefix("idle", "Casa", 5, true);
		casa.animation.play('Casa');
		casa.scale.set(0.99, 0.99);
		add(casa);
		
        layer1 = new BGSprite('stages/sky/layer1', -500, -300);
        layer1.scrollFactor.set(0.99, 0.99);
        add(layer1);
        
        layer2 = new BGSprite('stages/sky/layer2', -500, -300);
        layer2.scrollFactor.set(1, 1);
        add(layer2);

        movieBars = new BGSprite('movieBars', 0, 0);
        movieBars.cameras = [camHUD];
        add(movieBars);

        songinfo = new FlxSprite();
        songinfo.frames = Paths.getSparrowAtlas('songs/song-' + songName);
	songinfo.animation.addByPrefix('idle', 'idle', 8, true);
	songinfo.scrollFactor.set();
	songinfo.visible = !ClientPrefs.data.hideHud;
	songinfo.x -= 500;
	songinfo.animation.play('idle');
	songinfo.cameras = [camHUD];
	add(songinfo);
        
        switch(songName)
        {
            case 'clouding':
                blackScreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
                blackScreen.cameras = [camHUD];
				blackScreen.alpha = 1;
                blackScreen.scrollFactor.set();
                add(blackScreen);
        }
    }

    
    override function stepHit()
{
    if (songName == 'clouding')

    {
        if (curStep == 256) {

            FlxG.camera.flash(FlxColor.WHITE, 1);
        }
        if (curStep == 260) {    
            FlxTween.tween(songinfo, {x: 0}, 2.6, {ease: FlxEase.expoOut});

        }
        if (curStep == 292) {    
            FlxTween.tween(songinfo, {x: -500}, 2.6, {
				ease: FlxEase.expoIn});

		}
        if (curStep == 512) {    
            FlxTween.tween(layer5, {alpha: 1}, 1.6, {
				ease: FlxEase.expoIn});

		}
	    if (curStep == 768) {    
            layer5.alpha = 0;

		}
	    if (curStep == 1280) {    
            FlxTween.tween(layer5, {alpha: 1}, 1.6, {
				ease: FlxEase.expoIn});

		}
	    if (curStep == 1535) {    
            layer5.alpha = 0;
                }
        }
	
	  if (songName == 'radiant')
	  {
        if (curStep == 640) {
            FlxTween.tween(layer3, {alpha: 0.9}, 2.5, {
				ease: FlxEase.linear});
		}				   
		if (curStep == 896) {
            FlxTween.tween(layer3, {alpha: 0.55}, 2.5, {
				ease: FlxEase.expoIn,
                onComplete: function(twn:FlxTween) {
				                }
            });
        }
    }
}

	
override function createPost()
{
	layer4 = new BGSprite('stages/sky/layer4', -500, -300);
    layer4.scrollFactor.set(1, 1);
    add(layer4);

	layer4b = new BGSprite('stages/sky/layer4', layer4.x + layer4.width, layer4.y);
    layer4b.scrollFactor.set(1, 1);
    add(layer4b);
	
    layer3 = new BGSprite('stages/sky/layer3', -500, -300);
    layer3.scrollFactor.set(1, 1);
    layer3.alpha = 0.55;
    layer3.blend = ADD;
    add(layer3);

	layer5 = new BGSprite('stages/sky/layer5', -500, -300);
    layer5.scrollFactor.set(1, 1);
    layer5.alpha = 0;
    layer5.blend = ADD;
    add(layer5);

        if (ClientPrefs.data.shaders)
{
    gf.shader = makeCoolShader(0,16,0,0);
    dad.shader = makeCoolShader(0,16,0,0);
    boyfriend.shader = makeCoolShader(0,16,0,0);
	songinfo.shader = makeCoolShader(0,16,0,0);
}
    }

    function makeCoolShader(hue:Float,sat:Float,bright:Float,contrast:Float) {
    var coolShader = new AdjustColorShader();
    coolShader.hue = hue;
    coolShader.saturation = sat;
    coolShader.brightness = bright;
    coolShader.contrast = contrast;
    return coolShader;
}

    override function update(elapsed:Float)
{
    super.update(elapsed);

    nuvem0.x -= 46 * elapsed;
    nuvem0b.x -= 46 * elapsed;

    nuvem1.x -= 48 * elapsed;
    nuvem1b.x -= 48 * elapsed;

    nuvem2.x -= 26 * elapsed;
    nuvem2b.x -= 26 * elapsed;

    nuvem3.x -= 28 * elapsed;
    nuvem3b.x -= 28 * elapsed;

    nuvem4.x -= 30 * elapsed;
    nuvem4b.x -= 30 * elapsed;

    nuvem5.x -= 45 * elapsed;
    nuvem5b.x -= 45 * elapsed;

    nuvem6.x -= 50 * elapsed;
    nuvem6b.x -= 50 * elapsed;

    layer4.x -= 35 * elapsed;
    layer4b.x -= 35 * elapsed;

    if (nuvem0.x + nuvem0.width <= 0) nuvem0.x = nuvem0b.x + nuvem0b.width;
    if (nuvem0b.x + nuvem0b.width <= 0) nuvem0b.x = nuvem0.x + nuvem0.width;

    if (nuvem1.x + nuvem1.width <= 0) nuvem1.x = nuvem1b.x + nuvem1b.width;
    if (nuvem1b.x + nuvem1b.width <= 0) nuvem1b.x = nuvem1.x + nuvem1.width;

    if (nuvem2.x + nuvem2.width <= 0) nuvem2.x = nuvem2b.x + nuvem2b.width;
    if (nuvem2b.x + nuvem2b.width <= 0) nuvem2b.x = nuvem2.x + nuvem2.width;

    if (nuvem3.x + nuvem3.width <= 0) nuvem3.x = nuvem3b.x + nuvem3b.width;
    if (nuvem3b.x + nuvem3b.width <= 0) nuvem3b.x = nuvem3.x + nuvem3.width;

    if (nuvem4.x + nuvem4.width <= 0) nuvem4.x = nuvem4b.x + nuvem4b.width;
    if (nuvem4b.x + nuvem4b.width <= 0) nuvem4b.x = nuvem4.x + nuvem4.width;

    if (nuvem5.x + nuvem5.width <= 0) nuvem5.x = nuvem5b.x + nuvem5b.width;
    if (nuvem5b.x + nuvem5b.width <= 0) nuvem5b.x = nuvem5.x + nuvem5.width;

    if (nuvem6.x + nuvem6.width <= 0) nuvem6.x = nuvem6b.x + nuvem6b.width;
    if (nuvem6b.x + nuvem6b.width <= 0) nuvem6b.x = nuvem6.x + nuvem6.width;

    if (layer4.x + layer4.width <= 0) layer4.x = layer4b.x + layer4b.width;
    if (layer4b.x + layer4b.width <= 0) layer4b.x = layer4.x + layer4.width;
}

    override function countdownTick(count:Countdown, num:Int)
{
    switch(count)
    {
        case THREE:
        case TWO:
        case ONE:
        case GO:
        case START:
            if (songName == 'clouding' && blackScreen != null && !songStarted)
            {
                songStarted = true;
                FlxTween.tween(blackScreen, {alpha: 0}, 15, {
                    ease: FlxEase.quadOut,
                    onComplete: function(twn:FlxTween)
                    {
                        remove(blackScreen); 
                        blackScreen = null;
                    }
                });
            }
    }
}
}



