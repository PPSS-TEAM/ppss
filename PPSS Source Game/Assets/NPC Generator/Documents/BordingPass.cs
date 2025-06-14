using UnityEngine;

[CreateAssetMenu(menuName = "Scriptable Objects/Document/Bording Pass")]
public class BordingPass : BaseDocument
{
    public int Number;

    public override DocumentType Type => DocumentType.BordingPass;
}
