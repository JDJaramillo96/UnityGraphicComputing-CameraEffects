Shader "Hidden/RadialDistortion"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_MonitorLine("Monitor Line", 2D) = "white" {}
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
			sampler2D _MonitorLine;
			float4 _MainTex_TexelSize;
			float _TexelSize;

			//CONVULTION FUNCTION!
			inline float3 Convultion(float2 uv, float2 texelSize, float3x3 kernel)
			{
				float3 finalColor = float3(0, 0, 0);

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

			// ***
			// Taked From: https://github.com/manuelbua/libgdx-contribs/blob/master/postprocessing/src/main/resources/shaders/radial-distortion.fragment
			// ***
			inline float2 RadialDistortion(float2 coord, float distortion)
			{
				float2 cc = coord - 0.5;
				float dist = dot(cc, cc) * distortion;
				return (coord + cc * (1.0 + dist) * dist);
			}

			//FRAG FUNCTION!
			float4 frag (v2f_img i) : SV_Target
			{
				float2 texelSize = _MainTex_TexelSize * _TexelSize;

				// ***
				// Taked From: https://github.com/manuelbua/libgdx-contribs/blob/master/postprocessing/src/main/resources/shaders/radial-distortion.fragment
				// ***
				
				//RADIAL DISTORTION! ***
				float distortion = 0.35; // default = 0.3
				float zoom = 0.9; // default = 1
				
				float2 newUV = RadialDistortion(i.uv, distortion);
				
				newUV = 0.5 + (newUV - 0.5) * (zoom);

				float overTime = sin(_Time.w); //sin return between -1 and 1

				overTime + 1;
				overTime *= 0.5;

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
				float3 xConvultion = Convultion(float2(newUV.x, (newUV.y + (overTime * 0.005))), texelSize, xSobelKernel);
				float3 yConvultion = Convultion(float2(newUV.x, (newUV.y + (overTime * 0.005))), texelSize, ySobelKernel);
				
				//Final sobel image
				float sobel = Sobel(xConvultion.r, yConvultion.r);

				//Final image
				float4 originalImage = tex2D(_MainTex, float2(newUV.x, (newUV.y + (overTime * 0.005))));

				float monitorLine = tex2D(_MonitorLine, float2(newUV.x, (newUV.y + (overTime * 0.005))));
				
				return ((originalImage - sobel) * 0.75) + (monitorLine * 0.25);
			}

			ENDCG
		}
	}
}
