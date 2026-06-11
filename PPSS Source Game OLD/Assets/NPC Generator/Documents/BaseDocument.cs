using UnityEngine;

public enum DocumentType
{
    None,
    Passport,
    BordingPass,
}
public abstract class BaseDocument : ScriptableObject
{
    public abstract DocumentType Type { get; }

    public virtual void Initialize() { }
}