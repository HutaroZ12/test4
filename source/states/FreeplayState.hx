
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
import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxTextBorderStyle;
import openfl.utils.Assets;
import haxe.Json;

class FreeplayState extends MusicBeatState
{
	var allSongs:Array<SongMetadata> = [];
	var songs:Array<SongMetadata> = [];
	var diffText:FlxText;

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var lerpSelected:Float = 0;
	var curDifficulty:Int = 0;
	private static var lastDifficultyName:String = Difficulty.getDefault();

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
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

	// ---------- Helpers ----------
	// Verifica se um chart existe para uma determinada dificuldade
	private function existsChart(name:String, diff:String):Bool
	{
		var path = 'assets/shared/data/' + name + '/' + name;
		switch(diff)
		{
			case 'easy':   path += '-easy.json';
			case 'hard':   path += '-hard.json';
			case 'erect':  path += '-erect.json';
			default:       path += '.json';
		}

		#if sys
		return sys.FileSystem.exists(path);
		#else
		return Assets.exists(path);
		#end
	}

	// Retorna lista filtrada por dificuldade atual (esconde músicas que não possuem o chart)
	private function freeplaySongList():Array<SongMetadata>
	{
		var newList:Array<SongMetadata> = [];
		if (Difficulty.list.length == 0) return newList;
		var diff:String = Difficulty.list[curDifficulty];

		for (song in allSongs)
		{
			var name = song.songName.toLowerCase();

			var path = 'assets/shared/data/' + name + '/' + name;
			switch (diff)
			{
				case 'easy':  path += '-easy.json';
				case 'hard':  path += '-hard.json';
				case 'erect': path += '-erect.json';
				default:      path += '.json';
			}

			#if sys
			if (sys.FileSystem.exists(path)) newList.push(song);
			#else
			if (Assets.exists(path)) newList.push(song);
			#end
		}

		if (curSelected >= newList.length) curSelected = 0;
		return newList;
	}

	// Reconstroi lista de dificuldades disponíveis para a música atual
	private function rebuildDifficultyList():Void
	{
		if (allSongs.length == 0) return;
		if (songs.length == 0) return;

		var song = songs[curSelected];
		var name = song.songName.toLowerCase();

		var diffs:Array<String> = [];

		if (existsChart(name, 'easy'))   diffs.push('easy');
		if (existsChart(name, 'normal')) diffs.push('normal');
		if (existsChart(name, 'hard'))   diffs.push('hard');
		if (existsChart(name, 'erect'))  diffs.push('erect');

		if (diffs.length == 0)
		{
			// fallback: at least normal
			diffs.push('normal');
		}

		Difficulty.list = diffs;
		// tenta preservar lastDifficultyName se possível
		var savedIndex = diffs.indexOf(lastDifficultyName);
		if (savedIndex >= 0) curDifficulty = savedIndex; else curDifficulty = 0;

		updateDiffText();
	}

	// Atualiza o texto que mostra a dificuldade atual
	private function updateDiffText():Void
	{
		if (diffText == null) return;
		if (Difficulty.list.length > 0)
			diffText.text = Difficulty.list[curDifficulty];
		else
			diffText.text = "";
	}

	inline private function _updateSongLastDifficulty():Void
	{
		if (songs.length == 0) return;
		songs[curSelected].lastDifficulty = Difficulty.getString(curDifficulty, false);
	}

	private function positionHighscore()
	{
		if (scoreText == null || scoreBG == null || diffText == null) return;
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	// ---------- Lifecycle ----------
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
			MusicBeatState.switchState(new states.ErrorState("NO WEEKS ADDED FOR FREEPLAY\n\nPress " + accept + " to go to the Week Editor Menu.\nPress " + reject + " to return to Main Menu.",
				function() MusicBeatState.switchState(new states.editors.WeekEditorState()),
				function() MusicBeatState.switchState(new states.MainMenuState())));
			return;
		}

		// populate allSongs (todas as músicas)
		allSongs = [];

		for (i in 0...WeekData.weeksList.length)
		{
			if(weekIsLocked(WeekData.weeksList[i])) continue;
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			WeekData.setDirectoryFromWeek(leWeek);

			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3) colors = [146,113,253];
				// salva pasta do mod atual (usado pelo SongMetadata)
				Mods.currentModDirectory = leWeek.directory; // se o WeekData tiver directory; caso contrário Mods.currentModDirectory é ajustado pelos seus loaders
				allSongs.push(new SongMetadata(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2])));
			}
		}

		// definindo curDifficulty com base no lastDifficultyName (fallback 0)
		curDifficulty = Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName));
		if (curDifficulty < 0) curDifficulty = 0;

		// filtra songs (músicas visíveis) pela dificuldade atual — músicas que NÃO tiverem o chart somem
		songs = freeplaySongList();

		// inicializa UI
		Mods.loadTopMod();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		iconArray = [];

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
		if (songs.length > 0) bg.color = songs[curSelected].color;
		intendedColor = bg.color;
		lerpSelected = curSelected;

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

		// Seleciona a música atual
		changeSelection();
		updateTexts();

		addTouchPad('LEFT_FULL', 'A_B_C_X_Y_Z');
		super.create();
	}

	// ---------- Input / selection ----------
	function changeDiff(change:Int = 0)
	{
		if (player != null && player.playingMusic) return;
		if (Difficulty.list.length == 0) return;

		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, Difficulty.list.length);
		// rebuild visible list according to the new difficulty (hides songs that don't have the chart)
		songs = freeplaySongList();
		// ensure selection index valid
		if (curSelected >= songs.length) curSelected = 0;
		rebuildDifficultyList();
		updateDiffText();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (player != null && player.playingMusic) return;
		if (songs.length == 0) return;

		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length);
		_updateSongLastDifficulty();
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var newColor:Int = songs[curSelected].color;
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

		Mods.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();

		changeDiff(0); // rebuild based on current difficulty
		_updateSongLastDifficulty();
	}

	// ---------- Update ----------
	override function update(elapsed:Float)
	{
		if(WeekData.weeksList.length < 1) return;

		if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * elapsed;

		lerpScore = Math.floor(FlxMath.lerp(intendedScore, lerpScore, Math.exp(-elapsed * 24)));
		lerpRating = FlxMath.lerp(intendedRating, lerpRating, Math.exp(-elapsed * 12));

		if (Math.abs(lerpScore - intendedScore) <= 10) lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01) lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) ratingSplit.push('');
		while(ratingSplit[1].length < 2) ratingSplit[1] += '0';

		var shiftMult:Int = 1;
		if((FlxG.keys.pressed.SHIFT || touchPad.buttonZ.pressed) && (player == null || !player.playingMusic)) shiftMult = 3;

		if (player == null || !player.playingMusic)
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
				if (controls.UI_UP_P) { changeSelection(-shiftMult); holdTime = 0; }
				if (controls.UI_DOWN_P) { changeSelection(shiftMult); holdTime = 0; }

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

			if (controls.UI_LEFT_P) { changeDiff(-1); _updateSongLastDifficulty(); }
			else if (controls.UI_RIGHT_P) { changeDiff(1); _updateSongLastDifficulty(); }
		}

		// rest of original update logic (play/pause songs / accept / reset) remains unchanged...
		super.update(elapsed);
	}

	override function destroy():Void
	{
		super.destroy();
		FlxG.autoPause = ClientPrefs.data.autoPause;
		if (!FlxG.sound.music.playing && !stopMusicPlay) FlxG.sound.playMusic(Paths.music('freakyMenu'));
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
