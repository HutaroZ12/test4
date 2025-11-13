package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.Difficulty;

import objects.HealthIcon;
import objects.MusicPlayer;
import options.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;

#if sys
import sys.FileSystem;
#end

import haxe.Json;
import openfl.utils.Assets;

class FreeplayState extends MusicBeatState
{
	public var songs:Array<SongMetadata> = [];
	public var grpSongs:FlxTypedGroup<Alphabet>;
	public var iconArray:Array<HealthIcon> = [];

	public static var curSelected:Int = 0;
	public var curDifficulty:Int = 0;
	public static var lastDifficultyName:String = Difficulty.getDefault();

	public var diffText:FlxText;
	public var scoreText:FlxText;
	public var bg:FlxSprite;
	public var player:MusicPlayer;
	public var intendedScore:Int = 0;

	override function create()
	{
		super.create();
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		// 🔹 Carrega as músicas das semanas
		for (i in 0...WeekData.weeksList.length)
		{
			if (weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3)
					colors = [146, 113, 253];
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = songs[0].color;
		bg.antialiasing = true;
		bg.screenCenter();
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText = new Alphabet(90, 320, songs[i].songName, true);
			songText.targetY = i;
			songText.scaleX = Math.min(1, 980 / songText.width);
			songText.snapToPosition();
			grpSongs.add(songText);

			var icon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		add(scoreText);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		player = new MusicPlayer(this);
		add(player);

		curDifficulty = Math.max(0, Difficulty.list.indexOf(lastDifficultyName));
		updateDiffText();
		updateSongList();

		changeSelection();
	}

	public function addSong(songName:String, weekNum:Int, songChar:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songChar, color));
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 &&
			(!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) ||
			!StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_P) changeSelection(-1);
		if (controls.UI_DOWN_P) changeSelection(1);

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.ACCEPT)
			loadSong();
		if (controls.BACK)
			MusicBeatState.switchState(new MainMenuState());
	}

	function loadSong()
	{
		var songLower = Paths.formatToSongPath(songs[curSelected].songName);
		var poop = Highscore.formatSong(songLower, curDifficulty);
		Song.loadFromJson(poop, songLower);
		PlayState.storyDifficulty = curDifficulty;
		PlayState.isStoryMode = false;
		LoadingState.loadAndSwitchState(new PlayState());
	}

	public function changeDiff(change:Int = 0)
	{
		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, Difficulty.list.length - 1);
		updateDiffText();
		updateSongList();
	}

	function updateDiffText()
	{
		var name = Difficulty.getString(curDifficulty);
		if (Difficulty.list.length > 1)
			diffText.text = '< ' + name.toUpperCase() + ' >';
		else
			diffText.text = name.toUpperCase();
	}

	function updateSongList()
	{
		var currentDiff = Difficulty.getString(curDifficulty, false).toLowerCase();
		var filtered:Array<SongMetadata> = [];

		for (song in songs)
		{
			var songPath = Paths.formatToSongPath(song.songName);
			var jsonPath = 'assets/data/' + songPath + '/' + songPath + '-' + currentDiff + '.json';

			#if sys
			if (FileSystem.exists(jsonPath))
				filtered.push(song);
			#else
			if (Assets.exists(jsonPath))
				filtered.push(song);
			#end
		}

		if (filtered.length > 0)
			songs = filtered;
		else
			trace('Nenhuma música tem a dificuldade ' + currentDiff + ', mantendo todas.');
		curSelected = 0;
		changeSelection(0, false);
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
		var song = songs[curSelected];
		bg.color = song.color;
		scoreText.text = 'SCORE: ' + Highscore.getScore(song.songName, curDifficulty);
		if (playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
	}
}
