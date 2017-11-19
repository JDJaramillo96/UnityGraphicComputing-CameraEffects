Shader "Hidden/DistortionEffect"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Distortion("Distortion", Float) = 0
		_DistortionVelocity("Distortion Velocity", Float) = 1
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
			float _Distortion;
			float _DistortionVelocity;
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

				//DISTORTION! ***
				float2 originalUV = i.uv;

				const float pi = 3.14159;

				float radius = sqrt((originalUV.x * originalUV.x) + (originalUV.y * originalUV.y));
				
				float angle;
				
				if (sign(originalUV.y) > 0 && sign(originalUV.x) > 0)
					angle = atan(originalUV.y / originalUV.x);
				else if (sign(originalUV.y) > 0 && sign(originalUV.x) < 0)
					angle = pi - atan(originalUV.y / originalUV.x);
				else if (sign(originalUV.y) < 0 && sign(originalUV.x) < 0)
					angle = pi + atan(originalUV.y / originalUV.x);
				else if (sign(originalUV.y) < 0 && sign(originalUV.x) > 0)
					angle = (2 * pi) - atan(originalUV.y / originalUV.x);
				else if (sign(originalUV.y) == 0 && sign(originalUV.x) > 0)
					angle = 0;
				else if (sign(originalUV.y) == 0 && sign(originalUV.x) < 0)
					angle = pi;
				else if (sign(originalUV.y) > 0 && sign(originalUV.x) == 0)
					angle = pi * 0.5;
				else if (sign(originalUV.y) < 0 && sign(originalUV.x) == 0)
					angle = pi * 1.5;

				angle -= (pi * _Distortion);

				float overTime = sin(_Time.y * _DistortionVelocity);

				overTime *= 0.5;
				overTime += 0.5;
				
				angle += (pi * _Distortion * 2) * overTime;

				float2 newUV;

				newUV.x = radius * cos(angle);
				newUV.y = radius * sin(angle);

				float4 finalImage;

				finalImage.rgb = tex2D(_MainTex, newUV);

				return float4(finalImage.rgb, 1);
			}

			ENDCG
		}
	}
}
