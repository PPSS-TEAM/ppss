using UnityEngine;

[CreateAssetMenu(menuName = "Scriptable Objects/Document/Passport")]

public class Passport : BaseDocument
{
    public string FirstName;
    public string SecondName;
    public DataFormat Birthday;
    public override DocumentType Type => DocumentType.Passport;
}
