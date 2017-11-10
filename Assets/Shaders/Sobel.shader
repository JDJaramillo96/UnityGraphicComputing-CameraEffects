Shader "Hidden/Sobel"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_TexelSize("Texel Size", Float) = 1
	}
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc"

			//PROPERTIES!
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;
			float _TexelSize;

			//CONVULTION FUNCTION!
			inline float3 Convultion(float2 uv, float2 texelSize, float3x3 kernel)
			{
				float3 finalColor;

				for (int row = 0; row < 3; row++)
				{
					for (int column = 0; column < 3; column++)
					{
						//new UV
						float2 newUV = float2(
							(uv.x - texelSize.x) + column * texelSize.x,
							(uv.y - texelSize.y) + row * texelSize.y
						);

						//New color
						float3 newColor = tex2D(_MainTex, newUV);

						//Returned color
						finalColor += newColor * kernel[row][column];
					}
				}

				return finalColor;
			}

			inline float Sobel(float xSobel, float ySobel)
			{
				return sqrt((xSobel * xSobel) + (ySobel * ySobel));
			}

			//FRAG FUNCTION!
			float4 frag (v2f_img i) : SV_Target
			{
				float2 texelSize = _MainTex_TexelSize * _TexelSize;

				//SOBEL! ***
				float3x3 xSobelKernel = float3x3(
					1.0, 2.0, 1.0, //First row
					0.0, 0.0, 0.0, //Second row
					-1.0, -2.0, -1.0 //Third row
				);

				float3x3 ySobelKernel = float3x3(
					1.0, 0.0, -1.0, //First row
					2.0, 0.0, -2.0, //Second row
					1.0, 0.0, -1.0 //Third row
				);

				//Convultions
				float3 xConvultion = Convultion(i.uv, texelSize, xSobelKernel);
				float3 yConvultion = Convultion(i.uv, texelSize, ySobelKernel);
				
				//Final sobel image
				float sobel = Sobel(xConvultion.r, yConvultion.r);

				//Final image
				return float4(sobel, sobel, sobel, 1);
			}

			ENDCG
		}
	}
}

