using UnityEngine;

[ExecuteInEditMode]
public class ImageEffectWithCurveMirror : MonoBehaviour {

    #region Properties

    public Shader shader;
    public float texelSize = 1f;

    [Space(10f)]

    [SerializeField]
    private AnimationCurve curve;
    [SerializeField]
    private int kernelSize; //For 3x3 kernel => kernelSize = 3; For 5x5 kernel => kernelSize = 5; . . .
    [SerializeField]
    private float factor;

    //Kernel
    private float[,] kernel;
    private float step; //For 3x3 kernel => delta = 0.1666666667 (1/6); For 5x5 kernel => delta = 0.1 (1/10); . . .
    private float normalize;

    //Hidden
    private float lastTexelSize;
    private float lastCurve;
    private float lastFactor;

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

        SetupKernel();
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (lastTexelSize != texelSize)
            MainMaterial.SetFloat("_TexelSize", texelSize);

        if (lastCurve != curve.Evaluate(0.33f) + curve.Evaluate(0.66f) + curve.Evaluate(0.99f))
            EstimateKernel();

        if (lastFactor != factor)
            MainMaterial.SetFloat("_Factor", factor);

        Graphics.Blit(source, destination, MainMaterial);

        lastTexelSize = texelSize;

        lastCurve = curve.Evaluate(0.33f) + curve.Evaluate(0.66f) + curve.Evaluate(0.99f);

        lastFactor = factor;
    }

    private void OnEnable()
    {
        SetupKernel();
    }

    private void OnDisable()
    {
        if (mainMaterial != null)
            DestroyImmediate(mainMaterial);
    }

    #endregion

    #region Class Functions

    private void SetupKernel()
    {
        kernel = new float[kernelSize, kernelSize];

        step = (1.0f / (kernelSize * 2.0f));

        normalize = (1.0f / kernel.Length);

        EstimateKernel();
    }

    private void EstimateKernel()
    {
        float rowEvaluatePoint = step;
        float columnEvaluatePoint = step;

        float rowEvaluateValue;
        float columnEvaluateValue;

        for (int row = 0; row < kernelSize; row++)
        {
            rowEvaluateValue = curve.Evaluate(rowEvaluatePoint);

            for (int column = 0; column < kernelSize; column++)
            {
                columnEvaluateValue = curve.Evaluate(columnEvaluatePoint);

                float kernelFinalValue = 
                    (rowEvaluateValue + 
                    columnEvaluateValue) * normalize;

                kernel[row, column] = kernelFinalValue;

                /*
                Debug.Log(string.Format("{0},{1} = {2}",
                    row.ToString(),
                    column.ToString(),
                    kernelFinalValue));
                */

                MainMaterial.SetFloat(string.Format("_m{0}{1}",
                    row.ToString(),
                    column.ToString()),
                    kernelFinalValue);

                columnEvaluatePoint += (2 * step);
            }

            columnEvaluatePoint = step;

            rowEvaluatePoint += (2 * step);
        }

        rowEvaluatePoint = step;
    }

    #endregion
}
