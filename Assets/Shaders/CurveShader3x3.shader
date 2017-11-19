Shader "Hidden/CurveShader3x3"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_TexelSize("Texel Size", Float) = 1
		_Factor("Factor", Float) = 1
		//Matrix values
		_m00("m00", Float) = 0
		_m01("m01", Float) = 0
		_m02("m02", Float) = 0
		_m10("m10", Float) = 0
		_m11("m11", Float) = 0
		_m12("m12", Float) = 0
		_m20("m20", Float) = 0
		_m21("m21", Float) = 0
		_m22("m22", Float) = 0
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
			float _Factor;
			
			//KERNEL!
			float _m00;
			float _m01;
			float _m02;
			float _m10;
			float _m11;
			float _m12;
			float _m20;
			float _m21;
			float _m22;

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
					_m00 * _Factor, _m01 * _Factor, _m02 * _Factor, //First row
					_m10 * _Factor, _m11 * _Factor, _m12 * _Factor, //Second row
					_m20 * _Factor, _m21 * _Factor, _m22 * _Factor //Third row
				);

				float4 finalImage;

				finalImage.rgb = Convultion(i.uv, texelSize, kernel);

				return finalImage;
			}

			ENDCG
		}
	}
}

