package states.stages;

import states.stages.objects.*;
import openfl.display.BlendMode;
import shaders.flixel.system.FlxShader;
import shaders.AdjustColorShader;
import openfl.display.BlendMode;

class CloudsPop extends BaseStage
{
    var layer0:BGSprite;
    var layer2:BGSprite;
    var layer3:BGSprite;
	var layer5:BGSprite;
	var aviao:BGSprite
	var aviaoViajando:Bool = true;
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
	var layer1:BGSprite;
    var layer1b:BGSprite; 
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
        nuvem2.scrollFactor.set(0.89, 0.9);
		nuvem2.blend = DARKEN;
        add(nuvem2);

        nuvem2b = new BGSprite('stages/sky/popstyle/sky/nuvem2', nuvem2.x + nuvem2.width, nuvem2.y);
        nuvem2b.scrollFactor.set(0.892, 0.9);
		nuvem2b.blend = DARKEN;
        add(nuvem2b);
        
        nuvem3 = new BGSprite('stages/sky/popstyle/sky/nuvem3', -500, -300);
        nuvem3.scrollFactor.set(0.894, 0.9);
		nuvem3.blend = DARKEN;
        add(nuvem3);
        
        nuvem3b = new BGSprite('stages/sky/popstyle/sky/nuvem3', nuvem2.x + nuvem2.width, nuvem2.y);
        nuvem3b.scrollFactor.set(0.896, 0.9);
		nuvem3b.blend = DARKEN;
        add(nuvem2b);
        
        nuvem7 = new BGSprite('stages/sky/popstyle/sky/nuvem7', -500, -300);
        nuvem7.scrollFactor.set(0.898, 0.9);
		nuvem7.blend = DARKEN;
        add(nuvem7);

        nuvem7b = new BGSprite('stages/sky/popstyle/sky/nuvem7', nuvem7.x + nuvem7.width, nuvem7.y);
        nuvem7b.scrollFactor.set(0.900, 0.9);
		nuvem7b.blend = DARKEN;
        add(nuvem7b);
        
        nuvem4 = new BGSprite('stages/sky/popstyle/sky/nuvem4', -500, -300);
        nuvem4.scrollFactor.set(0.902, 0.9);
		nuvem4.blend = DARKEN;
        add(nuvem4);

        nuvem4b = new BGSprite('stages/sky/popstyle/sky/nuvem4', nuvem4.x + nuvem4.width, nuvem4.y);
        nuvem4b.scrollFactor.set(0.904, 0.9);
		nuvem4b.blend = DARKEN;
        add(nuvem4b);
		
		nuvem8 = new BGSprite('stages/sky/popstyle/sky/nuvem8', -500, -300);
        nuvem8.scrollFactor.set(0.848, 0.9);
		nuvem8.blend = DARKEN;
        add(nuvem8);

        nuvem8b = new BGSprite('stages/sky/popstyle/sky/nuvem8', nuvem8.x + nuvem8.width, nuvem8.y);
        nuvem8b.scrollFactor.set(0.849, 0.9);
		nuvem8b.blend = DARKEN;
        add(nuvem8b);
        
        nuvem9 = new BGSprite('stages/sky/popstyle/sky/nuvem9', -500, -300);
        nuvem9.scrollFactor.set(0.85, 0.9);
		nuvem9.blend = DARKEN;
        add(nuvem9);

        nuvem9b = new BGSprite('stages/sky/popstyle/sky/nuvem9', nuvem9.x + nuvem9.width, nuvem9.y);
        nuvem9b.scrollFactor.set(0.851, 0.9);
		nuvem9b.blend = DARKEN;
        add(nuvem9b);
        
        nuvem0 = new BGSprite('stages/sky/popstyle/sky/nuvem0', -500, -300);
        nuvem0.scrollFactor.set(0.852, 0.9);
		nuvem0.blend = DARKEN;
        add(nuvem0);

        nuvem0b = new BGSprite('stages/sky/popstyle/sky/nuvem0', nuvem0.x + nuvem0.width, nuvem0.y);
        nuvem0b.scrollFactor.set(0.853, 0.9);
		nuvem0b.blend = DARKEN;
        add(nuvem0b);        
        
        nuvem1 = new BGSprite('stages/sky/popstyle/sky/nuvem1', -500, -300);
        nuvem1.scrollFactor.set(0.854, 0.9);
		nuvem1.blend = DARKEN;
        add(nuvem1);

        nuvem1b = new BGSprite('stages/sky/popstyle/sky/nuvem1', nuvem1.x + nuvem1.width, nuvem1.y);
        nuvem1b.scrollFactor.set(0.855, 0.9);
		nuvem1b.blend = DARKEN;
        add(nuvem1b);
             
        nuvem5 = new BGSprite('stages/sky/popstyle/sky/nuvem5', -500, -300);
        nuvem5.scrollFactor.set(0.856, 0.9);
		nuvem5.blend = DARKEN;
        add(nuvem5);

