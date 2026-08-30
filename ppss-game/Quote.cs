using Godot;
using System;

public partial class Quote : Control
{
	// Путь к сцене логотипа (intro_1.tscn)
	[Export(PropertyHint.File, "*.tscn,*.scn")]
	private string _nextScene = "res://intro_1.tscn";

	private RichTextLabel _label;
	private Timer _timer;
	private AudioStreamPlayer2D _audio;
	private int _letterCount = 0;

	private const float NormalSpeed = 0.03f;
	private bool _isFinished = false; // Защита от двойного перехода

	public override void _Ready()
	{
		_label = GetNode<RichTextLabel>("RichTextLabel");
		_timer = GetNode<Timer>("Timer");
		_audio = GetNode<AudioStreamPlayer2D>("AudioStreamPlayer2D");

		_label.VisibleCharacters = 0;

		_timer.WaitTime = NormalSpeed;
		_timer.Timeout += OnTimerTimeout;
		_timer.Start();
	}

	private async void OnTimerTimeout()
	{
		if (_label.VisibleCharacters < _label.GetTotalCharacterCount())
		{
			_label.VisibleCharacters += 1;
			_letterCount++;

			string currentText = _label.GetParsedText();
			char currentChar = currentText[_label.VisibleCharacters - 1];

			float nextDelay = NormalSpeed;

			if (currentChar == '.' || currentChar == '?' || currentChar == '!')
			{
				nextDelay = 0.4f; // Пауза на точке
			}
			else if (currentChar == ',' || currentChar == '-' || currentChar == ':')
			{
				nextDelay = 0.2f; // Пауза на запятой
			}
			else
			{
				nextDelay = NormalSpeed + (float)GD.RandRange(-0.01, 0.01);
			}

			_timer.WaitTime = MathMax(0.01f, nextDelay);

			if (currentChar != ' ' && currentChar != '\n' && currentChar != '\r')
			{
				if (_letterCount % 4 == 0)
				{
					_audio.PitchScale = (float)GD.RandRange(0.95, 1.05);
					_audio.Play();
				}
			}
		}
		else
		{
			// Текст полностью напечатался
			_timer.Stop();
			_timer.Timeout -= OnTimerTimeout;

			// Ждем ровно 3 секунды
			await ToSignal(GetTree().CreateTimer(3.0f), SceneTreeTimer.SignalName.Timeout);
			
			// Переходим на следующую сцену
			ChangeScene();
		}
	}

	// Пропуск заставки по нажатию клавиши или клику мыши
	public override void _UnhandledInput(InputEvent @event)
	{
		if ((@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed) || 
			(@event is InputEventKey keyEvent && keyEvent.Pressed))
		{
			ChangeScene();
		}
	}

	private void ChangeScene()
	{
		if (_isFinished) return;
		_isFinished = true;

		GetTree().ChangeSceneToFile(_nextScene);
	}

	private float MathMax(float a, float b)
	{
		return a > b ? a : b;
	}
}
