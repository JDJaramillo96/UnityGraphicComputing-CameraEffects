Shader "Hidden/GaussianBlur5x5"
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
			inline float3 Convultion(float2 uv, float2 texelSize)
			{
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

				float4 gaussian5x5Image;

				/**/
				float4 texel00 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y - (2 * texelSize.y))) * _m00;
				float4 texel10 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y - texelSize.y)) * _m10;
				float4 texel20 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y)) * _m20;
				float4 texel30 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y + texelSize.y)) * _m30;
				float4 texel40 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y + (2 * texelSize.y))) * _m40;
				/**/
				float4 texel01 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y - (2 * texelSize.y))) * _m01;
				float4 texel11 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y - texelSize.y)) * _m11;
				float4 texel21 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y)) * _m21;
				float4 texel31 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y + texelSize.y)) * _m31;
				float4 texel41 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y + (2 * texelSize.y))) * _m41;
				/**/
				float4 texel02 = tex2D(_MainTex, float2(uv.x, uv.y - (2 * texelSize.y))) * _m02;
				float4 texel12 = tex2D(_MainTex, float2(uv.x, uv.y - texelSize.y)) * _m12;
				float4 texel22 = tex2D(_MainTex, float2(uv.x, uv.y)) * _m22;
				float4 texel32 = tex2D(_MainTex, float2(uv.x, uv.y + texelSize.y)) * _m32;
				float4 texel42 = tex2D(_MainTex, float2(uv.x, uv.y + (2 * texelSize.y))) * _m42;
				/**/
				float4 texel03 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y - (2 * texelSize.y))) * _m03;
				float4 texel13 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y - texelSize.y)) * _m13;
				float4 texel23 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y)) * _m23;
				float4 texel33 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y + texelSize.y)) * _m33;
				float4 texel43 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y + (2 * texelSize.y))) * _m43;
				/**/
				float4 texel04 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y - (2 * texelSize.y))) * _m04;
				float4 texel14 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y - texelSize.y)) * _m14;
				float4 texel24 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y)) * _m24;
				float4 texel34 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y + texelSize.y)) * _m34;
				float4 texel44 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y + (2 * texelSize.y))) * _m44;

				gaussian5x5Image =
					texel00 + texel01 + texel02 + texel03 + texel04 +
					texel10 + texel11 + texel12 + texel13 + texel14 +
					texel20 + texel21 + texel22 + texel23 + texel24 +
					texel30 + texel31 + texel32 + texel33 + texel34 +
					texel40 + texel41 + texel42 + texel43 + texel44;

				return gaussian5x5Image;
			}

			//FRAG FUNCTION!
			float4 frag(v2f_img i) : SV_Target
			{
				float2 texelSize = _MainTex_TexelSize * _TexelSize;

				//Final image
				float4 finalImage;

				finalImage.rgb = Convultion(i.uv, texelSize);

				return finalImage;
			}

			ENDCG
		}
	}
}
