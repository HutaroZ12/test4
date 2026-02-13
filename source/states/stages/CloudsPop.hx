package states.stages;

import states.stages.objects.*;
import openfl.display.BlendMode;
import shaders.flixel.system.FlxShader;
import shaders.AdjustColorShader;
import openfl.display.BlendMode;

class CloudsPop extends BaseStage
{
    var layer0:BGSprite;
    var layer1:BGSprite;
	var layer1b:BGSprite;
    var layer2:BGSprite;
    var layer3:BGSprite;
	var layer5:BGSprite;
    var casa:FlxSprite;
    var nuvem0:BGSprite;
    var nuvem0b:BGSprite; 
    var nuvem1:BGSprite;
    var nuvem1b:BGSprite;
    var nuvem2:BGSprite;
    var nuvem2b:BGSprite; 
    var nuvem3:BGSprite;
    var nuvem3b:BGSprite; 
    var nuvem4:BGSprite;
    var nuvem4b:BGSprite;
    var nuvem5:BGSprite;
    var nuvem5b:BGSprite;
    var nuvem6:BGSprite;
    var nuvem6b:BGSprite;
	var nuvem7:BGSprite;
    var nuvem7b:BGSprite;
	var nuvem8:BGSprite;
    var nuvem8b:BGSprite;
	var nuvem9:BGSprite;
    var nuvem9b:BGSprite;
	var nuvem10:BGSprite;
    var nuvem10b:BGSprite;
	var nuvem11:BGSprite;
    var nuvem11b:BGSprite;
	var layer4:BGSprite;
    var layer4b:BGSprite; 
    var movieBars:FlxSprite;
    var songinfo:FlxSprite;
    var blackScreen:FlxSprite; 
    var songStarted:Bool = false; 
	
