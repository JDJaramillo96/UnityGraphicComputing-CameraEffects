Shader "Hidden/GaussianBlur3x3"
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

			//CONVULTION!
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

			//FRAG FUNCTION!
			float4 frag(v2f_img i) : SV_Target
			{
				float2 texelSize = _MainTex_TexelSize * _TexelSize;
				
				//Kernel declaration
				float3x3 kernel = float3x3(
					0.06, 0.13, 0.06, //First row
					0.13, 0.25, 0.13, //Second row
					0.06, 0.13, 0.06 //Third row
				);

				float4 finalImage;
					
				finalImage.rgb = Convultion(i.uv, texelSize, kernel);

				return finalImage;
			}

			ENDCG
		}
	}
}

