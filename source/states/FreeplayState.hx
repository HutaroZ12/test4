package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import objects.HealthIcon;
import objects.MusicPlayer;

import options.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;

import openfl.utils.Assets;

import haxe.Json;

class FreeplayState extends MusicBeatState
{
    var songs:Array<SongMetadata> = [];

    var selector:FlxText;
    public static var curSelected:Int = 0;
    var lerpSelected:Float = 0;
    var curDifficulty:Int = -1;
    public static var lastDifficultyName:String = Difficulty.getDefault();

    var scoreBG:FlxSprite;
    var scoreText:FlxText;
    var diffText:FlxText;
    var lerpScore:Int = 0;
    var lerpRating:Float = 0;
    var intendedScore:Int = 0;
    var intendedRating:Float = 0;

    private var grpSongs:FlxTypedGroup<Alphabet>;
    private var curPlaying:Bool = false;

    private var iconArray:Array<HealthIcon> = [];

    var bg:FlxSprite;
    var intendedColor:Int;

    var missingTextBG:FlxSprite;
    var missingText:FlxText;

    var bottomString:String;
    var bottomText:FlxText;
    var bottomBG:FlxSprite;

    var player:MusicPlayer;

    public static var vocals:FlxSound = null;
    public static var opponentVocals:FlxSound = null;
    public var holdTime:Float = 0;
    public var stopMusicPlay:Bool = false;
    
    override function create()
    {
        persistentUpdate = true;
        PlayState.isStoryMode = false;
        WeekData.reloadWeekFiles(false);

        #if DISCORD_ALLOWED
        DiscordClient.changePresence("In the Menus", null);
        #end

        final accept:String = (controls.mobileC) ? "A" : "ACCEPT";
        final reject:String = (controls.mobileC) ? "B" : "BACK";

        if(WeekData.weeksList.length < 1)
        {
            FlxTransitionableState.skipNextTransIn = true;
            persistentUpdate = false;
            MusicBeatState.switchState(new states.ErrorState(
                "NO WEEKS ADDED FOR FREEPLAY\n\nPress " + accept + " to go to the Week Editor Menu.\nPress " + reject + " to return to Main Menu.",
                function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
                function() MusicBeatState.switchState(new states.MainMenuState())
            ));
            return;
        }

        for (i in 0...WeekData.weeksList.length)
        {
            if(weekIsLocked(WeekData.weeksList[i])) continue;

            var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
            for (song in leWeek.songs)
            {
                var colors:Array<Int> = song[2];
                if(colors == null || colors.length < 3) colors = [146, 113, 253];

                // Somente adicionar músicas que possuem a dificuldade "erect" se selecionada
                var hasErect:Bool = song.length > 3 && song[3] != null && song[3].indexOf("erect") >= 0;
                if(Difficulty.getString(curDifficulty, false) == "erect" && !hasErect) continue;

                addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
            }
        }

        Mods.loadTopMod();

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);
        bg.screenCenter();

        grpSongs = new FlxTypedGroup<Alphabet>();
        add(grpSongs);

        for (i in 0...songs.length)
        {
            var songText:Alphabet = new Alphabet(90, 320, songs[i].songName, true);
            songText.targetY = i;
            grpSongs.add(songText);

            songText.scaleX = Math.min(1, 980 / songText.width);
            songText.snapToPosition();

            Mods.currentModDirectory = songs[i].folder;
            var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
            icon.sprTracker = songText;

            songText.visible = songText.active = songText.isMenuItem = false;
            icon.visible = icon.active = false;

            iconArray.push(icon);
            add(icon);
        }

        WeekData.setDirectoryFromWeek();

        scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
        scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

        scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
        scoreBG.alpha = 0.6;
        add(scoreBG);

        diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
        diffText.font = scoreText.font;
        add(diffText);

        add(scoreText);

        missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        missingTextBG.alpha = 0.6;
        missingTextBG.visible = false;
        add(missingTextBG);

        missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
        missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        missingText.scrollFactor.set();
        missingText.visible = false;
        add(missingText);

        if(curSelected >= songs.length) curSelected = 0;
        bg.color = songs[curSelected].color;
        intendedColor = bg.color;
        lerpSelected = curSelected;

        curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

        bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
        bottomBG.alpha = 0.6;
        add(bottomBG);

