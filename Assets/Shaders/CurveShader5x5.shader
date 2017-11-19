Shader "Hidden/CurveShader5x5"
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
		_m03("m03", Float) = 0
		_m04("m04", Float) = 0
		_m10("m10", Float) = 0
		_m11("m11", Float) = 0
		_m12("m12", Float) = 0
		_m13("m13", Float) = 0
		_m14("m14", Float) = 0
		_m20("m20", Float) = 0
		_m21("m21", Float) = 0
		_m22("m22", Float) = 0
		_m23("m23", Float) = 0
		_m24("m24", Float) = 0
		_m30("m30", Float) = 0
		_m31("m31", Float) = 0
		_m32("m32", Float) = 0
		_m33("m33", Float) = 0
		_m34("m34", Float) = 0
		_m40("m40", Float) = 0
		_m41("m41", Float) = 0
		_m42("m42", Float) = 0
		_m43("m43", Float) = 0
		_m44("m44", Float) = 0
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

			//Matrix values
			float _m00;
			float _m01;
			float _m02;
			float _m03;
			float _m04;
			float _m10;
			float _m11;
			float _m12;
			float _m13;
			float _m14;
			float _m20;
			float _m21;
			float _m22;
			float _m23;
			float _m24;
			float _m30;
			float _m31;
			float _m32;
			float _m33;
			float _m34;
			float _m40;
			float _m41;
			float _m42;
			float _m43;
			float _m44;

			//CONVULTION!
			inline float3 Convultion(float2 uv, float2 texelSize)
			{
				float3 finalColor;

				/**/
				float3 texel00 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y - (2 * texelSize.y))) * _m00 * _Factor;
				float3 texel10 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y - texelSize.y)) * _m10 * _Factor;
				float3 texel20 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y)) * _m20 * _Factor;
				float3 texel30 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y + texelSize.y)) * _m30 * _Factor;
				float3 texel40 = tex2D(_MainTex, float2(uv.x - (2 * texelSize.x), uv.y + (2 * texelSize.y))) * _m40 * _Factor;
				/**/
				float3 texel01 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y - (2 * texelSize.y))) * _m01 * _Factor;
				float3 texel11 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y - texelSize.y)) * _m11 * _Factor;
				float3 texel21 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y)) * _m21 * _Factor;
				float3 texel31 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y + texelSize.y)) * _m31 * _Factor;
				float3 texel41 = tex2D(_MainTex, float2(uv.x - texelSize.x, uv.y + (2 * texelSize.y))) * _m41 * _Factor;
				/**/
				float3 texel02 = tex2D(_MainTex, float2(uv.x, uv.y - (2 * texelSize.y))) * _m02 * _Factor;
				float3 texel12 = tex2D(_MainTex, float2(uv.x, uv.y - texelSize.y)) * _m12 * _Factor;
				float3 texel22 = tex2D(_MainTex, float2(uv.x, uv.y)) * _m22 * _Factor;
				float3 texel32 = tex2D(_MainTex, float2(uv.x, uv.y + texelSize.y)) * _m32 * _Factor;
				float3 texel42 = tex2D(_MainTex, float2(uv.x, uv.y + (2 * texelSize.y))) * _m42 * _Factor;
				/**/
				float3 texel03 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y - (2 * texelSize.y))) * _m03 * _Factor;
				float3 texel13 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y - texelSize.y)) * _m13 * _Factor;
				float3 texel23 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y)) * _m23 * _Factor;
				float3 texel33 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y + texelSize.y)) * _m33 * _Factor;
				float3 texel43 = tex2D(_MainTex, float2(uv.x + texelSize.x, uv.y + (2 * texelSize.y))) * _m43 * _Factor;
				/**/
				float3 texel04 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y - (2 * texelSize.y))) * _m04 * _Factor;
				float3 texel14 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y - texelSize.y)) * _m14 * _Factor;
				float3 texel24 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y)) * _m24 * _Factor;
				float3 texel34 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y + texelSize.y)) * _m34 * _Factor;
				float3 texel44 = tex2D(_MainTex, float2(uv.x + (2 * texelSize.x), uv.y + (2 * texelSize.y))) * _m44  *_Factor;

				finalColor =
					texel00 + texel01 + texel02 + texel03 + texel04 +
					texel10 + texel11 + texel12 + texel13 + texel14 +
					texel20 + texel21 + texel22 + texel23 + texel24 +
					texel30 + texel31 + texel32 + texel33 + texel34 +
					texel40 + texel41 + texel42 + texel43 + texel44;

				return finalColor;
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
