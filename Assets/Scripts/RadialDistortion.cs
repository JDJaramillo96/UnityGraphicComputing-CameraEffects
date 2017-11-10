using UnityEngine;

[ExecuteInEditMode]
public class RadialDistortion : MonoBehaviour {

    #region Properties

    public Shader shader;
    public float texelSize = 1f;

    [Space(10f)]

    [SerializeField]
    private Texture monitorLine;

    //Hidden
    private float lastTexelSize;

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

        SetupDistortedImageEffect();
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (lastTexelSize != texelSize)
            MainMaterial.SetFloat("_TexelSize", texelSize);

        Graphics.Blit(source, destination, MainMaterial);

        lastTexelSize = texelSize;
    }

    private void OnEnable()
    {
        SetupDistortedImageEffect();
    }

    private void OnDisable()
    {
        if (mainMaterial != null)
            DestroyImmediate(mainMaterial);
    }

    #endregion

    #region Class Functions

    private void SetupDistortedImageEffect()
    {
        if (MainMaterial != null)
            MainMaterial.SetTexture("_MonitorLine", monitorLine);
    }

    #endregion
}
