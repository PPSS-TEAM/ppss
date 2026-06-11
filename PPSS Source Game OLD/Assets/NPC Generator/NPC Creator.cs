using System.Collections.Generic;
using UnityEngine;

public class NPCCreator : MonoBehaviour
{
    [SerializeField] private NPCConfig config;

    [SerializeField][Range(0,1)] private float chanceDoc = 1f;
    [SerializeField][Range(0, 1)] private float chanceCorrectDoc = 1f;

    [SerializeField] private List<BaseDocument> templateDocuments = new List<BaseDocument>();

    [SerializeField] private DataFormat minData;
    [SerializeField] private DataFormat maxData;

    [SerializeField] private TextAsset firstNames;
    [SerializeField] private TextAsset secondNames;

    public void LoadConfig()
    {
        if (config != null)
        {
            Debug.Log($"Имя: {config.FirstName}\nФамилия: {config.SecondName}\nДата рождений:" +
                $" {config.Birthday}");
            Debug.Log($"Данные документов:\n");
            for (int i = 0; i < config.Documents.Count; i++)
            {
                ProcessDocument(config.Documents[i]);
            }
        }
        else Debug.LogError("No config file.");
    }

    public void CreateConfig()
    {
        NPCConfig config = new NPCConfig();
        config.Initialize(GetRandomName(firstNames), GetRandomName(secondNames), GetRandomData());

        Passport passport = new Passport();
        FillDocument(config, passport);

        config.AddDocument(passport);
        this.config = config;

        Debug.Log($"Config succesfully created: {config}");
    }

    private DataFormat GetRandomData()
    {
        DataFormat dataFormat = new DataFormat();

        dataFormat.day = Random.Range(minData.day, maxData.day);
        dataFormat.month = Random.Range(minData.month, maxData.month);
        dataFormat.year = Random.Range(minData.year, maxData.year);

        return dataFormat;
    }

    private string GetRandomName(TextAsset file)
    {
        string[] lines = file.text.Split('\n');
        string line = lines[Random.Range(0, lines.Length - 1)];
        return line[..^1];
    }

    private void FillDocument(NPCConfig config, BaseDocument doc) // Maybe i need use this
    {
        if (doc is Passport passport)
        {
            passport.FirstName = config.FirstName;
            passport.SecondName = config.SecondName;
            passport.Birthday = config.Birthday;
        }
    }

    private void ProcessDocument(BaseDocument doc)
    {
        if (doc is Passport passport)
        {
            Debug.Log("Паспорт:\n");
            Debug.Log($"Имя: {passport.FirstName}\nФамилия: {passport.SecondName}\nРодился:{passport.Birthday.day}." +
                $"{passport.Birthday.month}.{passport.Birthday.year}");
        }
        if (doc is BordingPass bordingPass)
        {
            Debug.Log("Посадочный талон:\n");
            Debug.Log($"Номер: {bordingPass.Number}");
        }
    }
}