        nuvem5b = new BGSprite('stages/sky/popstyle/sky/nuvem5', nuvem5.x + nuvem5.width, nuvem5.y);
        nuvem5b.scrollFactor.set(0.857, 0.9);
		nuvem5b.blend = DARKEN;
        add(nuvem5b);

        nuvem6 = new BGSprite('stages/sky/popstyle/sky/nuvem6', -500, -300);
        nuvem6.scrollFactor.set(0.858, 0.9);
		nuvem6.blend = DARKEN;
        add(nuvem6);

        nuvem6b = new BGSprite('stages/sky/popstyle/sky/nuvem6', nuvem6.x + nuvem6.width, nuvem6.y);
        nuvem6b.scrollFactor.set(0.859, 0.9);
		nuvem6b.blend = DARKEN;
        add(nuvem6b);

		aviao = new BGSprite('stages/sky/popstyle/sky/aviao', 2000, -300);
        aviao.scrollFactor.set(0.86, 0.90);
		aviao.active = true;
		add(aviao);
		
        nuvem10 = new BGSprite('stages/sky/popstyle/sky/nuvem10', -500, -300);
        nuvem10.scrollFactor.set(0.86, 0.9);
		nuvem10.blend = DARKEN;
        add(nuvem10);

        nuvem10b = new BGSprite('stages/sky/popstyle/sky/nuvem10', nuvem10.x + nuvem10.width, nuvem10.y);
        nuvem10b.scrollFactor.set(0.861, 0.9);
		nuvem10b.blend = DARKEN;
        add(nuvem10b);

		layer1 = new BGSprite('stages/sky/popstyle/sky/layer1', -500, -300);
        layer1.scrollFactor.set(0.90, 0.90);
        add(layer1);

		layer1b = new BGSprite('stages/sky/popstyle/sky/layer1', layer1.x + layer1.width, layer1.y);
        layer1b.scrollFactor.set(0.87, 0.87);
        add(layer1b);
        
        casa = new FlxSprite(-500, -300);
		casa.frames = Paths.getSparrowAtlas('stages/sky/popstyle/sky/casa');
		casa.animation.addByPrefix("idle", "casa", 5, true);
		casa.animation.play('idle');
		casa.scrollFactor.set(0.95, 0.95);
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
    layer5.blend = DARKEN;
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

    nuvem0.x -= 20 * elapsed;
    nuvem0b.x -= 20 * elapsed;

    nuvem1.x -= 17 * elapsed;
    nuvem1b.x -= 17 * elapsed;

    nuvem2.x -= 19 * elapsed;
    nuvem2b.x -= 19 * elapsed;

    nuvem3.x -= 22 * elapsed;
    nuvem3b.x -= 22 * elapsed;

    nuvem4.x -= 13 * elapsed;
    nuvem4b.x -= 13 * elapsed;

    nuvem5.x -= 15 * elapsed;
    nuvem5b.x -= 15 * elapsed;

    nuvem6.x -= 16 * elapsed;
    nuvem6b.x -= 16 * elapsed;

    nuvem7.x -= 21.5 * elapsed;
    nuvem7b.x -= 21.5 * elapsed;
    
    nuvem8.x -= 14.5 * elapsed;
    nuvem8b.x -= 14.5 * elapsed;
    
    nuvem9.x -= 23 * elapsed;
    nuvem9b.x -= 23 * elapsed;
    
    nuvem10.x -= 24 * elapsed;
    nuvem10b.x -= 24 * elapsed;

	layer1.x -= 40 * elapsed;
    layer1b.x -= 40 * elapsed;
    
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

	if (layer1.x + layer1.width <= 0) layer1.x = layer1b.x + layer1b.width;
    if (layer1b.x + layer1b.width <= 0) layer1b.x = layer1.x + layer1.width;
	
    if (layer4.x + layer4.width <= 0) layer4.x = layer4b.x + layer4b.width;
    if (layer4b.x + layer4b.width <= 0) layer4b.x = layer4.x + layer4.width;
}

    var beatTween:FlxTween;
    override function beatHit()
    {
    if (FlxG.random.bool(10) && aviaoViajando)
			aviaoViaja();
	}

    override function closeSubState()
	{
		if(paused)
		{
			if(aviaoTimer != null) aviao.active = true;
		}
	}
	
	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			if(aviaoTimer != null) aviaoTimer.active = false;
		}
	}
	
	function resetAviao():Void
	{
		aviao.x = -12600;
		aviao.y = FlxG.random.int(140, 250);
		aviao.velocity.x = 0;
		aviaoViajando = true;
	}
	
	var aviaoTimer:FlxTimer;
	function aviaoViaja()
	{
		aviao.velocity.x = FlxG.random.int(52, 52);
		aviaoViajando = false;
		aviaoTimer = new FlxTimer().start(40, function(tmr:FlxTimer)
		{
			resetAviao();
			aviaoTimer = null;
		});
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
