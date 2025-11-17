package states;

import backend.WeekData; import backend.Highscore; import backend.Song;

import objects.HealthIcon; import objects.MusicPlayer;

import options.GameplayChangersSubstate; import substates.ResetScoreSubState;

import flixel.math.FlxMath; import flixel.util.FlxDestroyUtil;

import openfl.utils.Assets; import sys.FileSystem; import sys.io.File;

import haxe.Json;

class FreeplayState extends MusicBeatState { var songs:Array<SongMetadata> = [];

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

// Ativa o filtro Erect — mantido true para que a seleção e visual funcionem automaticamente
public static var allowErect:Bool = true;

// Checa se existe o arquivo <song>-erect.json dentro de assets/shared/data/<song>/
private function songHasErect(songName:String):Bool {
	try {
		var path = 'assets/shared/data/' + songName + '/' + songName + '-erect.json';
		// Primeiro tenta FileSystem (build nativo/mods), se não, usa Assets.exists como fallback
		#if (MODS_ALLOWED)
			// Constrói caminho real via Paths.getPath se necessário
			var realPath = Paths.getPath('data/' + songName + '/' + songName + '-erect.json', TEXT);
			return FileSystem.exists(realPath);
		#else
			return Assets.exists(path, null);
		#end
	} catch(e:Dynamic) {
		return false;
	}
}

// Retorna true se a dificuldade atual for Erect (ignora case)
private function isErectMode():Bool {
	try {
		return Difficulty.getString(curDifficulty, false).toLowerCase() == 'erect';
	} catch(e:Dynamic) {
		return false;
	}
}

override function create()
{
	//Paths.clearStoredMemory();
	//Paths.clearUnusedMemory();
	
	persistentUpdate = true;
	PlayState.isStoryMode = false;
	WeekData.reloadWeekFiles(false);

	#if DISCORD_ALLOWED
	// Updating Discord Rich Presence
	DiscordClient.changePresence("In the Menus", null);
	#end

	final accept:String = (controls.mobileC) ? "A" : "ACCEPT";
	final reject:String = (controls.mobileC) ? "B" : "BACK";

	if(WeekData.weeksList.length < 1)
	{
		FlxTransitionableState.skipNextTransIn = true;
		persistentUpdate = false;
		MusicBeatState.switchState(new states.ErrorState("NO WEEKS ADDED FOR FREEPLAY\n\nPress " + accept + " to go to the Week Editor Menu.\nPress " + reject + " to return to Main Menu.",
			function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
			function() MusicBeatState.switchState(new states.MainMenuState())));
		return;
	}

	for (i in 0...WeekData.weeksList.length)
	{
		if(weekIsLocked(WeekData.weeksList[i])) continue;

		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
		var leSongs:Array<String> = [];
		var leChars:Array<String> = [];

		for (j in 0...leWeek.songs.length)
		{
			leSongs.push(leWeek.songs[j][0]);
			leChars.push(leWeek.songs[j][1]);
		}

		WeekData.setDirectoryFromWeek(leWeek);
		for (song in leWeek.songs)
		{
			var colors:Array<Int> = song[2];
			if(colors == null || colors.length < 3)
			{
				colors = [146, 113, 253];
			}
			addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
		}
	}
	Mods.loadTopMod();

	// --- Após popular songs[], determina hasErect para cada música (usando assets/shared/data path)
	for (i in 0...songs.length) {
		songs[i].hasErect = !allowErect || songHasErect(songs[i].songName);
	}

	// Se "Erect" não estiver presente em Difficulty.list, adiciona no final (caso você queira a seleção por <- ->)
	if (!Difficulty.list.contains('Erect'))
	{
		Difficulty.list.push('Erect');
	}

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

		// Ajusta visuais se não tiver Erect quando o filtro estiver ativo
		if (allowErect && !songs[i].hasErect)
		{
			songText.alpha = 0.35;
			songText.active = false;
		}
		else
		{
			songText.alpha = 1;
			songText.active = true;
		}

		icon.visible = icon.active = false;

		// using a FlxGroup is too much fuss!
		iconArray.push(icon);
		add(icon);

		// songText.visible = songText.active = songText.isMenuItem = false;
		// mantemos a visibilidade inicial como no original
		songText.visible = songText.active = songText.isMenuItem = false;
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
	
	var leText:String = Language.getPhrase("freeplay_tip", "Press {1} to listen to the Song / Press {2} to open the Gameplay Changers Menu / Press {3} to Reset your Score and Accuracy.", [space, control, reset]);
	bottomString = leText;
	var size:Int = 16;
	bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, leText, size);
	bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER);
	bottomText.scrollFactor.set();
	add(bottomText);
	
	player = new MusicPlayer(this);
	add(player);
	
	changeSelection();
	updateTexts();

	// Ajusta visibilidade inicial com base na dificuldade inicial
	updateErectVisibility();

	addTouchPad('LEFT_FULL', 'A_B_C_X_Y_Z');
	super.create();
}

override function closeSubState()
{
	changeSelection(0, false);
	persistentUpdate = true;
	super.closeSubState();
	removeTouchPad();
	addTouchPad('LEFT_FULL', 'A_B_C_X_Y_Z');
}

public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
{
	songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
}

function weekIsLocked(name:String):Bool
{
	var leWeek:WeekData = WeekData.weeksLoaded.get(name);
	return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
}

var instPlaying:Int = -1;
public static var vocals:FlxSound = null;
public static var opponentVocals:FlxSound = null;
var holdTime:Float = 0;

var stopMusicPlay:Bool = false;
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
	if(ratingSplit.length < 2) //No decimals, add an empty space
		ratingSplit.push('');
	
	while(ratingSplit[1].length < 2) //Less than 2 decimals in it, add decimals then
		ratingSplit[1] += '0';

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
		}
	}
}