    override function create()
    {       
        layer0 = new BGSprite('stages/sky/popstyle/sky/layer0', -500, -300);
        layer0.scrollFactor.set(0.84, 1);
        add(layer0);

		nuvem2 = new BGSprite('stages/sky/popstyle/sky/nuvem2', -500, -300);
        nuvem2.scrollFactor.set(0.84, 1);
		nuvem2.blend = SCREEN;
        add(nuvem2);

        nuvem2b = new BGSprite('stages/sky/popstyle/sky/nuvem2', nuvem2.x + nuvem2.width, nuvem2.y);
        nuvem2b.scrollFactor.set(0.841, 1);
		nuvem2b.blend = SCREEN;
        add(nuvem2b);
        
        nuvem3 = new BGSprite('stages/sky/popstyle/sky/nuvem3', -500, -300);
        nuvem3.scrollFactor.set(0.842, 1);
		nuvem3.blend = SCREEN;
        add(nuvem3);
        
        nuvem3b = new BGSprite('stages/sky/popstyle/sky/nuvem2', nuvem2.x + nuvem2.width, nuvem2.y);
        nuvem3b.scrollFactor.set(0.843, 1);
		nuvem3b.blend = SCREEN;
        add(nuvem2b);
        
        nuvem7 = new BGSprite('stages/sky/popstyle/sky/nuvem7', -500, -300);
        nuvem7.scrollFactor.set(0.844, 1);
		nuvem7.blend = SCREEN;
        add(nuvem7);

        nuvem7b = new BGSprite('stages/sky/popstyle/sky/nuvem3', nuvem7.x + nuvem7.width, nuvem7.y);
        nuvem7b.scrollFactor.set(0.845, 1);
		nuvem7b.blend = SCREEN;
        add(nuvem7b);
        
        nuvem4 = new BGSprite('stages/sky/popstyle/sky/nuvem4', -500, -300);
        nuvem4.scrollFactor.set(0.846, 1);
		nuvem4.blend = SCREEN;
        add(nuvem4);

        nuvem4b = new BGSprite('stages/sky/popstyle/sky/nuvem4', nuvem4.x + nuvem4.width, nuvem4.y);
        nuvem4b.scrollFactor.set(0.847, 1);
		nuvem4b.blend = SCREEN;
        add(nuvem4b);
		
		nuvem8 = new BGSprite('stages/sky/popstyle/sky/nuvem8', -500, -300);
        nuvem8.scrollFactor.set(0.848, 1);
		nuvem8.blend = SCREEN;
        add(nuvem8);

        nuvem8b = new BGSprite('stages/sky/popstyle/sky/nuvem3', nuvem8.x + nuvem8.width, nuvem8.y);
        nuvem8b.scrollFactor.set(0.849, 1);
		nuvem8b.blend = SCREEN;
        add(nuvem8b);
        
        nuvem9 = new BGSprite('stages/sky/popstyle/sky/nuvem9', -500, -300);
        nuvem9.scrollFactor.set(0.85, 1);
		nuvem9.blend = SCREEN;
        add(nuvem9);

        nuvem9b = new BGSprite('stages/sky/popstyle/sky/nuvem3', nuvem9.x + nuvem9.width, nuvem9.y);
        nuvem9b.scrollFactor.set(0.851, 1);
		nuvem9b.blend = SCREEN;
        add(nuvem9b);
        
        nuvem0 = new BGSprite('stages/sky/popstyle/sky/nuvem0', -500, -300);
        nuvem0.scrollFactor.set(0.852, 1);
		nuvem0.blend = SCREEN;
        add(nuvem0);

        nuvem0b = new BGSprite('stages/sky/popstyle/sky/nuvem0', nuvem0.x + nuvem0.width, nuvem0.y);
        nuvem0b.scrollFactor.set(0.853, 1);
		nuvem0b.blend = SCREEN;
        add(nuvem0b);        
        
        nuvem1 = new BGSprite('stages/sky/popstyle/sky/nuvem1', -500, -300);
        nuvem1.scrollFactor.set(0.854, 1);
		nuvem1.blend = SCREEN;
        add(nuvem1);

        nuvem1b = new BGSprite('stages/sky/popstyle/sky/nuvem1', nuvem1.x + nuvem1.width, nuvem1.y);
        nuvem1b.scrollFactor.set(0.855, 1);
		nuvem1b.blend = SCREEN;
        add(nuvem1b);
             
        nuvem5 = new BGSprite('stages/sky/popstyle/sky/nuvem5', -500, -300);
        nuvem5.scrollFactor.set(0.856, 1);
		nuvem5.blend = SCREEN;
        add(nuvem5);

        nuvem5b = new BGSprite('stages/sky/popstyle/sky/nuvem5', nuvem5.x + nuvem5.width, nuvem5.y);
        nuvem5b.scrollFactor.set(0.857, 1);
		nuvem5b.blend = SCREEN;
        add(nuvem5b);

        nuvem6 = new BGSprite('stages/sky/popstyle/sky/nuvem6', -500, -300);
        nuvem6.scrollFactor.set(0.858, 1);
		nuvem6.blend = SCREEN;
        add(nuvem6);

        nuvem6b = new BGSprite('stages/sky/popstyle/sky/nuvem6', nuvem6.x + nuvem6.width, nuvem6.y);
        nuvem6b.scrollFactor.set(0.859, 1);
		nuvem6b.blend = SCREEN;
        add(nuvem6b);
        
        nuvem10 = new BGSprite('stages/sky/popstyle/sky/nuvem10', -500, -300);
        nuvem10.scrollFactor.set(0.86, 1);
		nuvem10.blend = SCREEN;
        add(nuvem10);

        nuvem10b = new BGSprite('stages/sky/popstyle/sky/nuvem3', nuvem10.x + nuvem10.width, nuvem10.y);
        nuvem10b.scrollFactor.set(0.861, 1);
		nuvem10b.blend = SCREEN;
        add(nuvem10b);
        
        nuvem11 = new BGSprite('stages/sky/popstyle/sky/nuvem11', -500, -300);
        nuvem11.scrollFactor.set(0.862, 1);
		nuvem11.blend = SCREEN;
        add(nuvem11);

        nuvem11b = new BGSprite('stages/sky/popstyle/sky/nuvem3', nuvem11.x + nuvem11.width, nuvem11.y);
        nuvem11b.scrollFactor.set(0.863, 1);
		nuvem11b.blend = SCREEN;
        add(nuvem11b);

		layer1 = new BGSprite('stages/sky/popstyle/sky/layer1', -500, -300);
        layer1.scrollFactor.set(0.99, 0.99);
        add(layer1);

		layer1b = new BGSprite('stages/sky/popstyle/sky/layer1', layer1.x + layer1.width, layer1.y);
        layer1b.scrollFactor.set(0.863, 1);
        add(layer1b);
        
        casa = new FlxSprite(-500, -300);
		casa.frames = Paths.getSparrowAtlas('stages/sky/popstyle/sky/casa');
		casa.animation.addByPrefix("idle", "casa", 5, true);
		casa.animation.play('idle');
		casa.scrollFactor.set(0.98, 0.98);
		casa.scale.set(1, 1);
		add(casa);
        
        layer2 = new BGSprite('stages/sky/popstyle/sky/layer2', -500, -300);
        layer2.scrollFactor.set(0.99, 0.99);
        add(layer2);

		layer3 = new BGSprite('stages/sky/popstyle/sky/layer3', -500, -300);
        layer3.scrollFactor.set(1, 1);
        add(layer3);
		
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
      	if (curStep == 1) {

			layer4.alpha = 0;
			layer4b.alpha = 0;
		}
        if (curStep == 256) {

            FlxG.camera.flash(FlxColor.WHITE, 1);
			layer4.alpha = 1;
			layer4b.alpha = 1;
        }
        if (curStep == 260) {    
            FlxTween.tween(songinfo, {x: 0}, 2.6, {ease: FlxEase.expoOut});

        }
        if (curStep == 292) {    
            FlxTween.tween(songinfo, {x: -500}, 2.6, {
				ease: FlxEase.expoIn});

		}
        if (curStep == 512) {    
            FlxTween.tween(layer5, {alpha: 0.7}, 0.6, {
				ease: FlxEase.expoIn});

		}
	    if (curStep == 768) {    
            layer5.alpha = 0;

		}
	    if (curStep == 1280) {    
            FlxTween.tween(layer5, {alpha: 0.7}, 0.6, {
				ease: FlxEase.expoIn});

		}
	    if (curStep == 1535) {    
            layer5.alpha = 0;
                }
        }

