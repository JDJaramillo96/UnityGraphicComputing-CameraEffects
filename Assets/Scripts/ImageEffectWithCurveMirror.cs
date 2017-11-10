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

    //Kernel
    private float[,] kernel;
    private float delta; //For 3x3 kernel => delta = 0.1666666667 (1/6); For 5x5 kernel => delta = 0.1 (1/10); . . .
    private float normalize;

    //Hidden
    private float lastTexelSize;
    private float lastCurve;

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

        Graphics.Blit(source, destination, MainMaterial);

        lastTexelSize = texelSize;

        lastCurve = curve.Evaluate(0.33f) + curve.Evaluate(0.66f) + curve.Evaluate(0.99f);
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

        delta = (1.0f / (float)(kernelSize * 2));

        normalize = (1.0f / (float) kernel.Length);

        EstimateKernel();
    }

    private void EstimateKernel()
    {
        float rowEvaluatePoint = delta;
        float columnEvaluatePoint = delta;

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

                columnEvaluatePoint += (2 * delta);
            }

            columnEvaluatePoint = delta;

            rowEvaluatePoint += (2 * delta);
        }

        rowEvaluatePoint = delta;
    }

    #endregion
}
