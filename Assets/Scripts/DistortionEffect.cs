using UnityEngine;

[ExecuteInEditMode]
public class DistortionEffect : MonoBehaviour {

    #region Properties

    public Shader shader;
    public float texelSize = 1f;

    [Space(10f)]

    [SerializeField] [Range(0.0f, 0.03125f)] [Tooltip("Radians angle distortion")]
    private float distortion;
    [SerializeField]
    private float distortionVelocity;

    //Hidden
    private float lastTexelSize;
    private float lastDistortion;
    private float lastDistortionVelocity;

    private Material mainMaterial;
    private Material MainMaterial
    {
        get
        {
            if (mainMaterial != null)
            {
                return mainMaterial;
            }
            else
            {
                mainMaterial = new Material(shader);
                mainMaterial.hideFlags = HideFlags.HideAndDontSave;
            }

            return mainMaterial;
        }
    }

    #endregion

    #region Unity Functions

    private void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if(!shader || !shader.isSupported)
        {
            enabled = false;
            return;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (lastTexelSize != texelSize)
            MainMaterial.SetFloat("_TexelSize", texelSize);

        if (lastDistortion != distortion)
            MainMaterial.SetFloat("_Distortion", distortion);

        if (lastDistortionVelocity != distortionVelocity)
            MainMaterial.SetFloat("_DistortionVelocity", distortionVelocity);

        Graphics.Blit(source, destination, MainMaterial);

        lastTexelSize = texelSize;

        lastDistortion = distortion;
        lastDistortionVelocity = distortionVelocity;
    }

    private void OnDisable()
    {
        if (mainMaterial != null)
            DestroyImmediate(mainMaterial);
    }

    #endregion
}
