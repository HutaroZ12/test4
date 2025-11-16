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
    var visibleSongs:Array<SongMetadata> = []; // NOVO: músicas filtradas por dificuldade
    var selector:FlxText;
    private static var curSelected:Int = 0;
    var lerpSelected:Float = 0;
    var curDifficulty:Int = -1;
    private static var lastDifficultyName:String = Difficulty.getDefault();

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

    // --- NOVO: Funções para filtro "erect" ---
    public function applyDifficultyFilter(difficulty:String):Void {
        visibleSongs = new Array<SongMetadata>();

        for (song in songs) {
            if (hasDifficulty(song, difficulty)) {
                visibleSongs.push(song);
            }
        }

        if (visibleSongs.length > 0) {
            if (!visibleSongs.contains(songs[curSelected])) {
                curSelected = 0;
            }
        } else {
            trace("Nenhuma música disponível para a dificuldade: " + difficulty);
            curSelected = 0;
        }

        updateTexts();
        if(visibleSongs.length > 0) {
            bg.color = visibleSongs[curSelected].color;
            intendedColor = bg.color;
        }
    }

    public function hasDifficulty(song:SongMetadata, difficulty:String):Bool {
        var songPath:String = Paths.formatToSongPath(song.songName);
        #if MODS_ALLOWED
        try {
            var json:Dynamic = Json.parse(File.getContent('data/' + songPath + '/' + difficulty + '.json'));
            return json != null;
        } catch(e:Dynamic) { return false; }
        #else
        try {
            var json:Dynamic = Json.parse(Assets.getText('data/' + songPath + '/' + difficulty + '.json'));
            return json != null;
        } catch(e:Dynamic) { return false; }
        #end
    }
    
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

        // --- Carrega músicas normalmente ---
        for (i in 0...WeekData.weeksList.length)
        {
            if(weekIsLocked(WeekData.weeksList[i])) continue;

            var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);

            WeekData.setDirectoryFromWeek(leWeek);
            for (song in leWeek.songs)
            {
                var colors:Array<Int> = song[2];
                if(colors == null || colors.length < 3) colors = [146,113,253];
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

        missingText = new FlxText(50, 0, FlxG.width-100, '', 24);
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

        var leText:String = Language.getPhrase("freeplay_tip", 
            "Press {1} to listen to the Song / Press {2} to open the Gameplay Changers Menu / Press {3} to Reset your Score and Accuracy.", 
            [space, control, reset]);
        bottomString = leText;
        var size:Int = 16;
        bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, leText, size);
        bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER);
        bottomText.scrollFactor.set();
        add(bottomText);

        player = new MusicPlayer(this);
        add(player);

        // --- NOVO: aplica filtro de dificuldade logo no início ---
        applyDifficultyFilter(Difficulty.getString(curDifficulty));

        changeSelection();
        updateTexts();

        addTouchPad('LEFT_FULL', 'A_B_C_X_Y_Z');
        super.create();
    }
    
    function changeDiff(change:Int = 0)
{
    if (player.playingMusic)
        return;

    // Atualiza índice de dificuldade
    curDifficulty = FlxMath.wrap(curDifficulty + change, 0, Difficulty.list.length-1);
    lastDifficultyName = Difficulty.getString(curDifficulty, false);

    // Atualiza UI do texto da dificuldade
    var displayDiff:String = Difficulty.getString(curDifficulty);
    if (Difficulty.list.length > 1)
        diffText.text = '< ' + displayDiff.toUpperCase() + ' >';
    else
        diffText.text = displayDiff.toUpperCase();

    // Aplica filtro para atualizar músicas visíveis
    applyDifficultyFilter(displayDiff);

    // Atualiza Highscore e textos
    if(visibleSongs.length > 0) {
        intendedScore = Highscore.getScore(visibleSongs[curSelected].songName, curDifficulty);
        intendedRating = Highscore.getRating(visibleSongs[curSelected].songName, curDifficulty);
    }

    positionHighscore();
    missingText.visible = false;
    missingTextBG.visible = false;
}

