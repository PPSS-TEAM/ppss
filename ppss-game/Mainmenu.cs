using Godot;
using System;

public partial class Mainmenu : Control
{
	public override void _Ready()
	{
		GD.Print("Гитлер воскрес!");
	
	}

	private void _OnPlayButtonPressed()
	{
		GD.Print("нихуя.");
	}

	private void _OnExitButtonPressed()
	{
		GetTree().Quit();
	}

	private async void _on_useless_button_pressed()
	{
		GD.Print("хуй");
		
		await System.Threading.Tasks.Task.Delay(200);

		GD.Print("Пошёл нахуй.");
		GetTree().Quit();
	}
	
	private void _on_appeal_button_pressed()
	{
		GD.Print("обра");
		string appealUrl = "https://t.me/appealppss/3";
		OS.ShellOpen(appealUrl);
	}
}
