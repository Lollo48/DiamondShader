using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotate : MonoBehaviour
{
    [SerializeField] float rotateVelocity;
    [SerializeField] GameObject cameraPivot;
    // Update is called once per frame
    void Update()
    {
        transform.RotateAround(cameraPivot.transform.position, new Vector3(0, 1, 0), rotateVelocity * Time.deltaTime);
    }
}