function changeSelection(change:Int = 0, playSound:Bool = true)
{
    if (player.playingMusic)
        return;

    if(visibleSongs.length == 0)
        return; // Nada para selecionar

    // Atualiza índice da música visível
    curSelected = FlxMath.wrap(curSelected + change, 0, visibleSongs.length - 1);

    _updateSongLastDifficulty();

    if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

    var newColor:Int = visibleSongs[curSelected].color;
    if(newColor != intendedColor)
    {
        intendedColor = newColor;
        FlxTween.cancelTweensOf(bg);
        FlxTween.color(bg, 1, bg.color, intendedColor);
    }

    for (num => item in grpSongs.members)
    {
        var icon:HealthIcon = iconArray[num];
        item.alpha = 0.6;
        icon.alpha = 0.6;
        if (item.targetY == curSelected)
        {
            item.alpha = 1;
            icon.alpha = 1;
        }
    }

    Mods.currentModDirectory = visibleSongs[curSelected].folder;
    PlayState.storyWeek = visibleSongs[curSelected].week;
    Difficulty.loadFromWeek();

    var savedDiff:String = visibleSongs[curSelected].lastDifficulty;
    var lastDiff:Int = Difficulty.list.indexOf(lastDifficultyName);
    if(savedDiff != null && !Difficulty.list.contains(savedDiff) && Difficulty.list.contains(savedDiff))
        curDifficulty = Math.round(Math.max(0, Difficulty.list.indexOf(savedDiff)));
    else if(lastDiff > -1)
        curDifficulty = lastDiff;
    else if(Difficulty.list.contains(Difficulty.getDefault()))
        curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getDefault())));
    else
        curDifficulty = 0;

    changeDiff();
    _updateSongLastDifficulty();
}

inline private function _updateSongLastDifficulty()
    if(visibleSongs.length > 0)
        visibleSongs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty, false);
        
       var _drawDistance:Int = 4;
var _lastVisibles:Array<Int> = [];

public function updateTexts(elapsed:Float = 0.0)
{
    lerpSelected = FlxMath.lerp(curSelected, lerpSelected, Math.exp(-elapsed * 9.6));

    for (i in _lastVisibles)
    {
        grpSongs.members[i].visible = grpSongs.members[i].active = false;
        iconArray[i].visible = iconArray[i].active = false;
    }

    _lastVisibles = [];

    if(visibleSongs.length == 0) return;

    var min:Int = Math.round(Math.max(0, Math.min(visibleSongs.length, lerpSelected - _drawDistance)));
    var max:Int = Math.round(Math.max(0, Math.min(visibleSongs.length, lerpSelected + _drawDistance)));

    for (i in min...max)
    {
        var item:Alphabet = grpSongs.members[i];
        item.visible = item.active = true;
        item.x = ((item.targetY - lerpSelected) * item.distancePerItem.x) + item.startPosition.x;
        item.y = ((item.targetY - lerpSelected) * 1.3 * item.distancePerItem.y) + item.startPosition.y;

        var icon:HealthIcon = iconArray[i];
        icon.visible = icon.active = true;
        _lastVisibles.push(i);
    }
}

override function destroy():Void
{
    super.destroy();

    FlxG.autoPause = ClientPrefs.data.autoPause;
    if (!FlxG.sound.music.playing && !stopMusicPlay)
        FlxG.sound.playMusic(Paths.music('freakyMenu'));
}

// Função auxiliar: destruir vocais
public static function destroyFreeplayVocals() {
    if(vocals != null) vocals.stop();
    vocals = FlxDestroyUtil.destroy(vocals);

    if(opponentVocals != null) opponentVocals.stop();
    opponentVocals = FlxDestroyUtil.destroy(opponentVocals);
     }
}

class SongMetadata
{
    public var songName:String = "";
    public var week:Int = 0;
    public var songCharacter:String = "";
    public var color:Int = -7179779;
    public var folder:String = "";
    public var lastDifficulty:String = null;

    public function new(song:String, week:Int, songCharacter:String, color:Int)
    {
        this.songName = song;
        this.week = week;
        this.songCharacter = songCharacter;
        this.color = color;

        this.folder = Mods.currentModDirectory;
        if(this.folder == null) this.folder = '';
    }
}

