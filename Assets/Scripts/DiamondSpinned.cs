using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DiamondSpinned : MonoBehaviour
{
    [SerializeField] float rotateVelocity;


    // Update is called once per frame
    void Update()
    {
        transform.Rotate(rotateVelocity * Time.deltaTime * new Vector3(0, 1, 0));
    }
}
