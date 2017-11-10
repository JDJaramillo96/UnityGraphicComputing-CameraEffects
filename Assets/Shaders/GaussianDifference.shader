Shader "Hidden/GaussianDifference"
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

				//GAUSSIAN BLUR 5X5!

				//First row
				float _m00 = 0.00;
				float _m01 = 0.02;
				float _m02 = 0.02;
				float _m03 = 0.02;
				float _m04 = 0.00;
				//Second row
				float _m10 = 0.02;
				float _m11 = 0.06;
				float _m12 = 0.09;
				float _m13 = 0.06;
				float _m14 = 0.02;
				//Third row
				float _m20 = 0.02;
				float _m21 = 0.09;
				float _m22 = 0.14;
				float _m23 = 0.09;
				float _m24 = 0.02;
				//Fourth row
				float _m30 = 0.02;
				float _m31 = 0.06;
				float _m32 = 0.09;
				float _m33 = 0.06;
				float _m34 = 0.02;
				//Fifth row
				float _m40 = 0.00;
				float _m41 = 0.02;
				float _m42 = 0.02;
				float _m43 = 0.02;
				float _m44 = 0.00;

				float3 gaussian5x5Image;
				
				/**/
				float3 texel00 = tex2D(_MainTex, float2(i.uv.x - (2 * texelSize.x), i.uv.y - (2 * texelSize.y))) * _m00;
				float3 texel10 = tex2D(_MainTex, float2(i.uv.x - (2 * texelSize.x), i.uv.y - texelSize.y)) * _m10;
				float3 texel20 = tex2D(_MainTex, float2(i.uv.x - (2 * texelSize.x), i.uv.y)) * _m20;
				float3 texel30 = tex2D(_MainTex, float2(i.uv.x - (2 * texelSize.x), i.uv.y + texelSize.y)) * _m30;
				float3 texel40 = tex2D(_MainTex, float2(i.uv.x - (2 * texelSize.x), i.uv.y + (2 * texelSize.y))) * _m40;
				/**/
				float3 texel01 = tex2D(_MainTex, float2(i.uv.x - texelSize.x, i.uv.y - (2 * texelSize.y))) * _m01;
				float3 texel11 = tex2D(_MainTex, float2(i.uv.x - texelSize.x, i.uv.y - texelSize.y)) * _m11;
				float3 texel21 = tex2D(_MainTex, float2(i.uv.x - texelSize.x, i.uv.y)) * _m21;
				float3 texel31 = tex2D(_MainTex, float2(i.uv.x - texelSize.x, i.uv.y + texelSize.y)) * _m31;
				float3 texel41 = tex2D(_MainTex, float2(i.uv.x - texelSize.x, i.uv.y + (2 * texelSize.y))) * _m41;
				/**/
				float3 texel02 = tex2D(_MainTex, float2(i.uv.x, i.uv.y - (2 * texelSize.y))) * _m02;
				float3 texel12 = tex2D(_MainTex, float2(i.uv.x, i.uv.y - texelSize.y)) * _m12;
				float3 texel22 = tex2D(_MainTex, float2(i.uv.x, i.uv.y)) * _m22;
				float3 texel32 = tex2D(_MainTex, float2(i.uv.x, i.uv.y + texelSize.y)) * _m32;
				float3 texel42 = tex2D(_MainTex, float2(i.uv.x, i.uv.y + (2 * texelSize.y))) * _m42;
				/**/
				float3 texel03 = tex2D(_MainTex, float2(i.uv.x + texelSize.x, i.uv.y - (2 * texelSize.y))) * _m03;
				float3 texel13 = tex2D(_MainTex, float2(i.uv.x + texelSize.x, i.uv.y - texelSize.y)) * _m13;
				float3 texel23 = tex2D(_MainTex, float2(i.uv.x + texelSize.x, i.uv.y)) * _m23;
				float3 texel33 = tex2D(_MainTex, float2(i.uv.x + texelSize.x, i.uv.y + texelSize.y)) * _m33;
				float3 texel43 = tex2D(_MainTex, float2(i.uv.x + texelSize.x, i.uv.y + (2 * texelSize.y))) * _m43;
				/**/
				float3 texel04 = tex2D(_MainTex, float2(i.uv.x + (2 * texelSize.x), i.uv.y - (2 * texelSize.y))) * _m04;
				float3 texel14 = tex2D(_MainTex, float2(i.uv.x + (2 * texelSize.x), i.uv.y - texelSize.y)) * _m14;
				float3 texel24 = tex2D(_MainTex, float2(i.uv.x + (2 * texelSize.x), i.uv.y)) * _m24;
				float3 texel34 = tex2D(_MainTex, float2(i.uv.x + (2 * texelSize.x), i.uv.y + texelSize.y)) * _m34;
				float3 texel44 = tex2D(_MainTex, float2(i.uv.x + (2 * texelSize.x), i.uv.y + (2 * texelSize.y))) * _m44;

				gaussian5x5Image =
					texel00 + texel01 + texel02 + texel03 + texel04 +
					texel10 + texel11 + texel12 + texel13 + texel14 +
					texel20 + texel21 + texel22 + texel23 + texel24 +
					texel30 + texel31 + texel32 + texel33 + texel34 +
					texel40 + texel41 + texel42 + texel43 + texel44;

				//GAUSSIAN BLUR 3X3!
				float3x3 kernel = float3x3(
					0.06, 0.13, 0.06, //First row
					0.13, 0.25, 0.13, //Second row
					0.06, 0.13, 0.06 //Third row
				);

				float3 gaussian3x3Image;

				gaussian3x3Image = Convultion(i.uv, texelSize, kernel);

				//Gaussian difference
				float3 gaussianDifference;

				gaussianDifference = gaussian5x5Image - gaussian3x3Image;

				float gaussianDifferenceCorrection = (gaussianDifference.r + gaussianDifference.g + gaussianDifference.b) / 3.0;

				return float4(gaussianDifferenceCorrection, gaussianDifferenceCorrection, gaussianDifferenceCorrection, 1);
			}

			ENDCG
		}
	}
}