        final space:String = (controls.mobileC) ? "X" : "SPACE";
        final control:String = (controls.mobileC) ? "C" : "CTRL";
        final reset:String = (controls.mobileC) ? "Y" : "RESET";

        bottomString = Language.getPhrase("freeplay_tip",
            "Press {1} to listen to the Song / Press {2} to open the Gameplay Changers Menu / Press {3} to Reset your Score and Accuracy.",
            [space, control, reset]
        );
        bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, bottomString, 16);
        bottomText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
        bottomText.scrollFactor.set();
        add(bottomText);

        player = new MusicPlayer(this);
        add(player);

        changeSelection();
        updateTexts();

        addTouchPad('LEFT_FULL', 'A_B_C_X_Y_Z');
        super.create();
    }
    
    override function update(elapsed:Float)
    {
        if(WeekData.weeksList.length < 1)
            return;

        if (FlxG.sound.music.volume < 0.7)
            FlxG.sound.music.volume += 0.5 * elapsed;

        lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
        lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 12));

        if (Math.abs(lerpScore - intendedScore) <= 10)
            lerpScore = intendedScore;
        if (Math.abs(lerpRating - intendedRating) <= 0.01)
            lerpRating = intendedRating;

        var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
        if(ratingSplit.length < 2) ratingSplit.push('');
        while(ratingSplit[1].length < 2) ratingSplit[1] += '0';

        var shiftMult:Int = 1;
        if((FlxG.keys.pressed.SHIFT || touchPad.buttonZ.pressed) && !player.playingMusic) shiftMult = 3;

        if (!player.playingMusic)
        {
            scoreText.text = Language.getPhrase('personal_best', 'PERSONAL BEST: {1} ({2}%)', [lerpScore, ratingSplit.join('.')]);
            positionHighscore();

            if(songs.length > 1)
            {
                if(FlxG.keys.justPressed.HOME)
                {
                    curSelected = 0;
                    changeSelection();
                    holdTime = 0;    
                }
                else if(FlxG.keys.justPressed.END)
                {
                    curSelected = songs.length - 1;
                    changeSelection();
                    holdTime = 0;    
                }
                if (controls.UI_UP_P)
                {
                    changeSelection(-shiftMult);
                    holdTime = 0;
                }
                if (controls.UI_DOWN_P)
                {
                    changeSelection(shiftMult);
                    holdTime = 0;
                }

                if(controls.UI_DOWN || controls.UI_UP)
                {
                    var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
                    holdTime += elapsed;
                    var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

                    if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
                        changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
                }

                if(FlxG.mouse.wheel != 0)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
                    changeSelection(-shiftMult * FlxG.mouse.wheel, false);
                }
            }

            if (controls.UI_LEFT_P)
            {
                changeDiff(-1);
                _updateSongLastDifficulty();
            }
            else if (controls.UI_RIGHT_P)
            {
                changeDiff(1);
                _updateSongLastDifficulty();
            }
        }

        if (controls.BACK)
        {
            if (player.playingMusic)
            {
                FlxG.sound.music.stop();
                destroyFreeplayVocals();
                FlxG.sound.music.volume = 0;
                instPlaying = -1;

                player.playingMusic = false;
                player.switchPlayMusic();

                FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
                FlxTween.tween(FlxG.sound.music, {volume: 1}, 1);
            }
            else 
            {
                persistentUpdate = false;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuState());
            }
        }

        if((FlxG.keys.justPressed.CONTROL || touchPad.buttonC.justPressed) && !player.playingMusic)
        {
            persistentUpdate = false;
            openSubState(new GameplayChangersSubstate());
            removeTouchPad();
        }
        else if(FlxG.keys.justPressed.SPACE || touchPad.buttonX.justPressed)
        {
            if(instPlaying != curSelected && !player.playingMusic)
            {
                destroyFreeplayVocals();
                FlxG.sound.music.volume = 0;

                Mods.currentModDirectory = songs[curSelected].folder;
                var songPath:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
                Song.loadFromJson(songPath, songs[curSelected].songName.toLowerCase());

                if (PlayState.SONG.needsVoices)
                {
                    vocals = new FlxSound();
                    try
                    {
                        var playerVocals:String = getVocalFromCharacter(PlayState.SONG.player1);
                        var loadedVocals = Paths.voices(PlayState.SONG.song, (playerVocals != null && playerVocals.length > 0) ? playerVocals : 'Player');
                        if(loadedVocals == null) loadedVocals = Paths.voices(PlayState.SONG.song);

                        if(loadedVocals != null && loadedVocals.length > 0)
                        {
                            vocals.loadEmbedded(loadedVocals);
                            FlxG.sound.list.add(vocals);
                            vocals.persist = vocals.looped = true;
                            vocals.volume = 0.8;
                            vocals.play();
                            vocals.pause();
                        }
                        else vocals = FlxDestroyUtil.destroy(vocals);
                    }
                    catch(e:Dynamic) { vocals = FlxDestroyUtil.destroy(vocals); }

                    opponentVocals = new FlxSound();
                    try
                    {
                        var oppVocals:String = getVocalFromCharacter(PlayState.SONG.player2);
                        var loadedOpp = Paths.voices(PlayState.SONG.song, (oppVocals != null && oppVocals.length > 0) ? oppVocals : 'Opponent');

                        if(loadedOpp != null && loadedOpp.length > 0)
                        {
                            opponentVocals.loadEmbedded(loadedOpp);
                            FlxG.sound.list.add(opponentVocals);
                            opponentVocals.persist = opponentVocals.looped = true;
                            opponentVocals.volume = 0.8;
                            opponentVocals.play();
                            opponentVocals.pause();
                        }
                        else opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
                    }
                    catch(e:Dynamic) { opponentVocals = FlxDestroyUtil.destroy(opponentVocals); }
                }

                FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.8);
                FlxG.sound.music.pause();
                instPlaying = curSelected;

                player.playingMusic = true;
                player.curTime = 0;
                player.switchPlayMusic();
                player.pauseOrResume(true);
            }
            else if (instPlaying == curSelected && player.playingMusic)
            {
                player.pauseOrResume(!player.playing);
            }
        }

        updateTexts(elapsed);
        super.update(elapsed);
    }
    
    function destroyFreeplayVocals()
    {
        if(vocals != null) vocals.stop();
        vocals = FlxDestroyUtil.destroy(vocals);

        if(opponentVocals != null) opponentVocals.stop();
        opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
    }

    function getVocalFromCharacter(charName:String):String
    {
        switch(charName.toLowerCase())
        {
            case "boyfriend": return "Player";
            case "dad": return "Opponent";
            default: return null;
        }
    }

    function changeDiff(direction:Int)
    {
        curDifficulty += direction;
        if(curDifficulty >= PlayState.SONG.difficulties.length) curDifficulty = 0;
        if(curDifficulty < 0) curDifficulty = PlayState.SONG.difficulties.length - 1;

        _updateSongLastDifficulty();
    }

    function _updateSongLastDifficulty()
    {
        // Atualiza o índice da última dificuldade para essa música
        lastDiff[curSelected] = curDifficulty;
    }

    function changeSelection(change:Int = 1, playSound:Bool = true)
    {
        if(songs.length < 1) return;

        curSelected += change;

        if(curSelected >= songs.length) curSelected = 0;
        if(curSelected < 0) curSelected = songs.length - 1;

        curDifficulty = lastDiff[curSelected];

        if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
        updateSongPreview();
    }

    function updateSongPreview()
    {
        if(instPlaying != curSelected)
        {
            destroyFreeplayVocals();
            FlxG.sound.music.volume = 0;

            FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0.8);
            FlxG.sound.music.pause();
        }

        songText.text = songs[curSelected].songName;
        artistText.text = songs[curSelected].artist;
    }

    function positionHighscore()
    {
        var highscore = Highscore.getHighscoreForSong(songs[curSelected].songName, curDifficulty);
        scoreText.text = Language.getPhrase('personal_best', 'PERSONAL BEST: {1} ({2}%)', [highscore.score, highscore.rating]);
    }
}
    
    class SongMetadata
{
    public var songName:String;
    public var week:Int;
    public var songCharacter:String;
    public var color:Int;
    public var folder:String;
    public var lastDifficulty:Int;

    public function new(songName:String, week:Int, songCharacter:String, color:Int)
    {
        this.songName = songName;
        this.week = week;
        this.songCharacter = songCharacter;
        this.color = color;
        this.folder = Mods.currentModDirectory != null ? Mods.currentModDirectory : "";
        this.lastDifficulty = 0;
    }
}

public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
{
    songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
}

public function weekIsLocked(name:String):Bool
{
    var leWeek:WeekData = WeekData.weeksLoaded.get(name);
    return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && 
        (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
}
