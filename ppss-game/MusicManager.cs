using Godot;

public partial class MusicManager : Node
{
	public static MusicManager Instance { get; private set; }
	private AudioStreamPlayer _audioPlayer;

	public override void _Ready()
	{
		Instance = this;
		_audioPlayer = new AudioStreamPlayer();
		AddChild(_audioPlayer);
	}

	public void PlayMusic(AudioStream stream)
	{
		if (_audioPlayer.Stream == stream && _audioPlayer.Playing)
			return;

		_audioPlayer.Stream = stream;
		_audioPlayer.Play();
	}

	public void StopMusic()
	{
		_audioPlayer.Stop();
	}
}
