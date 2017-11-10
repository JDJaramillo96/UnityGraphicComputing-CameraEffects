using UnityEngine;

[ExecuteInEditMode]
public class ImageEffect : MonoBehaviour {

    #region Properties

    public Shader shader;
    public float texelSize = 1f;

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
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (lastTexelSize != texelSize)
            MainMaterial.SetFloat("_TexelSize", texelSize);

        Graphics.Blit(source, destination, MainMaterial);

        lastTexelSize = texelSize;
    }

    private void OnDisable()
    {
        if (mainMaterial != null)
            DestroyImmediate(mainMaterial);
    }

    #endregion
}
