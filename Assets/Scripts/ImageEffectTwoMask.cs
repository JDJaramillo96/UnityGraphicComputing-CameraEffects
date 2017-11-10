using UnityEngine;

[ExecuteInEditMode]
public class ImageEffectTwoMask : MonoBehaviour {

    #region Properties

    public Shader shader;
    public float texelSize01 = 1f;
    public float texelSize02 = 1f;

    [Space(10f)]

    [SerializeField]
    private Texture mask01;
    [SerializeField]
    private Texture mask02;

    //Hidden
    private float lastTexelSize01;
    private float lastTexelSize02;

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

        SetupMask();
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (lastTexelSize01 != texelSize01)
            MainMaterial.SetFloat("_TexelSize01", texelSize01);

        if (lastTexelSize02 != texelSize02)
            MainMaterial.SetFloat("_TexelSize02", texelSize02);

        Graphics.Blit(source, destination, MainMaterial);

        lastTexelSize01 = texelSize01;
        lastTexelSize02 = texelSize02;
    }

    private void OnEnable()
    {
        SetupMask();
    }

    private void OnDisable()
    {
        if (mainMaterial != null)
            DestroyImmediate(mainMaterial);
    }

    #endregion

    #region Class Functions

    private void SetupMask()
    {
        if (MainMaterial != null)
            MainMaterial.SetTexture("_MaskTex01", mask01);

        if (MainMaterial != null)
            MainMaterial.SetTexture("_MaskTex02", mask02);
    }

    #endregion
}
