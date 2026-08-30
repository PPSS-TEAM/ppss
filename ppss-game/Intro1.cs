using Godot;
using System;

public partial class Intro1 : Control
{
	
	[Export(PropertyHint.File, "*.tscn,*.scn")]
	private string _mainMenuScene = "res://mainmenu.tscn";

	private AnimationPlayer _animPlayer;
	private bool _isFinished = false;

	public override void _Ready()
	{
		_animPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		
		_animPlayer.AnimationFinished += OnAnimationFinished;

		_animPlayer.Play("Logo");
	}

	private void OnAnimationFinished(StringName animName)
	{
		if (animName == "Logo")
		{
			GoToMenu();
		}
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if ((@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed) || 
			(@event is InputEventKey keyEvent && keyEvent.Pressed))
		{
			GoToMenu();
		}
	}

	private void GoToMenu()
	{
		if (_isFinished) return;
		_isFinished = true;

		_animPlayer.AnimationFinished -= OnAnimationFinished;
		GetTree().ChangeSceneToFile(_mainMenuScene);
	}
}
