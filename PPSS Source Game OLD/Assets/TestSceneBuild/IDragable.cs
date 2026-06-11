using UnityEngine;
using static UnityEditor.PlayerSettings;

public class IDragable : MonoBehaviour
{
    [SerializeField] private float maxX;
    [SerializeField] private float minX;
    [SerializeField] private float maxY;
    [SerializeField] private float minY;
    private bool dragging = false;
    private Vector3 offset;
    private Rigidbody2D _rb;

    private void Start()
    {
        _rb = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        if (dragging)
        {
            // Move object, taking into account original offset.
            transform.position = Camera.main.ScreenToWorldPoint(Input.mousePosition) + offset;
        }
        Vector3 newPos = transform.position;
        newPos.x = Mathf.Clamp(transform.position.x, minX, maxX);
        newPos.y = Mathf.Clamp(transform.position.y, minY, maxY);
        transform.position = newPos;
    }

    private void OnMouseDown()
    {
        // Record the difference between the objects centre, and the clicked point on the camera plane.
        offset = transform.position - Camera.main.ScreenToWorldPoint(Input.mousePosition);
        _rb.bodyType = RigidbodyType2D.Kinematic;
        _rb.linearVelocity = Vector3.zero;
        dragging = true;
    }

    private void OnMouseUp()
    {
        // Stop dragging.
        _rb.bodyType = RigidbodyType2D.Dynamic;
        dragging = false;
    }
}
