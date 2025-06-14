using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NPCConfig", menuName = "Scriptable Objects/NPCConfig")]
public class NPCConfig : ScriptableObject
{
    [SerializeField] private string firstName;
    public string FirstName => firstName;

    [SerializeField] private string secondName;
    public string SecondName => secondName;

    [SerializeField] private DataFormat birthday = new DataFormat();
    public DataFormat Birthday => birthday;

    [SerializeField] private List<BaseDocument> documents = new List<BaseDocument>();
    public List<BaseDocument> Documents => documents;


    public void AddDocument(BaseDocument document) => documents.Add(document);

    public void Initialize(string firstName, string secondName, DataFormat birthday)
    {
        this.firstName = firstName;
        this.secondName = secondName;
        this.birthday = birthday;
    }
    
}
