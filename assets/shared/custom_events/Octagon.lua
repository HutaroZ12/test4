local width = 0 

function onCreate()

    makeLuaSprite('barO','',0, 150)
    makeGraphic('barO',1280, 500,'FF8F00')
    addLuaSprite('barO', false)
    setScrollFactor('barO',0,0)
    setObjectCamera('barO','hud')

    makeLuaSprite('barw','',0,70)
    makeGraphic('barw',1280,190,'FFFFFF')
    addLuaSprite('barw', false)
    setScrollFactor('barw',0,0)
    setObjectCamera('barw','hud')

    makeLuaSprite('barb','',0, 470)
    makeGraphic('barb',1280,190,'FFFFFF')
    addLuaSprite('barb', false)
    setScrollFactor('barb',0,0)
    setObjectCamera('barb','hud')

    makeAnimatedLuaSprite('huant', 'skatepark/octagon/huant', -100, -80);
    addAnimationByPrefix('huant', 'idle', 'huant Move 1', 24, true); 
    addAnimationByPrefix('huant', 'last', 'huant Last Frame', 24, true); 
    scaleObject('huant', 1.4, 1.4);
    luaSpritePlayAnimation('huant', 'idle'); 
    setObjectCamera('huant','hud')
    addLuaSprite('huant', false);

    makeLuaSprite('textbox', 'skatepark/octagon/textbox', 510, 160);
    setObjectCamera('textbox','hud')
    scaleObject('textbox', 1.1, 1.1);  
    addLuaSprite('textbox', false);    

    makeLuaSprite('octagon', 'skatepark/octagon/octagon', 880, 390);
    setObjectCamera('octagon','hud')
    scaleObject('octagon', 0.7, 0.7);  
    addLuaSprite('octagon', false);   

    makeLuaSprite('hereletme', 'skatepark/octagon/hereletme', 20, 280);
    setObjectCamera('hereletme','hud')
    scaleObject('hereletme', 0.7, 0.7);  
    addLuaSprite('hereletme', false); 

    makeLuaSprite('showyou', 'skatepark/octagon/showyou', 950, 290);
    setObjectCamera('showyou','hud')
    scaleObject('showyou', 0.7, 0.7);  
    addLuaSprite('showyou', false); 

    makeLuaSprite('bartop','',0,-30)
    makeGraphic('bartop',1280,100,'000000')
    addLuaSprite('bartop',false)
    setObjectCamera('bartop','hud')
    setScrollFactor('bartop',0,0)

    makeLuaSprite('barbot','',0,650)
    makeGraphic('barbot',1280,100,'000000')
    addLuaSprite('barbot',false)
    setScrollFactor('barbot',0,0)
    setObjectCamera('barbot','hud')

    setProperty('barw.alpha', 0); 
    setProperty('barO.alpha', 0); 
    setProperty('barb.alpha', 0); 
    setProperty('huant.alpha', 0); 
    setProperty('textbox.alpha', 0); 
    setProperty('text.alpha', 0); 
    setProperty('octagon.alpha', 0); 
    setProperty('hereletme.alpha', 0); 
    setProperty('showyou.alpha', 0); 
    precacheImage('skatepark/octagon/text');
end    

function onEvent(name, value1, value2)
if name == "Sugarcrush Octagon Cutscene" then
makeAnimatedLuaSprite('text', 'skatepark/octagon/text', 585, 220);
addAnimationByPrefix('text', 'text', 'text', 24, true); 
addAnimationByPrefix('text', 'text', 'texto', 24, false); 
scaleObject('text', 0.4, 0.4);
setObjectCamera('text','hud')
addLuaSprite('text', false);
luaSpritePlayAnimation('text', 'text');       
setProperty('barw.alpha', 1); 
setProperty('barO.alpha', 1); 
setProperty('barb.alpha', 1); 
setProperty('huant.alpha', 1); 
setProperty('textbox.alpha', 1); 
setProperty('text.alpha', 1); 
setProperty('octagon.alpha', 1); 
runTimer('prefin', 11);
runTimer('fin', 13);    
end
end

function onTimerCompleted(tag, loops, loopsleft)
if tag == 'prefin' then
setProperty('hereletme.alpha', 1); 
setProperty('showyou.alpha', 1);    
setProperty('huant.y', 200);     
luaSpritePlayAnimation('huant', 'last');     
doTweenX('huant', 'huant', 450, 0.7, 'linear');     
doTweenX('text', 'text', 1500, 0.7, 'linear'); 
doTweenX('octagon', 'octagon', 1500, 0.7, 'linear'); 
doTweenX('textbox', 'textbox', 1500, 0.7, 'linear'); 
end
if tag == 'fin' then
setProperty('Flash2.alpha', 1);
doTweenAlpha('tweenCutOffAlpha', 'Flash2', 0, 0.5, 'linear');
setObjectCamera('Flash2', 'other');   
removeLuaSprite('barw', true);
removeLuaSprite('barO', true);
removeLuaSprite('barb', true);
removeLuaSprite('huant', true);
removeLuaSprite('textbox', true);
removeLuaSprite('text', true);
removeLuaSprite('huant', true);
removeLuaSprite('textbox', true);
removeLuaSprite('octagon', true);
removeLuaSprite('hereletme', true);
removeLuaSprite('showyou', true);
end
end