      if (songName == 'radiant-popstyle')
	  {
		if (curStep == 128) {    
            FlxTween.tween(songinfo, {x: 0}, 2.6, {ease: FlxEase.expoOut});

        }
        if (curStep == 156) {    
            FlxTween.tween(songinfo, {x: -500}, 2.6, {
				ease: FlxEase.expoIn});
		        }
	  }

	  if (songName == 'radiant')
	  {
		if (curStep == 10) {    
            FlxTween.tween(songinfo, {x: 0}, 2.6, {ease: FlxEase.expoOut});

        }
        if (curStep == 44) {    
            FlxTween.tween(songinfo, {x: -500}, 2.6, {
				ease: FlxEase.expoIn});

		}
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
	layer4 = new BGSprite('stages/sky/popstyle/sky/layer4', -500, -300);
    layer4.scrollFactor.set(1, 1);
    add(layer4);

	layer4b = new BGSprite('stages/sky/popstyle/sky/layer4', layer4.x + layer4.width, layer4.y);
    layer4b.scrollFactor.set(1, 1);
    add(layer4b);

	layer5 = new BGSprite('stages/sky/popstyle/sky/layer5', -500, -300);
    layer5.scrollFactor.set(1, 1);
    layer5.blend = OVERLAY;
    add(layer5);

        if (ClientPrefs.data.shaders)
{
    gf.shader = makeCoolShader(-12,-19,-11,0);
    dad.shader = makeCoolShader(-12,-19,-11,0);
    boyfriend.shader = makeCoolShader(-12,-19,-11,0);
	songinfo.shader = makeCoolShader(-12,-19,-11,0);
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

    nuvem0.x -= 4 * elapsed;
    nuvem0b.x -= 4 * elapsed;

    nuvem1.x -= 4.5 * elapsed;
    nuvem1b.x -= 4.5 * elapsed;

    nuvem2.x -= 2 * elapsed;
    nuvem2b.x -= 2 * elapsed;

    nuvem3.x -= 2.5 * elapsed;
    nuvem3b.x -= 2.5 * elapsed;

    nuvem4.x -= 3 * elapsed;
    nuvem4b.x -= 3 * elapsed;

    nuvem5.x -= 4.2 * elapsed;
    nuvem5b.x -= 4.2 * elapsed;

    nuvem6.x -= 5 * elapsed;
    nuvem6b.x -= 5 * elapsed;

    nuvem7.x -= 3.5 * elapsed;
    nuvem7b.x -= 3.5 * elapsed;
    
    nuvem8.x -= 3.5 * elapsed;
    nuvem8b.x -= 3.5 * elapsed;
    
    nuvem9.x -= 2.8 * elapsed;
    nuvem9b.x -= 2.8 * elapsed;
    
    nuvem10.x -= 4.7 * elapsed;
    nuvem10b.x -= 4.7 * elapsed;

    nuvem11.x -= 5 * elapsed;
    nuvem11b.x -= 5 * elapsed;
    
    layer4.x -= 50 * elapsed;
    layer4b.x -= 50 * elapsed;

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

    if (nuvem7.x + nuvem7.width <= 0) nuvem7.x = nuvem7b.x + nuvem7b.width;
    if (nuvem7b.x + nuvem7b.width <= 0) nuvem7b.x = nuvem7.x + nuvem7.width;
    
    if (nuvem8.x + nuvem8.width <= 0) nuvem8.x = nuvem8b.x + nuvem8b.width;
    if (nuvem8b.x + nuvem8b.width <= 0) nuvem8b.x = nuvem8.x + nuvem8.width;
    
    if (nuvem9.x + nuvem9.width <= 0) nuvem9.x = nuvem9b.x + nuvem9b.width;
    if (nuvem9b.x + nuvem9b.width <= 0) nuvem9b.x = nuvem9.x + nuvem9.width;
    
    if (nuvem10.x + nuvem10.width <= 0) nuvem10.x = nuvem10b.x + nuvem10b.width;
    if (nuvem10b.x + nuvem10b.width <= 0) nuvem10b.x = nuvem10.x + nuvem10.width;
    
    if (nuvem11.x + nuvem11.width <= 0) nuvem11.x = nuvem11b.x + nuvem11b.width;
    if (nuvem11b.x + nuvem11b.width <= 0) nuvem11b.x = nuvem11.x + nuvem11.width;
    
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
